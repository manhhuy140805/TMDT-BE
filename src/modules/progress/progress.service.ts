import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import type { Prisma, TrangThaiXacNhanTienDo } from '@prisma/client';
import { PrismaService } from '../../common/prisma/prisma.service';
import type {
  CreateProgressDto,
  ProgressDeleteResponseDto,
  ProgressListResponseDto,
  ProgressMutationResponseDto,
  ProgressResponseDto,
  ProgressWithDetailsDto,
  UpdateProgressDto,
} from './dto/progress.dto';

const PROGRESS_SELECT = {
  TienDoID: true,
  CongViecID: true,
  FreelancerID: true,
  TieuDe: true,
  MoTa: true,
  PhanTram: true,
  TepDinhKem: true,
  XacNhanBoi: true,
  TrangThaiXacNhan: true,
  NgayTao: true,
  CongViec: {
    select: {
      CongViecID: true,
      YeuCauID: true,
      GiaThoa: true,
    },
  },
  Freelancer: {
    select: {
      FreelancerID: true,
      TaiKhoan: {
        select: {
          TaiKhoanID: true,
          HoTen: true,
          Email: true,
        },
      },
    },
  },
  DonViGiamSat: {
    select: {
      GiamSatID: true,
      TenDonVi: true,
    },
  },
} as const;

type ProgressEntity = Prisma.TienDoGetPayload<{
  select: typeof PROGRESS_SELECT;
}>;

const TRANG_THAI_VALUES: readonly TrangThaiXacNhanTienDo[] = [
  'ChuaXacNhan',
  'DaXacNhan',
  'TuChoi',
];

@Injectable()
export class ProgressService {
  constructor(private readonly prisma: PrismaService) {}

  async findOne(id: number): Promise<ProgressResponseDto> {
    const progress = await this.findProgressOrThrow(id);

    return { progress: this.toProgressWithDetailsDto(progress) };
  }

  async findByContractId(contractId: number): Promise<ProgressListResponseDto> {
    // Validate contract exists
    await this.validateCongViec(contractId);

    const progressList = await this.prisma.tienDo.findMany({
      where: { CongViecID: contractId },
      select: PROGRESS_SELECT,
      orderBy: {
        NgayTao: 'desc',
      },
    });

    return {
      total: progressList.length,
      progress: progressList.map((p) => this.toProgressWithDetailsDto(p)),
    };
  }

  async create(
    payload: CreateProgressDto,
  ): Promise<ProgressMutationResponseDto> {
    await this.validateCongViec(payload.congViecId);
    await this.validateFreelancer(payload.freelancerId);

    const tieuDe = this.requireText(payload.tieuDe, 'tieuDe');

    if (payload.phanTram < 0 || payload.phanTram > 100) {
      throw new BadRequestException('Phan tram phai tu 0 den 100');
    }

    const progress = await this.prisma.tienDo.create({
      data: {
        CongViecID: payload.congViecId,
        FreelancerID: payload.freelancerId,
        TieuDe: tieuDe,
        MoTa: payload.moTa?.trim() || null,
        PhanTram: payload.phanTram,
        TepDinhKem: payload.tepDinhKem?.trim() || null,
        TrangThaiXacNhan: 'ChuaXacNhan',
      },
      select: PROGRESS_SELECT,
    });

    return {
      message: 'Tao tien do thanh cong',
      progress: this.toProgressWithDetailsDto(progress),
    };
  }

  async update(
    id: number,
    payload: UpdateProgressDto,
  ): Promise<ProgressMutationResponseDto> {
    await this.findProgressOrThrow(id);

    const data = await this.buildUpdateData(payload);

    const progress = await this.prisma.tienDo.update({
      where: { TienDoID: id },
      data,
      select: PROGRESS_SELECT,
    });

    return {
      message: 'Cap nhat tien do thanh cong',
      progress: this.toProgressWithDetailsDto(progress),
    };
  }

  async remove(id: number): Promise<ProgressDeleteResponseDto> {
    await this.findProgressOrThrow(id);

    await this.prisma.tienDo.delete({
      where: { TienDoID: id },
    });

    return {
      message: 'Xoa tien do thanh cong',
      progressId: id,
    };
  }

  private async findProgressOrThrow(id: number): Promise<ProgressEntity> {
    const progress = await this.prisma.tienDo.findUnique({
      where: { TienDoID: id },
      select: PROGRESS_SELECT,
    });

    if (!progress) {
      throw new NotFoundException('Tien do khong ton tai');
    }

    return progress;
  }

  private async validateCongViec(congViecId: number): Promise<void> {
    const congViec = await this.prisma.congViec.findUnique({
      where: { CongViecID: congViecId },
      select: { CongViecID: true },
    });

    if (!congViec) {
      throw new BadRequestException('Hop dong khong ton tai');
    }
  }

  private async validateFreelancer(freelancerId: number): Promise<void> {
    const freelancer = await this.prisma.freelancer.findUnique({
      where: { FreelancerID: freelancerId },
      select: { FreelancerID: true },
    });

    if (!freelancer) {
      throw new BadRequestException('Freelancer khong ton tai');
    }
  }

  private async buildUpdateData(
    payload: UpdateProgressDto,
  ): Promise<Prisma.TienDoUpdateInput> {
    const data: Prisma.TienDoUpdateInput = {};

    if (payload.tieuDe !== undefined) {
      data.TieuDe = this.requireText(payload.tieuDe, 'tieuDe');
    }

    if (payload.moTa !== undefined) {
      data.MoTa = payload.moTa?.trim() || null;
    }

    if (payload.phanTram !== undefined) {
      if (payload.phanTram < 0 || payload.phanTram > 100) {
        throw new BadRequestException('Phan tram phai tu 0 den 100');
      }
      data.PhanTram = payload.phanTram;
    }

    if (payload.tepDinhKem !== undefined) {
      data.TepDinhKem = payload.tepDinhKem?.trim() || null;
    }

    if (payload.trangThaiXacNhan !== undefined) {
      this.ensureValidTrangThai(payload.trangThaiXacNhan);
      data.TrangThaiXacNhan = payload.trangThaiXacNhan;
    }

    if (Object.keys(data).length === 0) {
      throw new BadRequestException('Khong co truong hop le de cap nhat');
    }

    return data;
  }

  private toProgressWithDetailsDto(
    progress: ProgressEntity,
  ): ProgressWithDetailsDto {
    return {
      tienDoId: progress.TienDoID,
      congViecId: progress.CongViecID,
      freelancerId: progress.FreelancerID,
      tieuDe: progress.TieuDe,
      moTa: progress.MoTa,
      phanTram: progress.PhanTram,
      tepDinhKem: progress.TepDinhKem,
      xacNhanBoi: progress.XacNhanBoi,
      trangThaiXacNhan: progress.TrangThaiXacNhan,
      ngayTao: progress.NgayTao.toISOString(),
      congViec: {
        congViecId: progress.CongViec.CongViecID,
        yeuCauId: progress.CongViec.YeuCauID,
        giaThoa: progress.CongViec.GiaThoa.toString(),
      },
      freelancer: {
        freelancerId: progress.Freelancer.FreelancerID,
        taiKhoanId: progress.Freelancer.TaiKhoan.TaiKhoanID,
        hoTen: progress.Freelancer.TaiKhoan.HoTen,
        email: progress.Freelancer.TaiKhoan.Email,
      },
      donViGiamSat: progress.DonViGiamSat
        ? {
            giamSatId: progress.DonViGiamSat.GiamSatID,
            tenDonVi: progress.DonViGiamSat.TenDonVi,
          }
        : null,
    };
  }

  private requireText(value: string | undefined, fieldName: string): string {
    const trimmed = value?.trim();

    if (!trimmed) {
      throw new BadRequestException(`${fieldName} is required`);
    }

    return trimmed;
  }

  private ensureValidTrangThai(trangThai: unknown): void {
    if (
      typeof trangThai !== 'string' ||
      !TRANG_THAI_VALUES.includes(trangThai as TrangThaiXacNhanTienDo)
    ) {
      throw new BadRequestException('TrangThai khong hop le');
    }
  }
}
