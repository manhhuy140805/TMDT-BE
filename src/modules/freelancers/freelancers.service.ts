import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../../common/prisma/prisma.service';
import type { SkillSummaryDto } from '../jobs/dto';
import type {
  FreelancerSkillsResponseDto,
  SetFreelancerSkillsDto,
} from './dto';

@Injectable()
export class FreelancersService {
  constructor(private readonly prisma: PrismaService) {}

  async getSkills(freelancerId: number): Promise<FreelancerSkillsResponseDto> {
    await this.findFreelancerOrThrow(freelancerId);

    const rows = await this.prisma.freelancerKyNang.findMany({
      where: { TaiKhoanID: freelancerId },
      select: {
        KyNang: { select: { KyNangID: true, TenKyNang: true } },
      },
    });

    return {
      message: 'Lay danh sach ky nang thanh cong',
      freelancerId,
      kyNangs: rows.map((r) => this.toSkillSummary(r.KyNang)),
    };
  }

  async setSkills(
    freelancerId: number,
    payload: SetFreelancerSkillsDto,
  ): Promise<FreelancerSkillsResponseDto> {
    await this.findFreelancerOrThrow(freelancerId);

    if (payload.kyNangIds.length > 0) {
      await this.validateKyNangIds(payload.kyNangIds);
    }

    await this.prisma.$transaction([
      this.prisma.freelancerKyNang.deleteMany({
        where: { TaiKhoanID: freelancerId },
      }),
      ...(payload.kyNangIds.length > 0
        ? [
            this.prisma.freelancerKyNang.createMany({
              data: payload.kyNangIds.map((kyNangId) => ({
                TaiKhoanID: freelancerId,
                KyNangID: kyNangId,
              })),
            }),
          ]
        : []),
    ]);

    return this.getSkills(freelancerId);
  }

  async addSkill(
    freelancerId: number,
    kyNangId: number,
  ): Promise<FreelancerSkillsResponseDto> {
    await this.findFreelancerOrThrow(freelancerId);
    await this.validateKyNangIds([kyNangId]);

    await this.prisma.freelancerKyNang.upsert({
      where: {
        TaiKhoanID_KyNangID: { TaiKhoanID: freelancerId, KyNangID: kyNangId },
      },
      create: { TaiKhoanID: freelancerId, KyNangID: kyNangId },
      update: {},
    });

    return this.getSkills(freelancerId);
  }

  async removeSkill(
    freelancerId: number,
    kyNangId: number,
  ): Promise<FreelancerSkillsResponseDto> {
    await this.findFreelancerOrThrow(freelancerId);

    await this.prisma.freelancerKyNang.deleteMany({
      where: { TaiKhoanID: freelancerId, KyNangID: kyNangId },
    });

    return this.getSkills(freelancerId);
  }

  private async findFreelancerOrThrow(freelancerId: number): Promise<void> {
    // freelancerId is now TaiKhoanID
    const taiKhoan = await this.prisma.taiKhoan.findUnique({
      where: { TaiKhoanID: freelancerId },
      select: { TaiKhoanID: true },
    });

    if (!taiKhoan) {
      throw new NotFoundException('Freelancer khong ton tai');
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

  private toSkillSummary(kyNang: {
    KyNangID: number;
    TenKyNang: string;
  }): SkillSummaryDto {
    return { kyNangId: kyNang.KyNangID, tenKyNang: kyNang.TenKyNang };
  }
}
