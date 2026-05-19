import type { TrangThaiYeuCau } from '@prisma/client';

export type SkillSummaryDto = {
  kyNangId: number;
  tenKyNang: string;
};

export type JobDto = {
  yeuCauId: number;
  nguoiThueId: number;
  loaiDichVuId: number;
  tieuDe: string;
  moTa: string;
  nganSachMin: string;
  nganSachMax: string;
  thoiHan: string;
  trangThai: TrangThaiYeuCau;
  soLuongBaoGia: number;
  yeuCauGiamSat: boolean;
  ngayTao: string;
  ngayCapNhat: string;
};

export type JobWithDetailsDto = JobDto & {
  nguoiThue: {
    taiKhoanId: number;
    hoTen: string;
    email: string;
  };
  loaiDichVu: {
    loaiDichVuId: number;
    tenLoai: string;
  };
  kyNangs: SkillSummaryDto[];
};

export type JobsListResponseDto = {
  total: number;
  jobs: JobWithDetailsDto[];
};

export type JobResponseDto = {
  job: JobWithDetailsDto;
};

export type CreateJobDto = {
  nguoiThueId: number;
  loaiDichVuId: number;
  tieuDe: string;
  moTa: string;
  nganSachMin: number;
  nganSachMax: number;
  thoiHan: string;
  yeuCauGiamSat?: boolean;
  /** Danh sách KyNangID yêu cầu (optional) */
  kyNangIds?: number[];
};

export type UpdateJobDto = {
  loaiDichVuId?: number;
  tieuDe?: string;
  moTa?: string;
  nganSachMin?: number;
  nganSachMax?: number;
  thoiHan?: string;
  trangThai?: TrangThaiYeuCau;
  yeuCauGiamSat?: boolean;
};

export type JobMutationResponseDto = {
  message: string;
  job: JobWithDetailsDto;
};

export type JobDeleteResponseDto = {
  message: string;
  jobId: number;
};

export type SearchJobsQueryDto = {
  keyword?: string;
  category?: string;
  budget?: string;
  /** Lọc theo KyNangID (comma-separated, e.g. "1,2,3") */
  skills?: string;
};

export type SetJobSkillsDto = {
  kyNangIds: number[];
};

export type JobSkillsMutationResponseDto = {
  message: string;
  kyNangs: SkillSummaryDto[];
};
