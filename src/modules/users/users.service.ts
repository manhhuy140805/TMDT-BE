import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import type { Prisma } from '@prisma/client';
import { PrismaService } from '../../common/prisma/prisma.service';
import type {
  DonViGiamSatProfileDto,
  FreelancerProfileDto,
  NguoiThueProfileDto,
  SearchUsersQueryDto,
  UpdateUserDto,
  UserDeleteResponseDto,
  UserDto,
  UserMutationResponseDto,
  UserProfileDataDto,
  UserProfileResponseDto,
  UserResponseDto,
  UsersListResponseDto,
} from './dto';

type GioiTinhValue = 'Nam' | 'Nu' | 'Khac';
type TrangThaiValue = 'HoatDong' | 'BiKhoa' | 'ChoDuyet' | 'DaBi';

const USER_SELECT = {
  TaiKhoanID: true,
  TenDangNhap: true,
  Email: true,
  HoTen: true,
  SoDienThoai: true,
  GioiTinh: true,
  DiaChi: true,
  VaiTro: true,
  TrangThai: true,
  NgayTao: true,
  NgayCapNhat: true,
} as const;

type UserEntity = Prisma.TaiKhoanGetPayload<{ select: typeof USER_SELECT }>;

const GIOI_TINH_VALUES: readonly GioiTinhValue[] = ['Nam', 'Nu', 'Khac'];
const TRANG_THAI_VALUES: readonly TrangThaiValue[] = [
  'HoatDong',
  'BiKhoa',
  'ChoDuyet',
  'DaBi',
];

@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService) {}

  async findAll(): Promise<UsersListResponseDto> {
    const users = await this.prisma.taiKhoan.findMany({
      select: USER_SELECT,
      orderBy: {
        NgayTao: 'desc',
      },
    });

    return {
      total: users.length,
      users: users.map((user) => this.toUserDto(user)),
    };
  }

  async search(query: SearchUsersQueryDto): Promise<UsersListResponseDto> {
    const keyword = query.keyword?.trim();

    if (!keyword) {
      return this.findAll();
    }

    const users = await this.prisma.taiKhoan.findMany({
      where: {
        OR: [
          { TenDangNhap: { contains: keyword, mode: 'insensitive' } },
          { Email: { contains: keyword, mode: 'insensitive' } },
          { HoTen: { contains: keyword, mode: 'insensitive' } },
          { SoDienThoai: { contains: keyword, mode: 'insensitive' } },
        ],
      },
      select: USER_SELECT,
      orderBy: {
        NgayTao: 'desc',
      },
    });

    return {
      total: users.length,
      users: users.map((user) => this.toUserDto(user)),
    };
  }

  async findOne(id: number): Promise<UserResponseDto> {
    const user = await this.findUserOrThrow(id);

    return { user: this.toUserDto(user) };
  }

  async update(
    id: number,
    payload: UpdateUserDto,
  ): Promise<UserMutationResponseDto> {
    await this.findUserOrThrow(id);

    const data = this.buildUpdateData(payload);
    await this.ensureUniqueFields(id, data);

    const user = await this.prisma.taiKhoan.update({
      where: { TaiKhoanID: id },
      data,
      select: USER_SELECT,
    });

    return {
      message: 'Cap nhat nguoi dung thanh cong',
      user: this.toUserDto(user),
    };
  }

  async remove(id: number): Promise<UserDeleteResponseDto> {
    await this.findUserOrThrow(id);

    const user = await this.prisma.taiKhoan.update({
      where: { TaiKhoanID: id },
      data: { TrangThai: 'DaBi' },
      select: {
        TaiKhoanID: true,
        TrangThai: true,
      },
    });

    return {
      message: 'Xoa nguoi dung thanh cong',
      userId: user.TaiKhoanID,
      trangThai: user.TrangThai,
    };
  }

  async getProfile(id: number): Promise<UserProfileResponseDto> {
    const user = await this.findUserOrThrow(id);

    return {
      user: this.toUserDto(user),
      profile: await this.buildUserProfile(user),
    };
  }

  private async findUserOrThrow(id: number): Promise<UserEntity> {
    const user = await this.prisma.taiKhoan.findUnique({
      where: { TaiKhoanID: id },
      select: USER_SELECT,
    });

    if (!user) {
      throw new NotFoundException('Nguoi dung khong ton tai');
    }

    return user;
  }

  private buildUpdateData(payload: UpdateUserDto): Prisma.TaiKhoanUpdateInput {
    const data: Prisma.TaiKhoanUpdateInput = {};

    if (payload.tenDangNhap !== undefined) {
      data.TenDangNhap = this.requireText(payload.tenDangNhap, 'tenDangNhap');
    }

    if (payload.email !== undefined) {
      data.Email = this.requireText(payload.email, 'email').toLowerCase();
    }

    if (payload.hoTen !== undefined) {
      data.HoTen = this.requireText(payload.hoTen, 'hoTen');
    }

    if (payload.soDienThoai !== undefined) {
      data.SoDienThoai = this.cleanOptionalText(payload.soDienThoai);
    }

    if (payload.gioiTinh !== undefined) {
      this.ensureValidGioiTinh(payload.gioiTinh);
      data.GioiTinh = payload.gioiTinh;
    }

    if (payload.diaChi !== undefined) {
      data.DiaChi = this.cleanOptionalText(payload.diaChi);
    }

    if (payload.trangThai !== undefined) {
      this.ensureValidTrangThai(payload.trangThai);
      data.TrangThai = payload.trangThai;
    }

    if (Object.keys(data).length === 0) {
      throw new BadRequestException('Khong co truong hop le de cap nhat');
    }

    return data;
  }

  private async ensureUniqueFields(
    userId: number,
    data: Prisma.TaiKhoanUpdateInput,
  ): Promise<void> {
    const tenDangNhap =
      typeof data.TenDangNhap === 'string' ? data.TenDangNhap : undefined;
    const email = typeof data.Email === 'string' ? data.Email : undefined;

    const uniqueChecks: Prisma.TaiKhoanWhereInput[] = [];

    if (tenDangNhap) {
      uniqueChecks.push({ TenDangNhap: tenDangNhap });
    }

    if (email) {
      uniqueChecks.push({ Email: email });
    }

    if (uniqueChecks.length === 0) {
      return;
    }

    const duplicate = await this.prisma.taiKhoan.findFirst({
      where: {
        TaiKhoanID: { not: userId },
        OR: uniqueChecks,
      },
      select: {
        TenDangNhap: true,
        Email: true,
      },
    });

    if (!duplicate) {
      return;
    }

    if (tenDangNhap && duplicate.TenDangNhap === tenDangNhap) {
      throw new BadRequestException('Ten dang nhap da ton tai');
    }

    if (email && duplicate.Email === email) {
      throw new BadRequestException('Email da ton tai');
    }
  }

  private async buildUserProfile(
    user: UserEntity,
  ): Promise<UserProfileDataDto> {
    if (user.VaiTro === 'NguoiThue') {
      const profile = await this.prisma.nguoiThue.findFirst({
        where: { TaiKhoanID: user.TaiKhoanID },
        select: {
          NguoiThueID: true,
          CongTy: true,
          MoTa: true,
          DiemTinCay: true,
          TongYeuCau: true,
          TyLeHoanThanh: true,
        },
      });

      return {
        role: 'NguoiThue',
        nguoiThue: profile ? this.toNguoiThueProfileDto(profile) : null,
      };
    }

    if (user.VaiTro === 'Freelancer') {
      const profile = await this.prisma.freelancer.findFirst({
        where: { TaiKhoanID: user.TaiKhoanID },
        select: {
          FreelancerID: true,
          KinhNghiem: true,
          ChuyenGia: true,
          KyNang: true,
          XepHang: true,
          SoDu: true,
          XacThucEmail: true,
          XacThucSDT: true,
          TongCongViec: true,
          TyLeHoanThanh: true,
        },
      });

      return {
        role: 'Freelancer',
        freelancer: profile ? this.toFreelancerProfileDto(profile) : null,
      };
    }

    if (user.VaiTro === 'DonViGiamSat') {
      const profile = await this.prisma.donViGiamSat.findFirst({
        where: { TaiKhoanID: user.TaiKhoanID },
        select: {
          GiamSatID: true,
          TenDonVi: true,
          MoTa: true,
          NangLuc: true,
          ChungChi: true,
          PhiGiamSat: true,
          XepHang: true,
          TongCongViecGS: true,
          TrangThai: true,
          NgayDangKy: true,
        },
      });

      return {
        role: 'DonViGiamSat',
        donViGiamSat: profile ? this.toDonViGiamSatProfileDto(profile) : null,
      };
    }

    return {
      role: user.VaiTro,
      data: null,
    };
  }

  private toUserDto(user: UserEntity): UserDto {
    return {
      taiKhoanId: user.TaiKhoanID,
      tenDangNhap: user.TenDangNhap,
      email: user.Email,
      hoTen: user.HoTen,
      soDienThoai: user.SoDienThoai,
      gioiTinh: user.GioiTinh,
      diaChi: user.DiaChi,
      vaiTro: user.VaiTro,
      trangThai: user.TrangThai,
      ngayTao: user.NgayTao.toISOString(),
      ngayCapNhat: user.NgayCapNhat.toISOString(),
    };
  }

  private toNguoiThueProfileDto(profile: {
    NguoiThueID: number;
    CongTy: string | null;
    MoTa: string | null;
    DiemTinCay: { toString(): string };
    TongYeuCau: number;
    TyLeHoanThanh: { toString(): string };
  }): NguoiThueProfileDto {
    return {
      nguoiThueId: profile.NguoiThueID,
      congTy: profile.CongTy,
      moTa: profile.MoTa,
      diemTinCay: profile.DiemTinCay.toString(),
      tongYeuCau: profile.TongYeuCau,
      tyLeHoanThanh: profile.TyLeHoanThanh.toString(),
    };
  }

  private toFreelancerProfileDto(profile: {
    FreelancerID: number;
    KinhNghiem: number;
    ChuyenGia: string | null;
    KyNang: string | null;
    XepHang: { toString(): string };
    SoDu: { toString(): string };
    XacThucEmail: boolean;
    XacThucSDT: boolean;
    TongCongViec: number;
    TyLeHoanThanh: { toString(): string };
  }): FreelancerProfileDto {
    return {
      freelancerId: profile.FreelancerID,
      kinhNghiem: profile.KinhNghiem,
      chuyenGia: profile.ChuyenGia,
      kyNang: profile.KyNang,
      xepHang: profile.XepHang.toString(),
      soDu: profile.SoDu.toString(),
      xacThucEmail: profile.XacThucEmail,
      xacThucSDT: profile.XacThucSDT,
      tongCongViec: profile.TongCongViec,
      tyLeHoanThanh: profile.TyLeHoanThanh.toString(),
    };
  }

  private toDonViGiamSatProfileDto(profile: {
    GiamSatID: number;
    TenDonVi: string;
    MoTa: string | null;
    NangLuc: string | null;
    ChungChi: string | null;
    PhiGiamSat: { toString(): string };
    XepHang: { toString(): string };
    TongCongViecGS: number;
    TrangThai: 'HoatDong' | 'TamNghi' | 'BiKhoa' | 'ChoDuyet';
    NgayDangKy: Date;
  }): DonViGiamSatProfileDto {
    return {
      giamSatId: profile.GiamSatID,
      tenDonVi: profile.TenDonVi,
      moTa: profile.MoTa,
      nangLuc: profile.NangLuc,
      chungChi: profile.ChungChi,
      phiGiamSat: profile.PhiGiamSat.toString(),
      xepHang: profile.XepHang.toString(),
      tongCongViecGS: profile.TongCongViecGS,
      trangThai: profile.TrangThai,
      ngayDangKy: profile.NgayDangKy.toISOString(),
    };
  }

  private requireText(value: string | undefined, fieldName: string): string {
    const trimmed = value?.trim();

    if (!trimmed) {
      throw new BadRequestException(`${fieldName} is required`);
    }

    return trimmed;
  }

  private cleanOptionalText(value: string | undefined): string | null {
    const trimmed = value?.trim();
    return trimmed ? trimmed : null;
  }

  private ensureValidGioiTinh(gioiTinh: unknown): void {
    if (
      typeof gioiTinh !== 'string' ||
      !GIOI_TINH_VALUES.includes(gioiTinh as GioiTinhValue)
    ) {
      throw new BadRequestException('GioiTinh khong hop le');
    }
  }

  private ensureValidTrangThai(trangThai: unknown): void {
    if (
      typeof trangThai !== 'string' ||
      !TRANG_THAI_VALUES.includes(trangThai as TrangThaiValue)
    ) {
      throw new BadRequestException('TrangThai khong hop le');
    }
  }
}
