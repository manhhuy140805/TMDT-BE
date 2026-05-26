import type { TrangThaiXacNhanTienDo } from '@prisma/client';

export type ProgressDto = {
  tienDoId: number;
  congViecId: number;
  freelancerId: number;
  tieuDe: string;
  moTa: string | null;
  phanTram: number;
  tepDinhKem: string | null;
  xacNhanBoi: number | null;
  trangThaiXacNhan: TrangThaiXacNhanTienDo;
  ngayTao: string;
};

export type ProgressWithDetailsDto = ProgressDto & {
  congViec: {
    congViecId: number;
    yeuCauId: number;
    giaThoa: string;
  };
  freelancer: {
    freelancerId: number;
    taiKhoanId: number;
    hoTen: string;
    email: string;
  };
  donViGiamSat: {
    giamSatId: number;
    tenDonVi: string;
  } | null;
};

export type ProgressListResponseDto = {
  total: number;
  progress: ProgressWithDetailsDto[];
};

export type ProgressResponseDto = {
  progress: ProgressWithDetailsDto;
};

export type CreateProgressDto = {
  congViecId: number;
  freelancerId: number;
  tieuDe: string;
  moTa?: string;
  phanTram: number;
  tepDinhKem?: string;
};

export type UpdateProgressDto = {
  tieuDe?: string;
  moTa?: string;
  phanTram?: number;
  tepDinhKem?: string;
  trangThaiXacNhan?: TrangThaiXacNhanTienDo;
  /** TaiKhoanID cua don vi giam sat khi duyet hoac tu choi tien do. */
  xacNhanBoi?: number;
};

export type ProgressMutationResponseDto = {
  message: string;
  progress: ProgressWithDetailsDto;
};

export type ProgressDeleteResponseDto = {
  message: string;
  progressId: number;
};
