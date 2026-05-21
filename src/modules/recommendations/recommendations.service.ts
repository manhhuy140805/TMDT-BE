import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../common/prisma/prisma.service';
import type {
  RecommendedFreelancerDto,
  RecommendedFreelancersResponseDto,
  RecommendedSupervisorDto,
  RecommendedSupervisorsResponseDto,
} from './dto';

@Injectable()
export class RecommendationsService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * De xuat freelancer phu hop cho mot yeu cau.
   * Logic: match ky nang cua freelancer voi ky nang yeu cau,
   * sap xep theo so ky nang khop (giam dan), xep hang, ty le hoan thanh.
   */
  async recommendFreelancers(
    yeuCauId: number,
  ): Promise<RecommendedFreelancersResponseDto> {
    // Get job with required skills
    const yeuCau = await this.prisma.yeuCau.findUnique({
      where: { YeuCauID: yeuCauId },
      select: {
        YeuCauID: true,
        YeuCauKyNangs: { select: { KyNangID: true } },
      },
    });

    if (!yeuCau) {
      throw new NotFoundException('Yeu cau khong ton tai');
    }

    const requiredSkillIds = yeuCau.YeuCauKyNangs.map((k) => k.KyNangID);

    // Get all active freelancers with their skills
    const freelancers = await this.prisma.freelancer.findMany({
      select: {
        FreelancerID: true,
        KinhNghiem: true,
        ChuyenGia: true,
        XepHang: true,
        TongCongViec: true,
        TyLeHoanThanh: true,
        TaiKhoan: {
          select: {
            TaiKhoanID: true,
            HoTen: true,
            Email: true,
            TrangThai: true,
            FreelancerKyNangs: {
              select: {
                KyNang: { select: { KyNangID: true, TenKyNang: true } },
              },
            },
          },
        },
      },
    });

    // Filter only active accounts and calculate match score
    const scored: (RecommendedFreelancerDto & { score: number })[] = [];

    for (const fl of freelancers) {
      if (fl.TaiKhoan.TrangThai !== 'HoatDong') continue;

      const flSkillIds = fl.TaiKhoan.FreelancerKyNangs.map((k) => k.KyNang.KyNangID);
      const soKyNangKhop = requiredSkillIds.filter((id) =>
        flSkillIds.includes(id),
      ).length;

      // Only recommend if at least 1 skill matches (or no skills required)
      if (requiredSkillIds.length > 0 && soKyNangKhop === 0) continue;

      const score =
        soKyNangKhop * 10 +
        Number(fl.XepHang) * 2 +
        Number(fl.TyLeHoanThanh) * 0.1;

      scored.push({
        freelancerId: fl.FreelancerID,
        taiKhoanId: fl.TaiKhoan.TaiKhoanID,
        hoTen: fl.TaiKhoan.HoTen,
        email: fl.TaiKhoan.Email,
        chuyenGia: fl.ChuyenGia,
        kinhNghiem: fl.KinhNghiem,
        xepHang: fl.XepHang.toString(),
        tongCongViec: fl.TongCongViec,
        tyLeHoanThanh: fl.TyLeHoanThanh.toString(),
        kyNangs: fl.TaiKhoan.FreelancerKyNangs.map((k) => ({
          kyNangId: k.KyNang.KyNangID,
          tenKyNang: k.KyNang.TenKyNang,
        })),
        soKyNangKhop,
        score,
      });
    }

    // Sort by score descending, limit to top 10
    scored.sort((a, b) => b.score - a.score);
    const top = scored.slice(0, 10);

    return {
      total: top.length,
      yeuCauId,
      freelancers: top.map(({ score, ...rest }) => rest),
    };
  }

  /**
   * De xuat don vi giam sat phu hop.
   * Logic: chi lay don vi dang HoatDong, sap xep theo xep hang va so cong viec da giam sat.
   */
  async recommendSupervisors(): Promise<RecommendedSupervisorsResponseDto> {
    const supervisors = await this.prisma.donViGiamSat.findMany({
      where: { TrangThai: 'HoatDong' },
      select: {
        GiamSatID: true,
        TaiKhoanID: true,
        TenDonVi: true,
        MoTa: true,
        NangLuc: true,
        ChungChi: true,
        PhiGiamSat: true,
        XepHang: true,
        TongCongViecGS: true,
      },
      orderBy: [{ XepHang: 'desc' }, { TongCongViecGS: 'desc' }],
      take: 10,
    });

    return {
      total: supervisors.length,
      supervisors: supervisors.map((s) => this.toSupervisorDto(s)),
    };
  }

  private toSupervisorDto(s: any): RecommendedSupervisorDto {
    return {
      giamSatId: s.GiamSatID,
      taiKhoanId: s.TaiKhoanID,
      tenDonVi: s.TenDonVi,
      moTa: s.MoTa,
      nangLuc: s.NangLuc,
      chungChi: s.ChungChi,
      phiGiamSat: s.PhiGiamSat.toString(),
      xepHang: s.XepHang.toString(),
      tongCongViecGS: s.TongCongViecGS,
    };
  }
}
