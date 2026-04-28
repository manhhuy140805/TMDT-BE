export type AdminUserDto = {
  taiKhoanId: number;
  tenDangNhap: string;
  email: string;
  hoTen: string;
  vaiTro: string;
  trangThai: string;
  ngayTao: string;
};

export type AdminUserListResponseDto = {
  total: number;
  users: AdminUserDto[];
};

export type AdminSupervisorDto = {
  giamSatId: number;
  taiKhoanId: number;
  tenDonVi: string;
  phiGiamSat: string;
  trangThai: string;
  ngayDangKy: string;
  hoTen: string;
  email: string;
};

export type AdminSupervisorListResponseDto = {
  total: number;
  supervisors: AdminSupervisorDto[];
};

export type AdminStatisticsDto = {
  totalUsers: number;
  totalContracts: number;
  activeContracts: number;
  pendingDisputes: number;
  pendingReports: number;
};

export type AdminStatisticsResponseDto = {
  statistics: AdminStatisticsDto;
};

export type AdminMutationResponseDto = {
  message: string;
};
