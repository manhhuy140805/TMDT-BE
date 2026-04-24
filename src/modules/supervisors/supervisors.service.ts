import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import type { Prisma, TrangThaiDonViGiamSat } from '@prisma/client';
import { PrismaService } from '../../common/prisma/prisma.service';
import type {
  CreateSupervisorDto,
  SupervisorDeleteResponseDto,
  SupervisorMutationResponseDto,
  SupervisorResponseDto,
  SupervisorsListResponseDto,
  SupervisorWithDetailsDto,
  SearchSupervisorsQueryDto,
  UpdateSupervisorDto,
} from './dto';

const SUPERVISOR_SELECT = {
  GiamSatID: true,
  TaiKhoanID: true,
  TenDonVi: true,
  MoTa: true,
  NangLuc: true,
  ChungChi: true,
  PhiGiamSat: true,
  XepHang: true,
  TongCongViecGS: true,
  TrangThai: true,
  NgayDangKy: true,
  TaiKhoan: {
    select: {
      TaiKhoanID: true,
      HoTen: true,
      Email: true,
      SoDienThoai: true,
    },
  },
} as const;

type SupervisorEntity = Prisma.DonViGiamSatGetPayload<{
  select: typeof SUPERVISOR_SELECT;
}>;

const TRANG_THAI_VALUES: readonly TrangThaiDonViGiamSat[] = [
  'HoatDong',
  'TamNghi',
  'BiKhoa',
  'ChoDuyet',
];

@Injectable()
export class SupervisorsService {
  constructor(private readonly prisma: PrismaService) {}

  async findAll(): Promise<SupervisorsListResponseDto> {
    const supervisors = await this.prisma.donViGiamSat.findMany({
      select: SUPERVISOR_SELECT,
      orderBy: {
        NgayDangKy: 'desc',
      },
    });

    return {
      total: supervisors.length,
      supervisors: supervisors.map((supervisor) =>
        this.toSupervisorWithDetailsDto(supervisor),
      ),
    };
  }

  async search(
    query: SearchSupervisorsQueryDto,
  ): Promise<SupervisorsListResponseDto> {
    const where: Prisma.DonViGiamSatWhereInput = {};

    if (query.keyword?.trim()) {
      where.OR = [
        { TenDonVi: { contains: query.keyword.trim(), mode: 'insensitive' } },
        { MoTa: { contains: query.keyword.trim(), mode: 'insensitive' } },
        { NangLuc: { contains: query.keyword.trim(), mode: 'insensitive' } },
      ];
    }

    const supervisors = await this.prisma.donViGiamSat.findMany({
      where,
      select: SUPERVISOR_SELECT,
      orderBy: {
        NgayDangKy: 'desc',
      },
    });

    return {
      total: supervisors.length,
      supervisors: supervisors.map((supervisor) =>
        this.toSupervisorWithDetailsDto(supervisor),
      ),
    };
  }

  async findOne(id: number): Promise<SupervisorResponseDto> {
    const supervisor = await this.findSupervisorOrThrow(id);

    return { supervisor: this.toSupervisorWithDetailsDto(supervisor) };
  }

  async create(
    payload: CreateSupervisorDto,
  ): Promise<SupervisorMutationResponseDto> {
    await this.validateTaiKhoan(payload.taiKhoanId);

    const tenDonVi = this.requireText(payload.tenDonVi, 'tenDonVi');

    if (payload.phiGiamSat < 0) {
      throw new BadRequestException('Phi giam sat phai lon hon hoac bang 0');
    }

    const supervisor = await this.prisma.donViGiamSat.create({
      data: {
        TaiKhoanID: payload.taiKhoanId,
        TenDonVi: tenDonVi,
        MoTa: payload.moTa?.trim() || null,
        NangLuc: payload.nangLuc?.trim() || null,
        ChungChi: payload.chungChi?.trim() || null,
        PhiGiamSat: payload.phiGiamSat,
        TrangThai: 'ChoDuyet',
      },
      select: SUPERVISOR_SELECT,
    });

    return {
      message: 'Tao don vi giam sat thanh cong',
      supervisor: this.toSupervisorWithDetailsDto(supervisor),
    };
  }

  async update(
    id: number,
    payload: UpdateSupervisorDto,
  ): Promise<SupervisorMutationResponseDto> {
    await this.findSupervisorOrThrow(id);

    const data = await this.buildUpdateData(payload);

    const supervisor = await this.prisma.donViGiamSat.update({
      where: { GiamSatID: id },
      data,
      select: SUPERVISOR_SELECT,
    });

    return {
      message: 'Cap nhat don vi giam sat thanh cong',
      supervisor: this.toSupervisorWithDetailsDto(supervisor),
    };
  }

  async remove(id: number): Promise<SupervisorDeleteResponseDto> {
    await this.findSupervisorOrThrow(id);

    await this.prisma.donViGiamSat.update({
      where: { GiamSatID: id },
      data: { TrangThai: 'BiKhoa' },
    });

    return {
      message: 'Xoa don vi giam sat thanh cong',
      supervisorId: id,
    };
  }

  private async findSupervisorOrThrow(id: number): Promise<SupervisorEntity> {
    const supervisor = await this.prisma.donViGiamSat.findUnique({
      where: { GiamSatID: id },
      select: SUPERVISOR_SELECT,
    });

    if (!supervisor) {
      throw new NotFoundException('Don vi giam sat khong ton tai');
    }

    return supervisor;
  }

  private async validateTaiKhoan(taiKhoanId: number): Promise<void> {
    const taiKhoan = await this.prisma.taiKhoan.findUnique({
      where: { TaiKhoanID: taiKhoanId },
      select: { TaiKhoanID: true },
    });

    if (!taiKhoan) {
      throw new BadRequestException('Tai khoan khong ton tai');
    }

    const existingSupervisor = await this.prisma.donViGiamSat.findFirst({
      where: { TaiKhoanID: taiKhoanId },
      select: { GiamSatID: true },
    });

    if (existingSupervisor) {
      throw new BadRequestException('Tai khoan da co don vi giam sat');
    }
  }

  private async buildUpdateData(
    payload: UpdateSupervisorDto,
  ): Promise<Prisma.DonViGiamSatUpdateInput> {
    const data: Prisma.DonViGiamSatUpdateInput = {};

    if (payload.tenDonVi !== undefined) {
      data.TenDonVi = this.requireText(payload.tenDonVi, 'tenDonVi');
    }

    if (payload.moTa !== undefined) {
      data.MoTa = payload.moTa?.trim() || null;
    }

    if (payload.nangLuc !== undefined) {
      data.NangLuc = payload.nangLuc?.trim() || null;
    }

    if (payload.chungChi !== undefined) {
      data.ChungChi = payload.chungChi?.trim() || null;
    }

    if (payload.phiGiamSat !== undefined) {
      if (payload.phiGiamSat < 0) {
        throw new BadRequestException('Phi giam sat phai lon hon hoac bang 0');
      }
      data.PhiGiamSat = payload.phiGiamSat;
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

  private toSupervisorWithDetailsDto(
    supervisor: SupervisorEntity,
  ): SupervisorWithDetailsDto {
    return {
      giamSatId: supervisor.GiamSatID,
      taiKhoanId: supervisor.TaiKhoanID,
      tenDonVi: supervisor.TenDonVi,
      moTa: supervisor.MoTa,
      nangLuc: supervisor.NangLuc,
      chungChi: supervisor.ChungChi,
      phiGiamSat: supervisor.PhiGiamSat.toString(),
      xepHang: supervisor.XepHang.toString(),
      tongCongViecGS: supervisor.TongCongViecGS,
      trangThai: supervisor.TrangThai,
      ngayDangKy: supervisor.NgayDangKy.toISOString(),
      taiKhoan: {
        taiKhoanId: supervisor.TaiKhoan.TaiKhoanID,
        hoTen: supervisor.TaiKhoan.HoTen,
        email: supervisor.TaiKhoan.Email,
        soDienThoai: supervisor.TaiKhoan.SoDienThoai,
      },
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
      !TRANG_THAI_VALUES.includes(trangThai as TrangThaiDonViGiamSat)
    ) {
      throw new BadRequestException('TrangThai khong hop le');
    }
  }
}
