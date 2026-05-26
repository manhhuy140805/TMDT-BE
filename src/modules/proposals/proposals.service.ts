import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import type { Prisma, TrangThaiBaoGia } from '@prisma/client';
import { PrismaService } from '../../common/prisma/prisma.service';
import type {
  CreateProposalDto,
  ProposalDeleteResponseDto,
  ProposalMutationResponseDto,
  ProposalResponseDto,
  ProposalsListResponseDto,
  ProposalWithDetailsDto,
  UpdateProposalDto,
} from './dto';

const PROPOSAL_SELECT = {
  BaoGiaID: true,
  YeuCauID: true,
  TaiKhoanID: true,
  GiaDeXuat: true,
  ThoiGianThucHien: true,
  NoiDung: true,
  TrangThai: true,
  NgayTao: true,
  NgayCapNhat: true,
  Freelancer: {
    select: {
      TaiKhoanID: true,
      HoTen: true,
      Email: true,
      Freelancer: {
        select: {
          FreelancerID: true,
          KinhNghiem: true,
          KyNang: true,
          XepHang: true,
        },
      },
      FreelancerKyNangs: {
        select: {
          KyNang: {
            select: {
              KyNangID: true,
              TenKyNang: true,
            },
          },
        },
      },
    },
  },
  YeuCau: {
    select: {
      YeuCauID: true,
      TieuDe: true,
      TaiKhoanID: true,
    },
  },
} as const;

type ProposalEntity = Prisma.BaoGiaGetPayload<{
  select: typeof PROPOSAL_SELECT;
}>;

const TRANG_THAI_VALUES: readonly TrangThaiBaoGia[] = [
  'DaGui',
  'DuocChon',
  'TuChoi',
  'HetHan',
];

@Injectable()
export class ProposalsService {
  constructor(private readonly prisma: PrismaService) {}

  async findOne(id: number): Promise<ProposalResponseDto> {
    const proposal = await this.findProposalOrThrow(id);

    return { proposal: this.toProposalWithDetailsDto(proposal) };
  }

  async findByJobId(jobId: number): Promise<ProposalsListResponseDto> {
    await this.validateYeuCau(jobId);

    const proposals = await this.prisma.baoGia.findMany({
      where: { YeuCauID: jobId },
      select: PROPOSAL_SELECT,
      orderBy: {
        NgayTao: 'desc',
      },
    });

    return {
      total: proposals.length,
      proposals: proposals.map((p) => this.toProposalWithDetailsDto(p)),
    };
  }

  async findByFreelancerId(
    freelancerId: number,
  ): Promise<ProposalsListResponseDto> {
    await this.validateFreelancer(freelancerId);

    const proposals = await this.prisma.baoGia.findMany({
      where: { TaiKhoanID: freelancerId },
      select: PROPOSAL_SELECT,
      orderBy: {
        NgayTao: 'desc',
      },
    });

    return {
      total: proposals.length,
      proposals: proposals.map((p) => this.toProposalWithDetailsDto(p)),
    };
  }

  async create(
    payload: CreateProposalDto,
  ): Promise<ProposalMutationResponseDto> {
    await this.validateYeuCau(payload.yeuCauId);
    await this.ensureYeuCauAcceptsProposals(payload.yeuCauId);
    await this.validateFreelancer(payload.freelancerId);

    if (payload.giaDeXuat <= 0) {
      throw new BadRequestException('Gia de xuat phai lon hon 0');
    }

    if (payload.thoiGianThucHien <= 0) {
      throw new BadRequestException('Thoi gian thuc hien phai lon hon 0');
    }

    // Check if freelancer already submitted proposal for this job
    const existing = await this.prisma.baoGia.findFirst({
      where: {
        YeuCauID: payload.yeuCauId,
        TaiKhoanID: payload.freelancerId,
      },
      select: { BaoGiaID: true },
    });

    if (existing) {
      throw new BadRequestException(
        'Freelancer da gui bao gia cho yeu cau nay',
      );
    }

    const proposal = await this.prisma.baoGia.create({
      data: {
        YeuCauID: payload.yeuCauId,
        TaiKhoanID: payload.freelancerId,
        GiaDeXuat: payload.giaDeXuat,
        ThoiGianThucHien: payload.thoiGianThucHien,
        NoiDung: payload.noiDung?.trim() || null,
        TrangThai: 'DaGui',
      },
      select: PROPOSAL_SELECT,
    });

    // Increment proposal count on job
    await this.prisma.yeuCau.update({
      where: { YeuCauID: payload.yeuCauId },
      data: {
        SoLuongBaoGia: { increment: 1 },
      },
    });

    return {
      message: 'Tao bao gia thanh cong',
      proposal: this.toProposalWithDetailsDto(proposal),
    };
  }

  async update(
    id: number,
    payload: UpdateProposalDto,
  ): Promise<ProposalMutationResponseDto> {
    await this.findProposalOrThrow(id);

    const data = this.buildUpdateData(payload);

    const proposal = await this.prisma.baoGia.update({
      where: { BaoGiaID: id },
      data,
      select: PROPOSAL_SELECT,
    });

    return {
      message: 'Cap nhat bao gia thanh cong',
      proposal: this.toProposalWithDetailsDto(proposal),
    };
  }

  async remove(id: number): Promise<ProposalDeleteResponseDto> {
    const proposal = await this.findProposalOrThrow(id);

    await this.prisma.baoGia.delete({
      where: { BaoGiaID: id },
    });

    // Decrement proposal count on job
    await this.prisma.yeuCau.update({
      where: { YeuCauID: proposal.YeuCauID },
      data: {
        SoLuongBaoGia: { decrement: 1 },
      },
    });

    return {
      message: 'Xoa bao gia thanh cong',
      proposalId: id,
    };
  }

  private async findProposalOrThrow(id: number): Promise<ProposalEntity> {
    const proposal = await this.prisma.baoGia.findUnique({
      where: { BaoGiaID: id },
      select: PROPOSAL_SELECT,
    });

    if (!proposal) {
      throw new NotFoundException('Bao gia khong ton tai');
    }

    return proposal;
  }

  private async validateYeuCau(yeuCauId: number): Promise<void> {
    const yeuCau = await this.prisma.yeuCau.findUnique({
      where: { YeuCauID: yeuCauId },
      select: { YeuCauID: true },
    });

    if (!yeuCau) {
      throw new BadRequestException('Yeu cau khong ton tai');
    }
  }

  private async ensureYeuCauAcceptsProposals(yeuCauId: number): Promise<void> {
    const yeuCau = await this.prisma.yeuCau.findUnique({
      where: { YeuCauID: yeuCauId },
      select: { TrangThai: true, TrangThaiGiamSat: true },
    });

    if (yeuCau?.TrangThai !== 'DangNhanHoSo') {
      throw new BadRequestException('Yeu cau khong con nhan ho so');
    }

    if (yeuCau.TrangThaiGiamSat !== 'DaChapNhan') {
      throw new BadRequestException(
        'Don vi giam sat chua phe duyet yeu cau nay, khong the gui bao gia',
      );
    }
  }

  private async validateFreelancer(freelancerId: number): Promise<void> {
    const taiKhoan = await this.prisma.taiKhoan.findUnique({
      where: { TaiKhoanID: freelancerId },
      select: { TaiKhoanID: true },
    });

    if (!taiKhoan) {
      throw new BadRequestException('Freelancer khong ton tai');
    }
  }

  private buildUpdateData(
    payload: UpdateProposalDto,
  ): Prisma.BaoGiaUpdateInput {
    const data: Prisma.BaoGiaUpdateInput = {};

    if (payload.giaDeXuat !== undefined) {
      if (payload.giaDeXuat <= 0) {
        throw new BadRequestException('Gia de xuat phai lon hon 0');
      }
      data.GiaDeXuat = payload.giaDeXuat;
    }

    if (payload.thoiGianThucHien !== undefined) {
      if (payload.thoiGianThucHien <= 0) {
        throw new BadRequestException('Thoi gian thuc hien phai lon hon 0');
      }
      data.ThoiGianThucHien = payload.thoiGianThucHien;
    }

    if (payload.noiDung !== undefined) {
      data.NoiDung = payload.noiDung?.trim() || null;
    }

    if (payload.trangThai !== undefined) {
      this.ensureValidTrangThai(payload.trangThai);
      data.TrangThai = payload.trangThai;
    }

    if (Object.keys(data).length === 0) {
      throw new BadRequestException('Khong co truong hop le de cap nhat');
    }

    return data;
  }

  private toProposalWithDetailsDto(
    proposal: ProposalEntity,
  ): ProposalWithDetailsDto {
    return {
      baoGiaId: proposal.BaoGiaID,
      yeuCauId: proposal.YeuCauID,
      freelancerId: proposal.TaiKhoanID,
      giaDeXuat: proposal.GiaDeXuat.toString(),
      thoiGianThucHien: proposal.ThoiGianThucHien,
      noiDung: proposal.NoiDung,
      trangThai: proposal.TrangThai,
      ngayTao: proposal.NgayTao.toISOString(),
      ngayCapNhat: proposal.NgayCapNhat.toISOString(),
      freelancer: {
        freelancerId: proposal.Freelancer.Freelancer?.FreelancerID ?? null,
        taiKhoanId: proposal.Freelancer.TaiKhoanID,
        hoTen: proposal.Freelancer.HoTen,
        email: proposal.Freelancer.Email,
        kinhNghiem: proposal.Freelancer.Freelancer?.KinhNghiem ?? 0,
        kyNang: proposal.Freelancer.Freelancer?.KyNang ?? null,
        kyNangs: proposal.Freelancer.FreelancerKyNangs.map((r) => ({
          kyNangId: r.KyNang.KyNangID,
          tenKyNang: r.KyNang.TenKyNang,
        })),
        xepHang: proposal.Freelancer.Freelancer?.XepHang?.toString() ?? '0',
      },
      yeuCau: {
        yeuCauId: proposal.YeuCau.YeuCauID,
        tieuDe: proposal.YeuCau.TieuDe,
        nguoiThueId: proposal.YeuCau.TaiKhoanID,
      },
    };
  }

  private ensureValidTrangThai(trangThai: unknown): void {
    if (
      typeof trangThai !== 'string' ||
      !TRANG_THAI_VALUES.includes(trangThai as TrangThaiBaoGia)
    ) {
      throw new BadRequestException('TrangThai khong hop le');
    }
  }
}
