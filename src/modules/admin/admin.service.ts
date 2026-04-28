import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../common/prisma/prisma.service';
import type {
  AdminMutationResponseDto,
  AdminStatisticsResponseDto,
  AdminSupervisorListResponseDto,
  AdminUserListResponseDto,
} from './dto';

@Injectable()
export class AdminService {
  constructor(private readonly prisma: PrismaService) {}

  async getUsers(): Promise<AdminUserListResponseDto> {
    const users = await this.prisma.taiKhoan.findMany({
      orderBy: { NgayTao: 'desc' },
    });

    return {
      total: users.length,
      users: users.map((u) => ({
        taiKhoanId: u.TaiKhoanID,
        tenDangNhap: u.TenDangNhap,
        email: u.Email,
        hoTen: u.HoTen,
        vaiTro: u.VaiTro,
        trangThai: u.TrangThai,
        ngayTao: u.NgayTao.toISOString(),
      })),
    };
  }

  async banUser(id: number): Promise<AdminMutationResponseDto> {
    const user = await this.prisma.taiKhoan.findUnique({
      where: { TaiKhoanID: id },
    });

    if (!user) {
      throw new NotFoundException('Nguoi dung khong ton tai');
    }

    await this.prisma.taiKhoan.update({
      where: { TaiKhoanID: id },
      data: { TrangThai: 'BiKhoa' },
    });

    return { message: 'Da khoa tai khoan thanh cong' };
  }

  async getSupervisors(): Promise<AdminSupervisorListResponseDto> {
    const supervisors = await this.prisma.donViGiamSat.findMany({
      include: {
        TaiKhoan: {
          select: { HoTen: true, Email: true },
        },
      },
      orderBy: { NgayDangKy: 'desc' },
    });

    return {
      total: supervisors.length,
      supervisors: supervisors.map((s) => ({
        giamSatId: s.GiamSatID,
        taiKhoanId: s.TaiKhoanID,
        tenDonVi: s.TenDonVi,
        phiGiamSat: s.PhiGiamSat.toString(),
        trangThai: s.TrangThai,
        ngayDangKy: s.NgayDangKy.toISOString(),
        hoTen: s.TaiKhoan.HoTen,
        email: s.TaiKhoan.Email,
      })),
    };
  }

  async approveSupervisor(id: number): Promise<AdminMutationResponseDto> {
    const supervisor = await this.prisma.donViGiamSat.findUnique({
      where: { GiamSatID: id },
    });

    if (!supervisor) {
      throw new NotFoundException('Don vi giam sat khong ton tai');
    }

    await this.prisma.donViGiamSat.update({
      where: { GiamSatID: id },
      data: { TrangThai: 'HoatDong' },
    });

    return { message: 'Phe duyet don vi giam sat thanh cong' };
  }

  async getStatistics(): Promise<AdminStatisticsResponseDto> {
    const [
      totalUsers,
      totalContracts,
      activeContracts,
      pendingDisputes,
      pendingReports,
    ] = await Promise.all([
      this.prisma.taiKhoan.count(),
      this.prisma.congViec.count(),
      this.prisma.congViec.count({ where: { TrangThai: 'DangThucHien' } }),
      this.prisma.tranhChap.count({ where: { TrangThai: 'MoiMo' } }),
      this.prisma.baoCao.count({ where: { TrangThai: 'ChoXuLy' } }),
    ]);

    return {
      statistics: {
        totalUsers,
        totalContracts,
        activeContracts,
        pendingDisputes,
        pendingReports,
      },
    };
  }
}
