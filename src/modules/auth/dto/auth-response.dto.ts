import { GioiTinh, TrangThaiTaiKhoan, VaiTroTaiKhoan } from '@prisma/client';

export type AuthUserDto = {
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
};

export type AuthResponseDto = {
  message: string;
  user: AuthUserDto;
};
