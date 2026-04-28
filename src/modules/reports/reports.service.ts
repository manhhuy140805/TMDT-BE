import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../../common/prisma/prisma.service';
import type { Prisma } from '@prisma/client';
import type {
  CreateReportDto,
  ReportDto,
  ReportListResponseDto,
  ReportMutationResponseDto,
  ResolveReportDto,
} from './dto';

const REPORT_SELECT = {
  BaoCaoID: true,
  NguoiBaoCaoID: true,
  NguoiBiCaoID: true,
  LyDo: true,
  MoTa: true,
  TrangThai: true,
  KetQua: true,
  AdminXuLyID: true,
  NgayTao: true,
  NgayXuLy: true,
} as const;

type ReportEntity = Prisma.BaoCaoGetPayload<{
  select: typeof REPORT_SELECT;
}>;

@Injectable()
export class ReportsService {
  constructor(private readonly prisma: PrismaService) {}

  async findAll(): Promise<ReportListResponseDto> {
    const reports = await this.prisma.baoCao.findMany({
      select: REPORT_SELECT,
      orderBy: { NgayTao: 'desc' },
    });

    return {
      total: reports.length,
      reports: reports.map((r) => this.toReportDto(r)),
    };
  }

  async create(payload: CreateReportDto): Promise<ReportMutationResponseDto> {
    if (payload.nguoiBaoCaoId === payload.nguoiBiCaoId) {
      throw new BadRequestException('Khong the tu bao cao chinh minh');
    }

    const nguoiBaoCao = await this.prisma.taiKhoan.findUnique({
      where: { TaiKhoanID: payload.nguoiBaoCaoId },
    });

    if (!nguoiBaoCao) {
      throw new BadRequestException('Nguoi bao cao khong ton tai');
    }

    const nguoiBiCao = await this.prisma.taiKhoan.findUnique({
      where: { TaiKhoanID: payload.nguoiBiCaoId },
    });

    if (!nguoiBiCao) {
      throw new BadRequestException('Nguoi bi cao khong ton tai');
    }

    const report = await this.prisma.baoCao.create({
      data: {
        NguoiBaoCaoID: payload.nguoiBaoCaoId,
        NguoiBiCaoID: payload.nguoiBiCaoId,
        LyDo: payload.lyDo,
        MoTa: payload.moTa,
        TrangThai: 'ChoXuLy',
      },
      select: REPORT_SELECT,
    });

    return {
      message: 'Gui bao cao thanh cong',
      report: this.toReportDto(report),
    };
  }

  async resolve(
    id: number,
    payload: ResolveReportDto,
  ): Promise<ReportMutationResponseDto> {
    const report = await this.prisma.baoCao.findUnique({
      where: { BaoCaoID: id },
    });

    if (!report) {
      throw new NotFoundException('Bao cao khong ton tai');
    }

    if (
      payload.trangThai !== 'DaXuLy' &&
      payload.trangThai !== 'HuyBo' &&
      payload.trangThai !== 'DangXuLy'
    ) {
      throw new BadRequestException('Trang thai xu ly khong hop le');
    }

    // Verify admin
    const admin = await this.prisma.taiKhoan.findUnique({
      where: { TaiKhoanID: payload.adminId },
    });

    if (!admin || admin.VaiTro !== 'Admin') {
      throw new BadRequestException('Nguoi xu ly phai la Admin');
    }

    const updated = await this.prisma.baoCao.update({
      where: { BaoCaoID: id },
      data: {
        TrangThai: payload.trangThai,
        KetQua: payload.ketQua,
        AdminXuLyID: payload.adminId,
        NgayXuLy: new Date(),
      },
      select: REPORT_SELECT,
    });

    return {
      message: 'Xu ly bao cao thanh cong',
      report: this.toReportDto(updated),
    };
  }

  private toReportDto(report: ReportEntity): ReportDto {
    return {
      baoCaoId: report.BaoCaoID,
      nguoiBaoCaoId: report.NguoiBaoCaoID,
      nguoiBiCaoId: report.NguoiBiCaoID,
      lyDo: report.LyDo,
      moTa: report.MoTa,
      trangThai: report.TrangThai,
      ketQua: report.KetQua,
      adminXuLyId: report.AdminXuLyID,
      ngayTao: report.NgayTao.toISOString(),
      ngayXuLy: report.NgayXuLy ? report.NgayXuLy.toISOString() : null,
    };
  }
}
