import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import type { Prisma, TrangThaiYeuCau } from '@prisma/client';
import { PrismaService } from '../../common/prisma/prisma.service';
import type {
  CreateJobDto,
  JobDeleteResponseDto,
  JobMutationResponseDto,
  JobResponseDto,
  JobSkillsMutationResponseDto,
  JobsListResponseDto,
  JobWithDetailsDto,
  SearchJobsQueryDto,
  SetJobSkillsDto,
  SkillSummaryDto,
  UpdateJobDto,
} from './dto';

const JOB_SELECT = {
  YeuCauID: true,
  TaiKhoanID: true,
  LoaiDichVuID: true,
  GiamSatID: true,
  TieuDe: true,
  MoTa: true,
  NganSachMin: true,
  NganSachMax: true,
  ThoiHan: true,
  TrangThai: true,
  SoLuongBaoGia: true,
  YeuCauGiamSat: true,
  NgayTao: true,
  NgayCapNhat: true,
  NguoiTao: {
    select: {
      TaiKhoanID: true,
      HoTen: true,
      Email: true,
    },
  },
  LoaiDichVu: {
    select: {
      LoaiDichVuID: true,
      TenLoai: true,
    },
  },
  GiamSat: {
    select: {
      TaiKhoanID: true,
      HoTen: true,
      Email: true,
      DonViGiamSat: {
        select: {
          GiamSatID: true,
          TenDonVi: true,
        },
      },
    },
  },
  YeuCauKyNangs: {
    select: {
      KyNang: {
        select: {
          KyNangID: true,
          TenKyNang: true,
        },
      },
    },
  },
} as const;

type JobEntity = Prisma.YeuCauGetPayload<{ select: typeof JOB_SELECT }>;

const TRANG_THAI_VALUES: readonly TrangThaiYeuCau[] = [
  'MoDau',
  'DangMo',
  'DaDong',
  'DaHuy',
  'HoanThanh',
];

@Injectable()
export class JobsService {
  constructor(private readonly prisma: PrismaService) {}

  async findAll(): Promise<JobsListResponseDto> {
    const jobs = await this.prisma.yeuCau.findMany({
      select: JOB_SELECT,
      orderBy: { NgayTao: 'desc' },
    });

    return {
      total: jobs.length,
      jobs: jobs.map((job) => this.toJobWithDetailsDto(job)),
    };
  }

  async search(query: SearchJobsQueryDto): Promise<JobsListResponseDto> {
    const where: Prisma.YeuCauWhereInput = {};

    if (query.keyword?.trim()) {
      where.OR = [
        { TieuDe: { contains: query.keyword.trim(), mode: 'insensitive' } },
        { MoTa: { contains: query.keyword.trim(), mode: 'insensitive' } },
      ];
    }

    if (query.category?.trim()) {
      const categoryId = parseInt(query.category.trim(), 10);
      if (!isNaN(categoryId)) {
        where.LoaiDichVuID = categoryId;
      }
    }

    if (query.budget?.trim()) {
      const budget = parseFloat(query.budget.trim());
      if (!isNaN(budget)) {
        where.AND = [
          { NganSachMin: { lte: budget } },
          { NganSachMax: { gte: budget } },
        ];
      }
    }

    // Filter by skills: ?skills=1,2,3 → job must have ALL listed skills
    if (query.skills?.trim()) {
      const skillIds = query.skills
        .split(',')
        .map((s) => parseInt(s.trim(), 10))
        .filter((n) => !isNaN(n));

      if (skillIds.length > 0) {
        where.YeuCauKyNangs = {
          some: { KyNangID: { in: skillIds } },
        };
      }
    }

    const jobs = await this.prisma.yeuCau.findMany({
      where,
      select: JOB_SELECT,
      orderBy: { NgayTao: 'desc' },
    });

    return {
      total: jobs.length,
      jobs: jobs.map((job) => this.toJobWithDetailsDto(job)),
    };
  }

  async findOne(id: number): Promise<JobResponseDto> {
    const job = await this.findJobOrThrow(id);
    return { job: this.toJobWithDetailsDto(job) };
  }

  async findByUserId(userId: number): Promise<JobsListResponseDto> {
    const taiKhoan = await this.prisma.taiKhoan.findUnique({
      where: { TaiKhoanID: userId },
      select: { TaiKhoanID: true },
    });

    if (!taiKhoan) {
      throw new NotFoundException('Nguoi thue khong ton tai');
    }

    const jobs = await this.prisma.yeuCau.findMany({
      where: { TaiKhoanID: userId },
      select: JOB_SELECT,
      orderBy: { NgayTao: 'desc' },
    });

    return {
      total: jobs.length,
      jobs: jobs.map((job) => this.toJobWithDetailsDto(job)),
    };
  }

  async create(payload: CreateJobDto): Promise<JobMutationResponseDto> {
    await this.validateNguoiThue(payload.nguoiThueId);
    await this.validateLoaiDichVu(payload.loaiDichVuId);

    const tieuDe = this.requireText(payload.tieuDe, 'tieuDe');
    const moTa = this.requireText(payload.moTa, 'moTa');

    if (payload.nganSachMin < 0 || payload.nganSachMax < 0) {
      throw new BadRequestException('Ngan sach phai lon hon hoac bang 0');
    }

    if (payload.nganSachMin > payload.nganSachMax) {
      throw new BadRequestException(
        'Ngan sach min phai nho hon hoac bang ngan sach max',
      );
    }

    const thoiHan = new Date(payload.thoiHan);
    if (isNaN(thoiHan.getTime())) {
      throw new BadRequestException('Thoi han khong hop le');
    }

    // Validate skill IDs if provided
    const kyNangIds = payload.kyNangIds ?? [];
    if (kyNangIds.length > 0) {
      await this.validateKyNangIds(kyNangIds);
    }

    // Validate giamSatId if provided
    const giamSatId = payload.giamSatId ?? null;
    if (giamSatId) {
      await this.validateGiamSat(giamSatId);
    }

    const job = await this.prisma.yeuCau.create({
      data: {
        TaiKhoanID: payload.nguoiThueId,
        LoaiDichVuID: payload.loaiDichVuId,
        TieuDe: tieuDe,
        MoTa: moTa,
        NganSachMin: payload.nganSachMin,
        NganSachMax: payload.nganSachMax,
        ThoiHan: thoiHan,
        YeuCauGiamSat: giamSatId ? true : (payload.yeuCauGiamSat ?? false),
        GiamSatID: giamSatId,
        TrangThai: 'DangMo',
        YeuCauKyNangs: kyNangIds.length > 0
          ? {
              create: kyNangIds.map((id) => ({ KyNangID: id })),
            }
          : undefined,
      },
      select: JOB_SELECT,
    });

    return {
      message: 'Tao yeu cau thanh cong',
      job: this.toJobWithDetailsDto(job),
    };
  }

  async update(
    id: number,
    payload: UpdateJobDto,
  ): Promise<JobMutationResponseDto> {
    await this.findJobOrThrow(id);

    const data = await this.buildUpdateData(payload);

    const job = await this.prisma.yeuCau.update({
      where: { YeuCauID: id },
      data,
      select: JOB_SELECT,
    });

    return {
      message: 'Cap nhat yeu cau thanh cong',
      job: this.toJobWithDetailsDto(job),
    };
  }

  async remove(id: number): Promise<JobDeleteResponseDto> {
    await this.findJobOrThrow(id);

    await this.prisma.yeuCau.update({
      where: { YeuCauID: id },
      data: { TrangThai: 'DaHuy' },
    });

    return { message: 'Xoa yeu cau thanh cong', jobId: id };
  }

  // ── Skills management ──────────────────────────────────────────────────────

  async getJobSkills(id: number): Promise<JobSkillsMutationResponseDto> {
    await this.findJobOrThrow(id);

    const rows = await this.prisma.yeuCauKyNang.findMany({
      where: { YeuCauID: id },
      select: {
        KyNang: { select: { KyNangID: true, TenKyNang: true } },
      },
    });

    return {
      message: 'Lay danh sach ky nang thanh cong',
      kyNangs: rows.map((r) => ({
        kyNangId: r.KyNang.KyNangID,
        tenKyNang: r.KyNang.TenKyNang,
      })),
    };
  }

  async setJobSkills(
    id: number,
    payload: SetJobSkillsDto,
  ): Promise<JobSkillsMutationResponseDto> {
    await this.findJobOrThrow(id);

    if (payload.kyNangIds.length > 0) {
      await this.validateKyNangIds(payload.kyNangIds);
    }

    // Replace all skills atomically
    await this.prisma.$transaction([
      this.prisma.yeuCauKyNang.deleteMany({ where: { YeuCauID: id } }),
      ...(payload.kyNangIds.length > 0
        ? [
            this.prisma.yeuCauKyNang.createMany({
              data: payload.kyNangIds.map((kyNangId) => ({
                YeuCauID: id,
                KyNangID: kyNangId,
              })),
            }),
          ]
        : []),
    ]);

    const rows = await this.prisma.yeuCauKyNang.findMany({
      where: { YeuCauID: id },
      select: {
        KyNang: { select: { KyNangID: true, TenKyNang: true } },
      },
    });

    return {
      message: 'Cap nhat ky nang yeu cau thanh cong',
      kyNangs: rows.map((r) => ({
        kyNangId: r.KyNang.KyNangID,
        tenKyNang: r.KyNang.TenKyNang,
      })),
    };
  }

  async addJobSkill(
    id: number,
    kyNangId: number,
  ): Promise<JobSkillsMutationResponseDto> {
    await this.findJobOrThrow(id);
    await this.validateKyNangIds([kyNangId]);

    // Upsert — ignore if already exists
    await this.prisma.yeuCauKyNang.upsert({
      where: { YeuCauID_KyNangID: { YeuCauID: id, KyNangID: kyNangId } },
      create: { YeuCauID: id, KyNangID: kyNangId },
      update: {},
    });

    return this.getJobSkills(id);
  }

  async removeJobSkill(
    id: number,
    kyNangId: number,
  ): Promise<JobSkillsMutationResponseDto> {
    await this.findJobOrThrow(id);

    await this.prisma.yeuCauKyNang.deleteMany({
      where: { YeuCauID: id, KyNangID: kyNangId },
    });

    return this.getJobSkills(id);
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  private async findJobOrThrow(id: number): Promise<JobEntity> {
    const job = await this.prisma.yeuCau.findUnique({
      where: { YeuCauID: id },
      select: JOB_SELECT,
    });

    if (!job) {
      throw new NotFoundException('Yeu cau khong ton tai');
    }

    return job;
  }

  private async validateNguoiThue(nguoiThueId: number): Promise<void> {
    const taiKhoan = await this.prisma.taiKhoan.findUnique({
      where: { TaiKhoanID: nguoiThueId },
      select: { TaiKhoanID: true, VaiTro: true },
    });

    if (!taiKhoan) {
      throw new BadRequestException('Nguoi thue khong ton tai');
    }
  }

  private async validateLoaiDichVu(loaiDichVuId: number): Promise<void> {
    const loaiDichVu = await this.prisma.loaiDichVu.findUnique({
      where: { LoaiDichVuID: loaiDichVuId },
      select: { LoaiDichVuID: true },
    });

    if (!loaiDichVu) {
      throw new BadRequestException('Loai dich vu khong ton tai');
    }
  }

  private async validateKyNangIds(ids: number[]): Promise<void> {
    const found = await this.prisma.kyNang.findMany({
      where: { KyNangID: { in: ids } },
      select: { KyNangID: true },
    });

    if (found.length !== ids.length) {
      const foundIds = new Set(found.map((k) => k.KyNangID));
      const missing = ids.filter((id) => !foundIds.has(id));
      throw new BadRequestException(
        `Ky nang khong ton tai: ${missing.join(', ')}`,
      );
    }
  }

  private async validateGiamSat(giamSatId: number): Promise<void> {
    const giamSat = await this.prisma.donViGiamSat.findFirst({
      where: { TaiKhoanID: giamSatId },
      select: { GiamSatID: true, TrangThai: true },
    });

    if (!giamSat) {
      throw new BadRequestException('Don vi giam sat khong ton tai');
    }

    if (giamSat.TrangThai !== 'HoatDong') {
      throw new BadRequestException('Don vi giam sat khong hoat dong');
    }
  }

  private async buildUpdateData(
    payload: UpdateJobDto,
  ): Promise<Prisma.YeuCauUpdateInput> {
    const data: Prisma.YeuCauUpdateInput = {};

    if (payload.loaiDichVuId !== undefined) {
      await this.validateLoaiDichVu(payload.loaiDichVuId);
      data.LoaiDichVu = { connect: { LoaiDichVuID: payload.loaiDichVuId } };
    }

    if (payload.tieuDe !== undefined) {
      data.TieuDe = this.requireText(payload.tieuDe, 'tieuDe');
    }

    if (payload.moTa !== undefined) {
      data.MoTa = this.requireText(payload.moTa, 'moTa');
    }

    if (payload.nganSachMin !== undefined) {
      if (payload.nganSachMin < 0) {
        throw new BadRequestException('Ngan sach min phai lon hon hoac bang 0');
      }
      data.NganSachMin = payload.nganSachMin;
    }

    if (payload.nganSachMax !== undefined) {
      if (payload.nganSachMax < 0) {
        throw new BadRequestException('Ngan sach max phai lon hon hoac bang 0');
      }
      data.NganSachMax = payload.nganSachMax;
    }

    if (payload.thoiHan !== undefined) {
      const thoiHan = new Date(payload.thoiHan);
      if (isNaN(thoiHan.getTime())) {
        throw new BadRequestException('Thoi han khong hop le');
      }
      data.ThoiHan = thoiHan;
    }

    if (payload.trangThai !== undefined) {
      this.ensureValidTrangThai(payload.trangThai);
      data.TrangThai = payload.trangThai;
    }

    if (payload.yeuCauGiamSat !== undefined) {
      data.YeuCauGiamSat = payload.yeuCauGiamSat;
    }

    if (Object.keys(data).length === 0) {
      throw new BadRequestException('Khong co truong hop le de cap nhat');
    }

    return data;
  }

  private toJobWithDetailsDto(job: JobEntity): JobWithDetailsDto {
    const kyNangs: SkillSummaryDto[] = job.YeuCauKyNangs.map((r) => ({
      kyNangId: r.KyNang.KyNangID,
      tenKyNang: r.KyNang.TenKyNang,
    }));

    return {
      yeuCauId: job.YeuCauID,
      nguoiThueId: job.TaiKhoanID,
      loaiDichVuId: job.LoaiDichVuID,
      tieuDe: job.TieuDe,
      moTa: job.MoTa,
      nganSachMin: job.NganSachMin.toString(),
      nganSachMax: job.NganSachMax.toString(),
      thoiHan: job.ThoiHan.toISOString(),
      trangThai: job.TrangThai,
      soLuongBaoGia: job.SoLuongBaoGia,
      yeuCauGiamSat: job.YeuCauGiamSat,
      giamSatId: job.GiamSatID,
      ngayTao: job.NgayTao.toISOString(),
      ngayCapNhat: job.NgayCapNhat.toISOString(),
      nguoiThue: {
        taiKhoanId: job.NguoiTao.TaiKhoanID,
        hoTen: job.NguoiTao.HoTen,
        email: job.NguoiTao.Email,
      },
      loaiDichVu: {
        loaiDichVuId: job.LoaiDichVu.LoaiDichVuID,
        tenLoai: job.LoaiDichVu.TenLoai,
      },
      giamSat: job.GiamSat
        ? { giamSatId: job.GiamSat.DonViGiamSat?.GiamSatID ?? null, tenDonVi: job.GiamSat.DonViGiamSat?.TenDonVi ?? job.GiamSat.HoTen }
        : null,
      kyNangs,
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
      !TRANG_THAI_VALUES.includes(trangThai as TrangThaiYeuCau)
    ) {
      throw new BadRequestException('TrangThai khong hop le');
    }
  }
}
