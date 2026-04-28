import type { LoaiDanhGia } from '@prisma/client';

export type ReviewDto = {
  danhGiaId: number;
  congViecId: number;
  nguoiDanhGiaId: number;
  nguoiDuocDGId: number;
  diemSo: number;
  binhLuan: string | null;
  loaiDanhGia: LoaiDanhGia;
  giamSatId: number | null;
  ngayTao: string;
};

export type ReviewListResponseDto = {
  total: number;
  reviews: ReviewDto[];
};

export type ReviewResponseDto = {
  review: ReviewDto;
};

export type CreateReviewDto = {
  congViecId: number;
  nguoiDanhGiaId: number;
  nguoiDuocDGId: number;
  diemSo: number;
  binhLuan?: string;
  loaiDanhGia: LoaiDanhGia;
  giamSatId?: number;
};

export type ReviewMutationResponseDto = {
  message: string;
  review: ReviewDto;
};
