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
  JobsListResponseDto,
  JobWithDetailsDto,
  SearchJobsQueryDto,
  UpdateJobDto,
} from './dto';

const JOB_SELECT = {
  YeuCauID: true,
  NguoiThueID: true,
  LoaiDichVuID: true,
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
  NguoiThue: {
    select: {
      TaiKhoan: {
        select: {
          TaiKhoanID: true,
          HoTen: true,
          Email: true,
        },
      },
    },
  },
  LoaiDichVu: {
    select: {
      LoaiDichVuID: true,
      TenLoai: true,
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
      orderBy: {
        NgayTao: 'desc',
      },
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

    const jobs = await this.prisma.yeuCau.findMany({
      where,
      select: JOB_SELECT,
      orderBy: {
        NgayTao: 'desc',
      },
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
    const nguoiThue = await this.prisma.nguoiThue.findFirst({
      where: { TaiKhoanID: userId },
      select: { NguoiThueID: true },
    });

    if (!nguoiThue) {
      throw new NotFoundException('Nguoi thue khong ton tai');
    }

    const jobs = await this.prisma.yeuCau.findMany({
      where: { NguoiThueID: nguoiThue.NguoiThueID },
      select: JOB_SELECT,
      orderBy: {
        NgayTao: 'desc',
      },
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

    const job = await this.prisma.yeuCau.create({
      data: {
        NguoiThueID: payload.nguoiThueId,
        LoaiDichVuID: payload.loaiDichVuId,
        TieuDe: tieuDe,
        MoTa: moTa,
        NganSachMin: payload.nganSachMin,
        NganSachMax: payload.nganSachMax,
        ThoiHan: thoiHan,
        YeuCauGiamSat: payload.yeuCauGiamSat ?? false,
        TrangThai: 'DangMo',
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

    return {
      message: 'Xoa yeu cau thanh cong',
      jobId: id,
    };
  }

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
    const nguoiThue = await this.prisma.nguoiThue.findUnique({
      where: { NguoiThueID: nguoiThueId },
      select: { NguoiThueID: true },
    });

    if (!nguoiThue) {
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

  private async buildUpdateData(
    payload: UpdateJobDto,
  ): Promise<Prisma.YeuCauUpdateInput> {
    const data: Prisma.YeuCauUpdateInput = {};

    if (payload.loaiDichVuId !== undefined) {
      await this.validateLoaiDichVu(payload.loaiDichVuId);
      data.LoaiDichVu = {
        connect: { LoaiDichVuID: payload.loaiDichVuId },
      };
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
    return {
      yeuCauId: job.YeuCauID,
      nguoiThueId: job.NguoiThueID,
      loaiDichVuId: job.LoaiDichVuID,
      tieuDe: job.TieuDe,
      moTa: job.MoTa,
      nganSachMin: job.NganSachMin.toString(),
      nganSachMax: job.NganSachMax.toString(),
      thoiHan: job.ThoiHan.toISOString(),
      trangThai: job.TrangThai,
      soLuongBaoGia: job.SoLuongBaoGia,
      yeuCauGiamSat: job.YeuCauGiamSat,
      ngayTao: job.NgayTao.toISOString(),
      ngayCapNhat: job.NgayCapNhat.toISOString(),
      nguoiThue: {
        taiKhoanId: job.NguoiThue.TaiKhoan.TaiKhoanID,
        hoTen: job.NguoiThue.TaiKhoan.HoTen,
        email: job.NguoiThue.TaiKhoan.Email,
      },
      loaiDichVu: {
        loaiDichVuId: job.LoaiDichVu.LoaiDichVuID,
        tenLoai: job.LoaiDichVu.TenLoai,
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
      !TRANG_THAI_VALUES.includes(trangThai as TrangThaiYeuCau)
    ) {
      throw new BadRequestException('TrangThai khong hop le');
    }
  }
}
