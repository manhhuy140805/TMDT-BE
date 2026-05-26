import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import type { Prisma } from '@prisma/client';
import { PrismaService } from '../../common/prisma/prisma.service';
import type {
  CreateRefundRequestDto,
  DecideRefundRequestDto,
  RefundRequestDto,
  RefundRequestListResponseDto,
  RefundRequestMutationResponseDto,
  RefundRequestResponseDto,
} from './dto';

const SYSTEM_FEE_PERCENT = 0.05;
const EARLY_SETTLEMENT_SHARE = 0.1;

const REFUND_REQUEST_SELECT = {
  YeuCauHoanTienID: true,
  CongViecID: true,
  NguoiThueID: true,
  FreelancerID: true,
  LyDo: true,
  MoTa: true,
  TrangThai: true,
  TongEscrow: true,
  PhiHeThong: true,
  TienFreelancer: true,
  TienGiamSat: true,
  TienHoan: true,
  TranhChapID: true,
  NgayTao: true,
  NgayPhanHoi: true,
} as const;

type RefundRequestEntity = Prisma.YeuCauHoanTienGetPayload<{
  select: typeof REFUND_REQUEST_SELECT;
}>;

@Injectable()
export class RefundRequestsService {
  constructor(private readonly prisma: PrismaService) {}

  async findById(id: number): Promise<RefundRequestResponseDto> {
    const refundRequest = await this.prisma.yeuCauHoanTien.findUnique({
      where: { YeuCauHoanTienID: id },
      select: REFUND_REQUEST_SELECT,
    });

    if (!refundRequest) {
      throw new NotFoundException('Yeu cau hoan tien khong ton tai');
    }

    return { refundRequest: this.toRefundRequestDto(refundRequest) };
  }

  async findByContractId(
    contractId: number,
  ): Promise<RefundRequestListResponseDto> {
    const refundRequests = await this.prisma.yeuCauHoanTien.findMany({
      where: { CongViecID: contractId },
      select: REFUND_REQUEST_SELECT,
      orderBy: { NgayTao: 'desc' },
    });

    return {
      total: refundRequests.length,
      refundRequests: refundRequests.map((request) =>
        this.toRefundRequestDto(request),
      ),
    };
  }

  async create(
    payload: CreateRefundRequestDto,
  ): Promise<RefundRequestMutationResponseDto> {
    const contract = await this.prisma.congViec.findUnique({
      where: { CongViecID: payload.congViecId },
    });

    if (!contract) {
      throw new NotFoundException('Hop dong khong ton tai');
    }

    if (contract.NguoiThueID !== payload.nguoiThueId) {
      throw new BadRequestException(
        'Chi nguoi thue cua hop dong moi co the yeu cau hoan tien',
      );
    }

    if (contract.TrangThai === 'DaHuy' || contract.TrangThai === 'TranhChap') {
      throw new BadRequestException(
        'Hop dong da huy hoac dang tranh chap, khong the tao yeu cau hoan tien moi',
      );
    }

    const lyDo = payload.lyDo?.trim();
    if (!lyDo) {
      throw new BadRequestException('Ly do yeu cau hoan tien la bat buoc');
    }

    const [pendingRequest, deposit, paidOut] = await Promise.all([
      this.prisma.yeuCauHoanTien.findFirst({
        where: {
          CongViecID: payload.congViecId,
          TrangThai: 'ChoFreelancerDuyet',
        },
        select: { YeuCauHoanTienID: true },
      }),
      this.prisma.thanhToan.findFirst({
        where: {
          CongViecID: payload.congViecId,
          LoaiTT: 'DatCoc',
          TrangThai: 'ThanhCong',
        },
        orderBy: { NgayTao: 'desc' },
      }),
      this.prisma.thanhToan.findFirst({
        where: {
          CongViecID: payload.congViecId,
          LoaiTT: {
            in: ['ThanhToanCuoi', 'HoanTien', 'PhiHeThong', 'PhiGiamSat'],
          },
          TrangThai: 'ThanhCong',
        },
        select: { ThanhToanID: true },
      }),
    ]);

    if (pendingRequest) {
      throw new BadRequestException(
        'Hop dong dang co yeu cau hoan tien cho freelancer phan hoi',
      );
    }

    if (!deposit || paidOut) {
      throw new BadRequestException(
        'Tien escrow khong con duoc giu de thuc hien hoan tien truc tiep',
      );
    }

    const settlement = this.calculateSettlement(
      Number(deposit.SoTien),
      Number(contract.GiaThoa),
    );

    const refundRequest = await this.prisma.$transaction(async (tx) => {
      const created = await tx.yeuCauHoanTien.create({
        data: {
          CongViecID: contract.CongViecID,
          NguoiThueID: contract.NguoiThueID,
          FreelancerID: contract.FreelancerID,
          LyDo: lyDo,
          MoTa: payload.moTa?.trim() || null,
          ...settlement,
        },
        select: REFUND_REQUEST_SELECT,
      });

      await tx.thongBao.create({
        data: {
          TaiKhoanID: contract.FreelancerID,
          TieuDe: 'Yeu cau hoan tien moi',
          NoiDung: `Nguoi thue da gui yeu cau hoan tien cho cong viec #${contract.CongViecID}.`,
          LoaiThongBao: 'ThanhToan',
        },
      });

      return created;
    });

    return {
      message: 'Da gui yeu cau hoan tien cho freelancer phan hoi',
      refundRequest: this.toRefundRequestDto(refundRequest),
    };
  }

  async accept(
    id: number,
    payload: DecideRefundRequestDto,
  ): Promise<RefundRequestMutationResponseDto> {
    const refundRequest = await this.findEntityOrThrow(id);
    this.validateFreelancerDecision(refundRequest, payload);

    const settledRequest = await this.prisma.$transaction(async (tx) => {
      const contract = await tx.congViec.findUniqueOrThrow({
        where: { CongViecID: refundRequest.CongViecID },
      });

      if (
        contract.TrangThai === 'DaHuy' ||
        contract.TrangThai === 'TranhChap'
      ) {
        throw new BadRequestException(
          'Hop dong da huy hoac dang tranh chap, khong the dong y hoan tien',
        );
      }

      const paidOut = await tx.thanhToan.findFirst({
        where: {
          CongViecID: refundRequest.CongViecID,
          LoaiTT: {
            in: ['ThanhToanCuoi', 'HoanTien', 'PhiHeThong', 'PhiGiamSat'],
          },
          TrangThai: 'ThanhCong',
        },
        select: { ThanhToanID: true },
      });

      if (paidOut) {
        throw new BadRequestException(
          'Escrow da duoc phan bo, khong the hoan tien truc tiep',
        );
      }

      const claimed = await tx.yeuCauHoanTien.updateMany({
        where: {
          YeuCauHoanTienID: id,
          TrangThai: 'ChoFreelancerDuyet',
        },
        data: {
          TrangThai: 'DaDongY',
          NgayPhanHoi: new Date(),
        },
      });

      if (claimed.count !== 1) {
        throw new BadRequestException('Yeu cau hoan tien da duoc phan hoi');
      }

      const deposit = await tx.thanhToan.findFirst({
        where: {
          CongViecID: refundRequest.CongViecID,
          LoaiTT: 'DatCoc',
          TrangThai: 'ThanhCong',
        },
        orderBy: { NgayTao: 'desc' },
      });

      if (!deposit) {
        throw new BadRequestException('Khong tim thay escrow dang duoc giu');
      }

      await tx.thanhToan.update({
        where: { ThanhToanID: deposit.ThanhToanID },
        data: { TrangThai: 'DaHoan' },
      });

      await tx.thanhToan.createMany({
        data: [
          {
            CongViecID: refundRequest.CongViecID,
            TaiKhoanID: refundRequest.NguoiThueID,
            SoTien: refundRequest.TienHoan,
            LoaiTT: 'HoanTien',
            PhuongThuc: 'Vi',
            TrangThai: 'ThanhCong',
            GhiChu: `Hoan tien theo yeu cau #${id} da duoc freelancer dong y`,
          },
          {
            CongViecID: refundRequest.CongViecID,
            TaiKhoanID: refundRequest.NguoiThueID,
            SoTien: refundRequest.TienFreelancer,
            LoaiTT: 'ThanhToanCuoi',
            PhuongThuc: 'Vi',
            TrangThai: 'ThanhCong',
            GhiChu: `Freelancer nhan 10% khi dong y hoan tien #${id}`,
          },
          {
            CongViecID: refundRequest.CongViecID,
            TaiKhoanID: refundRequest.NguoiThueID,
            SoTien: refundRequest.TienGiamSat,
            LoaiTT: 'PhiGiamSat',
            PhuongThuc: 'Vi',
            TrangThai: 'ThanhCong',
            GhiChu: `Giam sat nhan 10% khi hoan tien #${id}`,
          },
          {
            CongViecID: refundRequest.CongViecID,
            TaiKhoanID: refundRequest.NguoiThueID,
            SoTien: refundRequest.PhiHeThong,
            LoaiTT: 'PhiHeThong',
            PhuongThuc: 'Vi',
            TrangThai: 'ThanhCong',
            GhiChu: `Phi he thong 5% khi hoan tien #${id}`,
          },
        ],
      });

      await tx.freelancer.update({
        where: { TaiKhoanID: refundRequest.FreelancerID },
        data: { SoDu: { increment: refundRequest.TienFreelancer } },
      });

      await tx.congViec.update({
        where: { CongViecID: refundRequest.CongViecID },
        data: {
          TrangThai: 'DaHuy',
          TrangThaiGiamSat: 'HoanThanh',
          NgayKetThuc: new Date(),
        },
      });

      await tx.yeuCauGiamSat.updateMany({
        where: {
          CongViecID: refundRequest.CongViecID,
          TrangThai: 'DaChapNhan',
        },
        data: {
          TrangThai: 'HoanThanh',
          NgayHoanThanh: new Date(),
        },
      });

      await tx.thongBao.createMany({
        data: [
          {
            TaiKhoanID: refundRequest.NguoiThueID,
            TieuDe: 'Yeu cau hoan tien da duoc dong y',
            NoiDung: `Tien hoan cua cong viec #${refundRequest.CongViecID} da duoc xu ly.`,
            LoaiThongBao: 'ThanhToan',
          },
          {
            TaiKhoanID: contract.GiamSatID,
            TieuDe: 'Cong viec ket thuc do hoan tien',
            NoiDung: `Cong viec #${refundRequest.CongViecID} da hoan tien theo thoa thuan.`,
            LoaiThongBao: 'GiamSat',
          },
        ],
      });

      return tx.yeuCauHoanTien.findUniqueOrThrow({
        where: { YeuCauHoanTienID: id },
        select: REFUND_REQUEST_SELECT,
      });
    });

    return {
      message: 'Freelancer da dong y, tien da duoc phan bo va hoan lai',
      refundRequest: this.toRefundRequestDto(settledRequest),
      settlement: {
        tienHoanNguoiThue: settledRequest.TienHoan.toString(),
        tienFreelancer: settledRequest.TienFreelancer.toString(),
        tienGiamSat: settledRequest.TienGiamSat.toString(),
        phiHeThong: settledRequest.PhiHeThong.toString(),
      },
    };
  }

  async reject(
    id: number,
    payload: DecideRefundRequestDto,
  ): Promise<RefundRequestMutationResponseDto> {
    const refundRequest = await this.findEntityOrThrow(id);
    this.validateFreelancerDecision(refundRequest, payload);

    const rejectedRequest = await this.prisma.$transaction(async (tx) => {
      const activeDispute = await tx.tranhChap.findFirst({
        where: {
          CongViecID: refundRequest.CongViecID,
          TrangThai: { in: ['MoiMo', 'DangXuLy'] },
        },
        select: { TranhChapID: true },
      });

      if (activeDispute) {
        throw new BadRequestException('Cong viec dang co tranh chap can xu ly');
      }

      const claimed = await tx.yeuCauHoanTien.updateMany({
        where: {
          YeuCauHoanTienID: id,
          TrangThai: 'ChoFreelancerDuyet',
        },
        data: {
          TrangThai: 'DaTuChoi',
          NgayPhanHoi: new Date(),
        },
      });

      if (claimed.count !== 1) {
        throw new BadRequestException('Yeu cau hoan tien da duoc phan hoi');
      }

      const contract = await tx.congViec.findUniqueOrThrow({
        where: { CongViecID: refundRequest.CongViecID },
      });

      if (contract.TrangThai !== 'HoanThanh') {
        await tx.congViec.update({
          where: { CongViecID: refundRequest.CongViecID },
          data: { TrangThai: 'TranhChap' },
        });
      }

      const dispute = await tx.tranhChap.create({
        data: {
          CongViecID: refundRequest.CongViecID,
          NguoiGuiID: refundRequest.NguoiThueID,
          GiamSatID: contract.GiamSatID,
          LyDo: refundRequest.LyDo,
          MoTa: refundRequest.MoTa,
          YeuCauHoanTien: refundRequest.TienHoan,
          TrangThai: 'MoiMo',
        },
      });

      await tx.thongBao.createMany({
        data: [
          {
            TaiKhoanID: contract.GiamSatID,
            TieuDe: 'Tranh chap hoan tien moi',
            NoiDung: `Freelancer tu choi hoan tien cong viec #${refundRequest.CongViecID}; can phan xu.`,
            LoaiThongBao: 'TranhChap',
          },
          {
            TaiKhoanID: refundRequest.NguoiThueID,
            TieuDe: 'Yeu cau hoan tien bi tu choi',
            NoiDung: `Da mo tranh chap #${dispute.TranhChapID} de don vi giam sat xu ly.`,
            LoaiThongBao: 'TranhChap',
          },
        ],
      });

      return tx.yeuCauHoanTien.update({
        where: { YeuCauHoanTienID: id },
        data: { TranhChapID: dispute.TranhChapID },
        select: REFUND_REQUEST_SELECT,
      });
    });

    return {
      message:
        'Freelancer tu choi hoan tien, da mo tranh chap cho don vi giam sat',
      refundRequest: this.toRefundRequestDto(rejectedRequest),
    };
  }

  private async findEntityOrThrow(id: number): Promise<RefundRequestEntity> {
    const refundRequest = await this.prisma.yeuCauHoanTien.findUnique({
      where: { YeuCauHoanTienID: id },
      select: REFUND_REQUEST_SELECT,
    });

    if (!refundRequest) {
      throw new NotFoundException('Yeu cau hoan tien khong ton tai');
    }

    return refundRequest;
  }

  private validateFreelancerDecision(
    refundRequest: RefundRequestEntity,
    payload: DecideRefundRequestDto,
  ): void {
    if (refundRequest.TrangThai !== 'ChoFreelancerDuyet') {
      throw new BadRequestException('Yeu cau hoan tien da duoc phan hoi');
    }

    if (refundRequest.FreelancerID !== payload.freelancerId) {
      throw new BadRequestException(
        'Chi freelancer cua hop dong moi co the phan hoi yeu cau hoan tien',
      );
    }
  }

  private calculateSettlement(tongEscrow: number, giaThoa: number) {
    const PhiHeThong = this.roundMoney(giaThoa * SYSTEM_FEE_PERCENT);
    const TienFreelancer = this.roundMoney(giaThoa * EARLY_SETTLEMENT_SHARE);
    const TienGiamSat = this.roundMoney(giaThoa * EARLY_SETTLEMENT_SHARE);
    const TienHoan = this.roundMoney(
      tongEscrow - PhiHeThong - TienFreelancer - TienGiamSat,
    );

    if (TienHoan < 0) {
      throw new BadRequestException(
        'Escrow khong du de tru cac khoan phi khi hoan tien',
      );
    }

    return {
      TongEscrow: this.roundMoney(tongEscrow),
      PhiHeThong,
      TienFreelancer,
      TienGiamSat,
      TienHoan,
    };
  }

  private roundMoney(value: number): number {
    return Math.round(value * 100) / 100;
  }

  private toRefundRequestDto(request: RefundRequestEntity): RefundRequestDto {
    return {
      refundRequestId: request.YeuCauHoanTienID,
      yeuCauHoanTienId: request.YeuCauHoanTienID,
      congViecId: request.CongViecID,
      nguoiThueId: request.NguoiThueID,
      freelancerId: request.FreelancerID,
      lyDo: request.LyDo,
      moTa: request.MoTa,
      trangThai: request.TrangThai,
      tongEscrow: request.TongEscrow.toString(),
      phiHeThong: request.PhiHeThong.toString(),
      tienFreelancer: request.TienFreelancer.toString(),
      tienGiamSat: request.TienGiamSat.toString(),
      tienHoan: request.TienHoan.toString(),
      tranhChapId: request.TranhChapID,
      ngayTao: request.NgayTao.toISOString(),
      ngayPhanHoi: request.NgayPhanHoi
        ? request.NgayPhanHoi.toISOString()
        : null,
    };
  }
}
