import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import type { Prisma } from '@prisma/client';
import { PrismaService } from '../../common/prisma/prisma.service';
import type {
  CategoriesListResponseDto,
  CategoryDeleteResponseDto,
  CategoryDto,
  CategoryMutationResponseDto,
  CategoryResponseDto,
  CreateCategoryDto,
  UpdateCategoryDto,
} from './dto';

const CATEGORY_SELECT = {
  LoaiDichVuID: true,
  TenLoai: true,
  MoTa: true,
  HinhAnh: true,
} as const;

type CategoryEntity = Prisma.LoaiDichVuGetPayload<{
  select: typeof CATEGORY_SELECT;
}>;

@Injectable()
export class CategoriesService {
  constructor(private readonly prisma: PrismaService) {}

  async findAll(): Promise<CategoriesListResponseDto> {
    const categories = await this.prisma.loaiDichVu.findMany({
      select: CATEGORY_SELECT,
      orderBy: {
        LoaiDichVuID: 'asc',
      },
    });

    return {
      total: categories.length,
      categories: categories.map((cat) => this.toCategoryDto(cat)),
    };
  }

  async findOne(id: number): Promise<CategoryResponseDto> {
    const category = await this.findCategoryOrThrow(id);

    return { category: this.toCategoryDto(category) };
  }

  async create(
    payload: CreateCategoryDto,
  ): Promise<CategoryMutationResponseDto> {
    const tenLoai = this.requireText(payload.tenLoai, 'tenLoai');

    await this.ensureUniqueTenLoai(tenLoai);

    const category = await this.prisma.loaiDichVu.create({
      data: {
        TenLoai: tenLoai,
        MoTa: this.cleanOptionalText(payload.moTa),
        HinhAnh: this.cleanOptionalText(payload.hinhAnh),
      },
      select: CATEGORY_SELECT,
    });

    return {
      message: 'Tao loai dich vu thanh cong',
      category: this.toCategoryDto(category),
    };
  }

  async update(
    id: number,
    payload: UpdateCategoryDto,
  ): Promise<CategoryMutationResponseDto> {
    await this.findCategoryOrThrow(id);

    const data = this.buildUpdateData(payload);

    if (data.TenLoai) {
      await this.ensureUniqueTenLoai(data.TenLoai as string, id);
    }

    const category = await this.prisma.loaiDichVu.update({
      where: { LoaiDichVuID: id },
      data,
      select: CATEGORY_SELECT,
    });

    return {
      message: 'Cap nhat loai dich vu thanh cong',
      category: this.toCategoryDto(category),
    };
  }

  async remove(id: number): Promise<CategoryDeleteResponseDto> {
    await this.findCategoryOrThrow(id);

    await this.prisma.loaiDichVu.delete({
      where: { LoaiDichVuID: id },
    });

    return {
      message: 'Xoa loai dich vu thanh cong',
      categoryId: id,
    };
  }

  private async findCategoryOrThrow(id: number): Promise<CategoryEntity> {
    const category = await this.prisma.loaiDichVu.findUnique({
      where: { LoaiDichVuID: id },
      select: CATEGORY_SELECT,
    });

    if (!category) {
      throw new NotFoundException('Loai dich vu khong ton tai');
    }

    return category;
  }

  private async ensureUniqueTenLoai(
    tenLoai: string,
    excludeId?: number,
  ): Promise<void> {
    const existing = await this.prisma.loaiDichVu.findFirst({
      where: {
        TenLoai: tenLoai,
        ...(excludeId && { LoaiDichVuID: { not: excludeId } }),
      },
      select: { LoaiDichVuID: true },
    });

    if (existing) {
      throw new BadRequestException('Ten loai dich vu da ton tai');
    }
  }

  private buildUpdateData(
    payload: UpdateCategoryDto,
  ): Prisma.LoaiDichVuUpdateInput {
    const data: Prisma.LoaiDichVuUpdateInput = {};

    if (payload.tenLoai !== undefined) {
      data.TenLoai = this.requireText(payload.tenLoai, 'tenLoai');
    }

    if (payload.moTa !== undefined) {
      data.MoTa = this.cleanOptionalText(payload.moTa);
    }

    if (payload.hinhAnh !== undefined) {
      data.HinhAnh = this.cleanOptionalText(payload.hinhAnh);
    }

    if (Object.keys(data).length === 0) {
      throw new BadRequestException('Khong co truong hop le de cap nhat');
    }

    return data;
  }

  private toCategoryDto(category: CategoryEntity): CategoryDto {
    return {
      loaiDichVuId: category.LoaiDichVuID,
      tenLoai: category.TenLoai,
      moTa: category.MoTa,
      hinhAnh: category.HinhAnh,
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
