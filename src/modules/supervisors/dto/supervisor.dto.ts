import type { TrangThaiDonViGiamSat } from '@prisma/client';

export type SupervisorDto = {
  giamSatId: number;
  taiKhoanId: number;
  tenDonVi: string;
  moTa: string | null;
  nangLuc: string | null;
  chungChi: string | null;
  phiGiamSat: string;
  xepHang: string;
  tongCongViecGS: number;
  trangThai: TrangThaiDonViGiamSat;
  ngayDangKy: string;
};

export type SupervisorWithDetailsDto = SupervisorDto & {
  taiKhoan: {
    taiKhoanId: number;
    hoTen: string;
    email: string;
    soDienThoai: string | null;
  };
};

export type SupervisorsListResponseDto = {
  total: number;
  supervisors: SupervisorWithDetailsDto[];
};

export type SupervisorResponseDto = {
  supervisor: SupervisorWithDetailsDto;
};

export type CreateSupervisorDto = {
  taiKhoanId: number;
  tenDonVi: string;
  moTa?: string;
  nangLuc?: string;
  chungChi?: string;
  phiGiamSat: number;
};

export type UpdateSupervisorDto = {
  tenDonVi?: string;
  moTa?: string;
  nangLuc?: string;
  chungChi?: string;
  phiGiamSat?: number;
  trangThai?: TrangThaiDonViGiamSat;
};

export type SupervisorMutationResponseDto = {
  message: string;
  supervisor: SupervisorWithDetailsDto;
};

export type SupervisorDeleteResponseDto = {
  message: string;
  supervisorId: number;
};

export type SearchSupervisorsQueryDto = {
  keyword?: string;
};
