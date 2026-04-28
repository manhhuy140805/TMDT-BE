import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../../common/prisma/prisma.service';
import type { Prisma } from '@prisma/client';
import type {
  CreateReviewDto,
  ReviewDto,
  ReviewListResponseDto,
  ReviewMutationResponseDto,
  ReviewResponseDto,
} from './dto';

const REVIEW_SELECT = {
  DanhGiaID: true,
  CongViecID: true,
  NguoiDanhGiaID: true,
  NguoiDuocDGID: true,
  DiemSo: true,
  BinhLuan: true,
  LoaiDanhGia: true,
  GiamSatID: true,
  NgayTao: true,
} as const;

type ReviewEntity = Prisma.DanhGiaGetPayload<{
  select: typeof REVIEW_SELECT;
}>;

@Injectable()
export class ReviewsService {
  constructor(private readonly prisma: PrismaService) {}

  async findById(id: number): Promise<ReviewResponseDto> {
    const review = await this.prisma.danhGia.findUnique({
      where: { DanhGiaID: id },
      select: REVIEW_SELECT,
    });

    if (!review) {
      throw new NotFoundException('Danh gia khong ton tai');
    }

    return { review: this.toReviewDto(review) };
  }

  async findByUserId(userId: number): Promise<ReviewListResponseDto> {
    const reviews = await this.prisma.danhGia.findMany({
      where: { NguoiDuocDGID: userId },
      select: REVIEW_SELECT,
      orderBy: { NgayTao: 'desc' },
    });

    return {
      total: reviews.length,
      reviews: reviews.map((r) => this.toReviewDto(r)),
    };
  }

  async findByContractId(contractId: number): Promise<ReviewListResponseDto> {
    const reviews = await this.prisma.danhGia.findMany({
      where: { CongViecID: contractId },
      select: REVIEW_SELECT,
      orderBy: { NgayTao: 'desc' },
    });

    return {
      total: reviews.length,
      reviews: reviews.map((r) => this.toReviewDto(r)),
    };
  }

  async create(payload: CreateReviewDto): Promise<ReviewMutationResponseDto> {
    const contract = await this.prisma.congViec.findUnique({
      where: { CongViecID: payload.congViecId },
    });

    if (!contract) {
      throw new NotFoundException('Hop dong khong ton tai');
    }

    if (payload.diemSo < 1 || payload.diemSo > 5) {
      throw new BadRequestException('Diem so phai tu 1 den 5');
    }

    // Check if the user has already reviewed this entity for this contract
    const existingReview = await this.prisma.danhGia.findFirst({
      where: {
        CongViecID: payload.congViecId,
        NguoiDanhGiaID: payload.nguoiDanhGiaId,
        NguoiDuocDGID: payload.nguoiDuocDGId,
        LoaiDanhGia: payload.loaiDanhGia,
      },
    });

    if (existingReview) {
      throw new BadRequestException('Ban da danh gia doi tuong nay roi');
    }

    const review = await this.prisma.danhGia.create({
      data: {
        CongViecID: payload.congViecId,
        NguoiDanhGiaID: payload.nguoiDanhGiaId,
        NguoiDuocDGID: payload.nguoiDuocDGId,
        DiemSo: payload.diemSo,
        BinhLuan: payload.binhLuan,
        LoaiDanhGia: payload.loaiDanhGia,
        GiamSatID: payload.giamSatId || null,
      },
      select: REVIEW_SELECT,
    });

    // Optional: After saving the review, recalculate the target user's average rating 
    // depending on whether they are Freelancer, NguoiThue, or DonViGiamSat.
    // For now, this just stores the review.

    return {
      message: 'Danh gia thanh cong',
      review: this.toReviewDto(review),
    };
  }

  private toReviewDto(review: ReviewEntity): ReviewDto {
    return {
      danhGiaId: review.DanhGiaID,
      congViecId: review.CongViecID,
      nguoiDanhGiaId: review.NguoiDanhGiaID,
      nguoiDuocDGId: review.NguoiDuocDGID,
      diemSo: review.DiemSo,
      binhLuan: review.BinhLuan,
      loaiDanhGia: review.LoaiDanhGia,
      giamSatId: review.GiamSatID,
      ngayTao: review.NgayTao.toISOString(),
    };
  }
}
