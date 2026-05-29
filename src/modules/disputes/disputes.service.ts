import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../../common/prisma/prisma.service';
import { Prisma } from '@prisma/client';
import type {
  CreateDisputeDto,
  DisputeDto,
  DisputeListResponseDto,
  DisputeMutationResponseDto,
  DisputeResponseDto,
  ResolveDisputeDto,
  ReviewDisputeDto,
} from './dto';

const SYSTEM_FEE_PERCENT = 0.05;

const DISPUTE_SELECT = {
  TranhChapID: true,
  CongViecID: true,
  NguoiGuiID: true,
  GiamSatID: true,
  LyDo: true,
  MoTa: true,
  TrangThai: true,
  YeuCauHoanTien: true,
  NgayMo: true,
  NgayDong: true,
  KetLuanTranhChap: {
    select: {
      KetLuanID: true,
      GiamSatID: true,
      KetQua: true,
      LyDo: true,
      SoTienHoan: true,
      SoTienFreelancer: true,
      SoTienGiamSat: true,
      SoTienHeThong: true,
      BenChiuPhi: true,
      NgayKetLuan: true,
    },
  },
} as const;

type DisputeEntity = Prisma.TranhChapGetPayload<{
  select: typeof DISPUTE_SELECT;
}>;

@Injectable()
export class DisputesService {
  constructor(private readonly prisma: PrismaService) {}

  async findById(id: number): Promise<DisputeResponseDto> {
    const dispute = await this.prisma.tranhChap.findUnique({
      where: { TranhChapID: id },
      select: DISPUTE_SELECT,
    });

    if (!dispute) {
      throw new NotFoundException('Tranh chap khong ton tai');
    }

    return { dispute: this.toDisputeDto(dispute) };
  }

  async findByContractId(contractId: number): Promise<DisputeListResponseDto> {
    const disputes = await this.prisma.tranhChap.findMany({
      where: { CongViecID: contractId },
      select: DISPUTE_SELECT,
      orderBy: { NgayMo: 'desc' },
    });

    return {
      total: disputes.length,
      disputes: disputes.map((d) => this.toDisputeDto(d)),
    };
  }

  async create(payload: CreateDisputeDto): Promise<DisputeMutationResponseDto> {
    const contract = await this.prisma.congViec.findUnique({
      where: { CongViecID: payload.congViecId },
    });

    if (!contract) {
      throw new NotFoundException('Hop dong khong ton tai');
    }

    if (contract.TrangThai !== 'HoanThanh') {
      throw new BadRequestException(
        'Chi co the tranh chap sau khi cong viec da hoan thanh',
      );
    }

    if (contract.NguoiThueID !== payload.nguoiGuiId) {
      throw new BadRequestException(
        'Chi khach hang moi co the mo tranh chap ve ket qua cong viec',
      );
    }

    const activeDispute = await this.prisma.tranhChap.findFirst({
      where: {
        CongViecID: payload.congViecId,
        TrangThai: { in: ['MoiMo', 'DangXuLy'] },
      },
      select: { TranhChapID: true },
    });

    if (activeDispute) {
      throw new BadRequestException('Cong viec dang co tranh chap can xu ly');
    }

    const lyDo = payload.lyDo?.trim();
    if (!lyDo) {
      throw new BadRequestException('Ly do tranh chap la bat buoc');
    }

    if (payload.yeuCauHoanTien < 0) {
      throw new BadRequestException(
        'Yeu cau hoan tien phai lon hon hoac bang 0',
      );
    }

    const dispute = await this.prisma.tranhChap.create({
      data: {
        CongViecID: payload.congViecId,
        NguoiGuiID: payload.nguoiGuiId,
        GiamSatID: contract.GiamSatID,
        LyDo: lyDo,
        MoTa: payload.moTa?.trim() || null,
        YeuCauHoanTien: payload.yeuCauHoanTien,
        TrangThai: 'MoiMo',
      },
      select: DISPUTE_SELECT,
    });

    return {
      message: 'Mo tranh chap thanh cong',
      dispute: this.toDisputeDto(dispute),
    };
  }

  async review(
    id: number,
    payload: ReviewDisputeDto,
  ): Promise<DisputeMutationResponseDto> {
    const dispute = await this.prisma.tranhChap.findUnique({
      where: { TranhChapID: id },
    });

    if (!dispute) {
      throw new NotFoundException('Tranh chap khong ton tai');
    }

    if (dispute.TrangThai !== 'MoiMo') {
      throw new BadRequestException(
        'Khong the xu ly tranh chap o trang thai hien tai',
      );
    }

    if (dispute.GiamSatID !== payload.giamSatId) {
      throw new BadRequestException(
        'Chi don vi giam sat cua cong viec moi duoc xu ly tranh chap',
      );
    }

    const supervisor = await this.prisma.donViGiamSat.findFirst({
      where: { TaiKhoanID: payload.giamSatId, TrangThai: 'HoatDong' },
    });

    if (!supervisor) {
      throw new BadRequestException('Don vi giam sat khong hoat dong');
    }

    const updatedDispute = await this.prisma.tranhChap.update({
      where: { TranhChapID: id },
      data: {
        TrangThai: 'DangXuLy',
        GiamSatID: payload.giamSatId,
      },
      select: DISPUTE_SELECT,
    });

    return {
      message: 'Bat dau xu ly tranh chap',
      dispute: this.toDisputeDto(updatedDispute),
    };
  }

  async resolve(
    id: number,
    payload: ResolveDisputeDto,
  ): Promise<DisputeMutationResponseDto> {
    const dispute = await this.prisma.tranhChap.findUnique({
      where: { TranhChapID: id },
    });

    if (!dispute) {
      throw new NotFoundException('Tranh chap khong ton tai');
    }

    if (dispute.TrangThai !== 'DangXuLy') {
      throw new BadRequestException(
        'Tranh chap chua duoc xu ly hoac da ket luan',
      );
    }

    if (dispute.GiamSatID !== payload.giamSatId) {
      throw new BadRequestException(
        'Chi don vi giam sat dang xu ly moi duoc ket luan',
      );
    }

    const lyDo = payload.lyDo?.trim();
    if (!lyDo) {
      throw new BadRequestException('Ly do ket luan la bat buoc');
    }

    const updatedDispute = await this.prisma.$transaction(async (tx) => {
      const contract = await tx.congViec.findUnique({
        where: { CongViecID: dispute.CongViecID },
      });

      if (!contract) {
        throw new NotFoundException('Hop dong khong ton tai');
      }

      let settlement = {
        soTienHoan: this.roundMoney(payload.soTienHoan ?? 0),
        soTienFreelancer: this.roundMoney(payload.soTienFreelancer ?? 0),
        soTienGiamSat: this.roundMoney(payload.soTienGiamSat ?? 0),
        soTienHeThong: this.roundMoney(payload.soTienHeThong ?? 0),
      };

      if (payload.ketQua === 'HoanTienNguoiThue') {
        const [deposit, paidOut] = await Promise.all([
          tx.thanhToan.findFirst({
            where: {
              CongViecID: dispute.CongViecID,
              LoaiTT: 'DatCoc',
              TrangThai: 'ThanhCong',
            },
            orderBy: { NgayTao: 'desc' },
          }),
          tx.thanhToan.findFirst({
            where: {
              CongViecID: dispute.CongViecID,
              LoaiTT: {
                in: ['ThanhToanCuoi', 'HoanTien', 'PhiHeThong', 'PhiGiamSat'],
              },
              TrangThai: 'ThanhCong',
            },
            select: { ThanhToanID: true },
          }),
        ]);

        if (!deposit || paidOut) {
          throw new BadRequestException(
            'Tien escrow khong con duoc giu de ket luan hoan tien',
          );
        }

        settlement = this.calculateRefundSettlement(
          Number(contract.GiaThoa),
          Number(contract.PhiGiamSat),
          payload.soTienHoan ?? 0,
        );

        await tx.thanhToan.update({
          where: { ThanhToanID: deposit.ThanhToanID },
          data: { TrangThai: 'DaHoan' },
        });
      }

      await tx.ketLuanTranhChap.create({
        data: {
          TranhChapID: id,
          GiamSatID: payload.giamSatId,
          KetQua: payload.ketQua,
          LyDo: lyDo,
          SoTienHoan: settlement.soTienHoan,
          SoTienFreelancer: settlement.soTienFreelancer,
          SoTienGiamSat: settlement.soTienGiamSat,
          SoTienHeThong: settlement.soTienHeThong,
          BenChiuPhi: payload.benChiuPhi ?? 'ChiaSe',
        },
      });

      const resolvedDispute = await tx.tranhChap.update({
        where: { TranhChapID: id },
        data: {
          TrangThai: 'DaKetLuan',
          NgayDong: new Date(),
        },
        select: DISPUTE_SELECT,
      });

      if (payload.ketQua === 'HoanTienNguoiThue') {
        await tx.thanhToan.createMany({
          data: [
            {
              CongViecID: dispute.CongViecID,
              TaiKhoanID: contract.NguoiThueID,
              SoTien: settlement.soTienHoan,
              LoaiTT: 'HoanTien',
              PhuongThuc: 'Vi',
              TrangThai: 'ThanhCong',
              GhiChu: `Hoan tien theo ket luan tranh chap #${id}`,
            },
            {
              CongViecID: dispute.CongViecID,
              TaiKhoanID: contract.NguoiThueID,
              SoTien: settlement.soTienFreelancer,
              LoaiTT: 'ThanhToanCuoi',
              PhuongThuc: 'Vi',
              TrangThai: 'ThanhCong',
              GhiChu: `Giai ngan freelancer theo ket luan tranh chap #${id}`,
            },
            {
              CongViecID: dispute.CongViecID,
              TaiKhoanID: contract.NguoiThueID,
              SoTien: settlement.soTienGiamSat,
              LoaiTT: 'PhiGiamSat',
              PhuongThuc: 'Vi',
              TrangThai: 'ThanhCong',
              GhiChu: `Phi giam sat theo ket luan tranh chap #${id}`,
            },
            {
              CongViecID: dispute.CongViecID,
              TaiKhoanID: contract.NguoiThueID,
              SoTien: settlement.soTienHeThong,
              LoaiTT: 'PhiHeThong',
              PhuongThuc: 'Vi',
              TrangThai: 'ThanhCong',
              GhiChu: `Phi he thong theo ket luan tranh chap #${id}`,
            },
          ],
        });

        if (settlement.soTienFreelancer > 0) {
          await tx.freelancer.update({
            where: { TaiKhoanID: contract.FreelancerID },
            data: { SoDu: { increment: settlement.soTienFreelancer } },
          });
        }

        await tx.congViec.update({
          where: { CongViecID: dispute.CongViecID },
          data: {
            TrangThai: 'DaHuy',
            TrangThaiGiamSat: 'HoanThanh',
            NgayKetThuc: new Date(),
          },
        });

        await tx.yeuCauGiamSat.updateMany({
          where: {
            CongViecID: dispute.CongViecID,
            TrangThai: 'DaChapNhan',
          },
          data: {
            TrangThai: 'HoanThanh',
            NgayHoanThanh: new Date(),
          },
        });
      }

      return resolvedDispute;
    });

    return {
      message: 'Ket luan tranh chap thanh cong',
      dispute: this.toDisputeDto(updatedDispute),
    };
  }

  private calculateRefundSettlement(
    totalContractAmount: number,
    supervisorFee: number,
    refundToEmployer: number,
  ) {
    const roundedTotalContractAmount = this.roundMoney(totalContractAmount);
    const roundedSupervisorFee = this.roundMoney(supervisorFee);
    const roundedRefundToEmployer = this.roundMoney(refundToEmployer);

    if (roundedRefundToEmployer < 0) {
      throw new BadRequestException('So tien hoan phai lon hon hoac bang 0');
    }

    if (
      roundedSupervisorFee < 0 ||
      roundedSupervisorFee > roundedTotalContractAmount
    ) {
      throw new BadRequestException(
        'Phi giam sat khong hop le so voi tong tien hop dong',
      );
    }

    const freelancerFund = this.roundMoney(
      roundedTotalContractAmount - roundedSupervisorFee,
    );

    if (roundedRefundToEmployer > freelancerFund) {
      throw new BadRequestException(
        'So tien hoan khong duoc vuot qua phan quy cua freelancer sau phi giam sat',
      );
    }

    const freelancerGross = this.roundMoney(
      freelancerFund - roundedRefundToEmployer,
    );
    const systemFee = this.roundMoney(freelancerGross * SYSTEM_FEE_PERCENT);
    const freelancerNet = this.roundMoney(freelancerGross - systemFee);
    const allocatedTotal = this.roundMoney(
      roundedRefundToEmployer +
        freelancerNet +
        roundedSupervisorFee +
        systemFee,
    );

    if (allocatedTotal !== roundedTotalContractAmount) {
      throw new BadRequestException(
        'Tong phan bo tien tranh chap khong hop le',
      );
    }

    return {
      soTienHoan: roundedRefundToEmployer,
      soTienFreelancer: freelancerNet,
      soTienGiamSat: roundedSupervisorFee,
      soTienHeThong: systemFee,
    };
  }

  private roundMoney(value: number): number {
    return Math.round(value * 100) / 100;
  }

  private toDisputeDto(dispute: DisputeEntity): DisputeDto {
    return {
      tranhChapId: dispute.TranhChapID,
      congViecId: dispute.CongViecID,
      nguoiGuiId: dispute.NguoiGuiID,
      giamSatId: dispute.GiamSatID!,
      lyDo: dispute.LyDo,
      moTa: dispute.MoTa,
      trangThai: dispute.TrangThai,
      yeuCauHoanTien: dispute.YeuCauHoanTien.toString(),
      ngayMo: dispute.NgayMo.toISOString(),
      ngayDong: dispute.NgayDong ? dispute.NgayDong.toISOString() : null,
      ketLuan: dispute.KetLuanTranhChap
        ? {
            ketLuanId: dispute.KetLuanTranhChap.KetLuanID,
            giamSatId: dispute.KetLuanTranhChap.GiamSatID,
            ketQua: dispute.KetLuanTranhChap.KetQua,
            lyDo: dispute.KetLuanTranhChap.LyDo,
            soTienHoan: dispute.KetLuanTranhChap.SoTienHoan.toString(),
            soTienFreelancer:
              dispute.KetLuanTranhChap.SoTienFreelancer.toString(),
            soTienGiamSat: dispute.KetLuanTranhChap.SoTienGiamSat.toString(),
            soTienHeThong: dispute.KetLuanTranhChap.SoTienHeThong.toString(),
            benChiuPhi: dispute.KetLuanTranhChap.BenChiuPhi,
            ngayKetLuan: dispute.KetLuanTranhChap.NgayKetLuan.toISOString(),
          }
        : null,
    };
  }
}
