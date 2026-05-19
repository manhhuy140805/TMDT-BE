import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import type { Prisma } from '@prisma/client';
import { PrismaService } from '../../common/prisma/prisma.service';
import type {
  CreateSkillDto,
  SkillDeleteResponseDto,
  SkillDto,
  SkillMutationResponseDto,
  SkillResponseDto,
  SkillsListResponseDto,
  UpdateSkillDto,
} from './dto';

const SKILL_SELECT = {
  KyNangID: true,
  TenKyNang: true,
  MoTa: true,
} as const;

type SkillEntity = Prisma.KyNangGetPayload<{ select: typeof SKILL_SELECT }>;

@Injectable()
export class SkillsService {
  constructor(private readonly prisma: PrismaService) {}

  async findAll(): Promise<SkillsListResponseDto> {
    const skills = await this.prisma.kyNang.findMany({
      select: SKILL_SELECT,
      orderBy: { KyNangID: 'asc' },
    });

    return {
      total: skills.length,
      skills: skills.map((s) => this.toSkillDto(s)),
    };
  }

  async findOne(id: number): Promise<SkillResponseDto> {
    const skill = await this.findSkillOrThrow(id);
    return { skill: this.toSkillDto(skill) };
  }

  async create(payload: CreateSkillDto): Promise<SkillMutationResponseDto> {
    const tenKyNang = this.requireText(payload.tenKyNang, 'tenKyNang');

    await this.ensureUniqueTenKyNang(tenKyNang);

    const skill = await this.prisma.kyNang.create({
      data: {
        TenKyNang: tenKyNang,
        MoTa: this.cleanOptionalText(payload.moTa),
      },
      select: SKILL_SELECT,
    });

    return { message: 'Tao ky nang thanh cong', skill: this.toSkillDto(skill) };
  }

  async update(
    id: number,
    payload: UpdateSkillDto,
  ): Promise<SkillMutationResponseDto> {
    await this.findSkillOrThrow(id);

    const data: Prisma.KyNangUpdateInput = {};

    if (payload.tenKyNang !== undefined) {
      data.TenKyNang = this.requireText(payload.tenKyNang, 'tenKyNang');
      await this.ensureUniqueTenKyNang(data.TenKyNang as string, id);
    }

    if (payload.moTa !== undefined) {
      data.MoTa = this.cleanOptionalText(payload.moTa);
    }

    if (Object.keys(data).length === 0) {
      throw new BadRequestException('Khong co truong hop le de cap nhat');
    }

    const skill = await this.prisma.kyNang.update({
      where: { KyNangID: id },
      data,
      select: SKILL_SELECT,
    });

    return {
      message: 'Cap nhat ky nang thanh cong',
      skill: this.toSkillDto(skill),
    };
  }

  async remove(id: number): Promise<SkillDeleteResponseDto> {
    await this.findSkillOrThrow(id);

    await this.prisma.kyNang.delete({ where: { KyNangID: id } });

    return { message: 'Xoa ky nang thanh cong', kyNangId: id };
  }

  private async findSkillOrThrow(id: number): Promise<SkillEntity> {
    const skill = await this.prisma.kyNang.findUnique({
      where: { KyNangID: id },
      select: SKILL_SELECT,
    });

    if (!skill) {
      throw new NotFoundException('Ky nang khong ton tai');
    }

    return skill;
  }

  private async ensureUniqueTenKyNang(
    tenKyNang: string,
    excludeId?: number,
  ): Promise<void> {
    const existing = await this.prisma.kyNang.findFirst({
      where: {
        TenKyNang: tenKyNang,
        ...(excludeId && { KyNangID: { not: excludeId } }),
      },
      select: { KyNangID: true },
    });

    if (existing) {
      throw new BadRequestException('Ten ky nang da ton tai');
    }
  }

  private toSkillDto(skill: SkillEntity): SkillDto {
    return {
      kyNangId: skill.KyNangID,
      tenKyNang: skill.TenKyNang,
      moTa: skill.MoTa,
    };
  }

  private requireText(value: string | undefined, fieldName: string): string {
    const trimmed = value?.trim();
    if (!trimmed) {
      throw new BadRequestException(`${fieldName} is required`);
    }
    return trimmed;
  }

  private cleanOptionalText(value: string | undefined): string | null {
    const trimmed = value?.trim();
    return trimmed ? trimmed : null;
  }
}
