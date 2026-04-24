import { GioiTinh, VaiTroTaiKhoan } from '@prisma/client';

export type AuthRegisterDto = {
  tenDangNhap?: string;
  matKhau?: string;
  email?: string;
  hoTen?: string;
  soDienThoai?: string;
  gioiTinh?: GioiTinh;
  diaChi?: string;
  vaiTro?: VaiTroTaiKhoan;
  tenDonVi?: string;
};
