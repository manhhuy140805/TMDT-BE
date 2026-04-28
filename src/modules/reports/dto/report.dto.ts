import type { TrangThaiBaoCao } from '@prisma/client';

export type ReportDto = {
  baoCaoId: number;
  nguoiBaoCaoId: number;
  nguoiBiCaoId: number;
  lyDo: string;
  moTa: string | null;
  trangThai: TrangThaiBaoCao;
  ketQua: string | null;
  adminXuLyId: number | null;
  ngayTao: string;
  ngayXuLy: string | null;
};

export type ReportListResponseDto = {
  total: number;
  reports: ReportDto[];
};

export type ReportResponseDto = {
  report: ReportDto;
};

export type CreateReportDto = {
  nguoiBaoCaoId: number;
  nguoiBiCaoId: number;
  lyDo: string;
  moTa?: string;
};

export type ResolveReportDto = {
  adminId: number;
  trangThai: TrangThaiBaoCao;
  ketQua: string;
};

export type ReportMutationResponseDto = {
  message: string;
  report: ReportDto;
};
