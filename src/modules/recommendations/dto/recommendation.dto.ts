export type RecommendedFreelancerDto = {
  freelancerId: number;
  taiKhoanId: number;
  hoTen: string;
  email: string;
  chuyenGia: string | null;
  kinhNghiem: number;
  xepHang: string;
  tongCongViec: number;
  tyLeHoanThanh: string;
  kyNangs: { kyNangId: number; tenKyNang: string }[];
  /** So ky nang trung khop voi yeu cau */
  soKyNangKhop: number;
};

export type RecommendedFreelancersResponseDto = {
  total: number;
  yeuCauId: number;
  freelancers: RecommendedFreelancerDto[];
};

export type RecommendedSupervisorDto = {
  giamSatId: number;
  taiKhoanId: number;
  tenDonVi: string;
  moTa: string | null;
  nangLuc: string | null;
  chungChi: string | null;
  phiGiamSat: string;
  xepHang: string;
  tongCongViecGS: number;
};

export type RecommendedSupervisorsResponseDto = {
  total: number;
  supervisors: RecommendedSupervisorDto[];
};
