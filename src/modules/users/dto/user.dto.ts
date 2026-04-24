import type {
  GioiTinh,
  TrangThaiDonViGiamSat,
  TrangThaiTaiKhoan,
  VaiTroTaiKhoan,
} from '@prisma/client';

export type UserDto = {
  taiKhoanId: number;
  tenDangNhap: string;
  email: string;
  hoTen: string;
  soDienThoai: string | null;
  gioiTinh: GioiTinh | null;
  diaChi: string | null;
  vaiTro: VaiTroTaiKhoan;
  trangThai: TrangThaiTaiKhoan;
  ngayTao: string;
  ngayCapNhat: string;
};

export type UsersListResponseDto = {
  total: number;
  users: UserDto[];
};

export type UserResponseDto = {
  user: UserDto;
};

export type UserMutationResponseDto = {
  message: string;
  user: UserDto;
};

export type UserDeleteResponseDto = {
  message: string;
  userId: number;
  trangThai: TrangThaiTaiKhoan;
};

export type SearchUsersQueryDto = {
  keyword?: string;
};

export type UpdateUserDto = {
  tenDangNhap?: string;
  email?: string;
  hoTen?: string;
  soDienThoai?: string;
  gioiTinh?: GioiTinh;
  diaChi?: string;
  trangThai?: TrangThaiTaiKhoan;
};

export type NguoiThueProfileDto = {
  nguoiThueId: number;
  congTy: string | null;
  moTa: string | null;
  diemTinCay: string;
  tongYeuCau: number;
  tyLeHoanThanh: string;
};

export type FreelancerProfileDto = {
  freelancerId: number;
  kinhNghiem: number;
  chuyenGia: string | null;
  kyNang: string | null;
  xepHang: string;
  soDu: string;
  xacThucEmail: boolean;
  xacThucSDT: boolean;
  tongCongViec: number;
  tyLeHoanThanh: string;
};

export type DonViGiamSatProfileDto = {
  giamSatId: number;
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

export type UserProfileDataDto =
  | { role: 'NguoiThue'; nguoiThue: NguoiThueProfileDto | null }
  | { role: 'Freelancer'; freelancer: FreelancerProfileDto | null }
  | { role: 'DonViGiamSat'; donViGiamSat: DonViGiamSatProfileDto | null }
  | { role: 'KhachVangLai' | 'Admin'; data: null };

export type UserProfileResponseDto = {
  user: UserDto;
  profile: UserProfileDataDto;
};
