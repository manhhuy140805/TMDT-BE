import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../../common/prisma/prisma.service';
import type {
  AcceptProposalDto,
  AcceptProposalResponseDto,
  ConfirmCompletionDto,
  ConfirmCompletionResponseDto,
} from './dto/accept-proposal.dto';

const SYSTEM_FEE_PERCENT = 0.05; // 5%

@Injectable()
export class ContractFlowService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * Step 1: Nguoi thue chap nhan bao gia
   * - Tao hop dong (CongViec)
   * - Cap nhat bao gia thanh DuocChon, cac bao gia khac thanh TuChoi
   * - Tao thanh toan escrow (100% gia thoa + phi giam sat)
   * - Cap nhat trang thai yeu cau thanh DaChot
   */
  async acceptProposal(
    payload: AcceptProposalDto,
  ): Promise<AcceptProposalResponseDto> {
    // Validate bao gia
    const baoGia = await this.prisma.baoGia.findUnique({
      where: { BaoGiaID: payload.baoGiaId },
      include: { YeuCau: true },
    });

    if (!baoGia) {
      throw new NotFoundException('Bao gia khong ton tai');
    }

    if (baoGia.TrangThai !== 'DaGui') {
      throw new BadRequestException('Bao gia da duoc xu ly');
    }

    // Validate nguoi thue owns the job
    const nguoiThue = await this.prisma.taiKhoan.findUnique({
      where: { TaiKhoanID: payload.nguoiThueId },
    });

    if (!nguoiThue) {
      throw new BadRequestException('Nguoi thue khong ton tai');
    }

    if (baoGia.YeuCau.TaiKhoanID !== payload.nguoiThueId) {
      throw new BadRequestException('Ban khong co quyen chap nhan bao gia nay');
    }

    if (
      baoGia.YeuCau.TrangThai !== 'DangNhanHoSo' &&
      baoGia.YeuCau.TrangThai !== 'DaDong'
    ) {
      throw new BadRequestException('Yeu cau khong the chot freelancer');
    }

    const giaThoa = Number(baoGia.GiaDeXuat);
    const phiGiamSat = payload.phiGiamSat ?? 0;
    const tongThanhToan = giaThoa + phiGiamSat;

    // Transaction: create contract + escrow payment + update statuses
    const result = await this.prisma.$transaction(async (tx) => {
      // Claim the request atomically so concurrent selections cannot create two jobs.
      const selected = await tx.yeuCau.updateMany({
        where: {
          YeuCauID: baoGia.YeuCauID,
          TrangThai: { in: ['DangNhanHoSo', 'DaDong'] },
        },
        data: { TrangThai: 'DaChot' },
      });

      if (selected.count !== 1) {
        throw new BadRequestException('Yeu cau da duoc chot hoac da huy');
      }

      // 1. Tao cong viec tu freelancer duoc chot
      const congViec = await tx.congViec.create({
        data: {
          YeuCauID: baoGia.YeuCauID,
          FreelancerID: baoGia.TaiKhoanID,
          NguoiThueID: payload.nguoiThueId,
          GiaThoa: giaThoa,
          ThoiGianThoa: baoGia.ThoiGianThucHien,
          TrangThai: 'DangThucHien',
          NgayBatDau: new Date(),
          GiamSatID: payload.giamSatId ?? null,
          TrangThaiGiamSat: payload.giamSatId ? 'ChoDuyet' : 'KhongCo',
          PhiGiamSat: phiGiamSat,
          DaThanhToanEscrow: true,
        },
      });

      // 2. Tao thanh toan escrow (he thong giu)
      const thanhToan = await tx.thanhToan.create({
        data: {
          CongViecID: congViec.CongViecID,
          TaiKhoanID: payload.nguoiThueId,
          SoTien: tongThanhToan,
          LoaiTT: 'DatCoc',
          PhuongThuc: 'Vi',
          TrangThai: 'ThanhCong',
          GhiChu: `Escrow: ${giaThoa} (gia thoa) + ${phiGiamSat} (phi giam sat)`,
        },
      });

      // 3. Cap nhat bao gia duoc chon
      await tx.baoGia.update({
        where: { BaoGiaID: payload.baoGiaId },
        data: { TrangThai: 'DuocChon' },
      });

      // 4. Tu choi cac bao gia khac cua cung yeu cau
      await tx.baoGia.updateMany({
        where: {
          YeuCauID: baoGia.YeuCauID,
          BaoGiaID: { not: payload.baoGiaId },
          TrangThai: 'DaGui',
        },
        data: { TrangThai: 'TuChoi' },
      });

      return { congViec, thanhToan };
    });

    return {
      message:
        'Chap nhan bao gia thanh cong. Tien da duoc giu boi he thong (escrow).',
      congViecId: result.congViec.CongViecID,
      escrow: {
        giaThoa: giaThoa.toString(),
        phiGiamSat: phiGiamSat.toString(),
        tongThanhToan: tongThanhToan.toString(),
        thanhToanId: result.thanhToan.ThanhToanID,
      },
    };
  }

  /**
   * Step 2: Xac nhan hoan thanh (tu tung ben)
   * - Freelancer xac nhan
   * - Giam sat xac nhan
   * - Nguoi thue xac nhan (cuoi cung) -> trigger giai ngan
   */
  async confirmCompletion(
    payload: ConfirmCompletionDto,
  ): Promise<ConfirmCompletionResponseDto> {
    const congViec = await this.prisma.congViec.findUnique({
      where: { CongViecID: payload.congViecId },
    });

    if (!congViec) {
      throw new NotFoundException('Hop dong khong ton tai');
    }

    if (congViec.TrangThai !== 'DangThucHien') {
      throw new BadRequestException(
        'Hop dong khong o trang thai dang thuc hien',
      );
    }

    if (!congViec.DaThanhToanEscrow) {
      throw new BadRequestException('Hop dong chua duoc thanh toan escrow');
    }

    // Validate role + userId
    await this.validateConfirmRole(congViec, payload);

    // Update confirmation flag
    const updateData: Record<string, boolean> = {};
    if (payload.role === 'Freelancer') {
      if (congViec.FreelancerXacNhan) {
        throw new BadRequestException('Freelancer da xac nhan roi');
      }
      updateData.FreelancerXacNhan = true;
    } else if (payload.role === 'GiamSat') {
      if (!congViec.GiamSatID) {
        throw new BadRequestException('Hop dong khong co giam sat');
      }
      if (congViec.GiamSatXacNhan) {
        throw new BadRequestException('Giam sat da xac nhan roi');
      }
      updateData.GiamSatXacNhan = true;
    } else if (payload.role === 'NguoiThue') {
      // Nguoi thue chi duoc xac nhan khi freelancer + giam sat da xac nhan
      if (!congViec.FreelancerXacNhan) {
        throw new BadRequestException('Freelancer chua xac nhan hoan thanh');
      }
      if (congViec.GiamSatID && !congViec.GiamSatXacNhan) {
        throw new BadRequestException('Giam sat chua xac nhan hoan thanh');
      }
      if (congViec.NguoiThueXacNhan) {
        throw new BadRequestException('Nguoi thue da xac nhan roi');
      }
      updateData.NguoiThueXacNhan = true;
    }

    const updated = await this.prisma.congViec.update({
      where: { CongViecID: payload.congViecId },
      data: updateData,
    });

    // Check if all parties confirmed -> release payment
    const allConfirmed = this.isAllConfirmed(updated);

    let disbursement: ConfirmCompletionResponseDto['disbursement'];

    if (allConfirmed) {
      disbursement = await this.releaseEscrow(updated);
    }

    return {
      message: allConfirmed
        ? 'Tat ca cac ben da xac nhan. Tien da duoc giai ngan.'
        : `${payload.role} da xac nhan hoan thanh.`,
      congViecId: payload.congViecId,
      freelancerXacNhan: updated.FreelancerXacNhan,
      giamSatXacNhan: updated.GiamSatXacNhan,
      nguoiThueXacNhan: updated.NguoiThueXacNhan,
      released: allConfirmed,
      disbursement,
    };
  }

  // --- Private helpers ---

  private async validateConfirmRole(
    congViec: any,
    payload: ConfirmCompletionDto,
  ): Promise<void> {
    if (payload.role === 'Freelancer') {
      // FreelancerID in CongViec is now TaiKhoanID directly
      if (congViec.FreelancerID !== payload.userId) {
        throw new BadRequestException(
          'UserId khong khop voi freelancer cua hop dong',
        );
      }
    } else if (payload.role === 'GiamSat') {
      // GiamSatID in CongViec is now TaiKhoanID directly
      if (congViec.GiamSatID !== payload.userId) {
        throw new BadRequestException(
          'UserId khong khop voi giam sat cua hop dong',
        );
      }
    } else if (payload.role === 'NguoiThue') {
      // NguoiThueID in CongViec is now TaiKhoanID directly
      if (congViec.NguoiThueID !== payload.userId) {
        throw new BadRequestException(
          'UserId khong khop voi nguoi thue cua hop dong',
        );
      }
    }
  }

  private isAllConfirmed(congViec: any): boolean {
    // Neu khong co giam sat, chi can freelancer + nguoi thue
    if (!congViec.GiamSatID) {
      return congViec.FreelancerXacNhan && congViec.NguoiThueXacNhan;
    }
    return (
      congViec.FreelancerXacNhan &&
      congViec.GiamSatXacNhan &&
      congViec.NguoiThueXacNhan
    );
  }

  private async releaseEscrow(congViec: any) {
    const giaThoa = Number(congViec.GiaThoa);
    const phiGiamSat = Number(congViec.PhiGiamSat);
    const phiHeThong = giaThoa * SYSTEM_FEE_PERCENT;
    const freelancerNhan = giaThoa - phiHeThong;

    await this.prisma.$transaction(async (tx) => {
      // 1. Cap nhat hop dong thanh HoanThanh
      await tx.congViec.update({
        where: { CongViecID: congViec.CongViecID },
        data: {
          TrangThai: 'HoanThanh',
          NgayKetThuc: new Date(),
        },
      });

      // 2. Tao thanh toan cho freelancer
      await tx.thanhToan.create({
        data: {
          CongViecID: congViec.CongViecID,
          TaiKhoanID: congViec.NguoiThueID,
          SoTien: freelancerNhan,
          LoaiTT: 'ThanhToanCuoi',
          PhuongThuc: 'Vi',
          TrangThai: 'ThanhCong',
          GhiChu: `Giai ngan cho freelancer (tru 5% phi he thong)`,
        },
      });

      // 3. Tao thanh toan phi giam sat (neu co)
      if (phiGiamSat > 0 && congViec.GiamSatID) {
        await tx.thanhToan.create({
          data: {
            CongViecID: congViec.CongViecID,
            TaiKhoanID: congViec.NguoiThueID,
            SoTien: phiGiamSat,
            LoaiTT: 'PhiGiamSat',
            PhuongThuc: 'Vi',
            TrangThai: 'ThanhCong',
            GhiChu: 'Giai ngan phi giam sat',
          },
        });
      }

      // 4. Tao record phi he thong
      await tx.thanhToan.create({
        data: {
          CongViecID: congViec.CongViecID,
          TaiKhoanID: congViec.NguoiThueID,
          SoTien: phiHeThong,
          LoaiTT: 'PhiHeThong',
          PhuongThuc: 'Vi',
          TrangThai: 'ThanhCong',
          GhiChu: `Phi he thong 5% tu hop dong #${congViec.CongViecID}`,
        },
      });

      // 5. Cap nhat so du freelancer (find by TaiKhoanID)
      await tx.freelancer.update({
        where: { TaiKhoanID: congViec.FreelancerID },
        data: { SoDu: { increment: freelancerNhan } },
      });
    });

    return {
      freelancerNhan: freelancerNhan.toString(),
      giamSatNhan: phiGiamSat.toString(),
      phiHeThong: phiHeThong.toString(),
    };
  }
}
