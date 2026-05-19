import {
  BadRequestException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { PrismaService } from '../../common/prisma/prisma.service';
import type {
  AuthLoginDto,
  AuthRegisterDto,
  AuthResponseDto,
  AuthUserDto,
} from './dto';

type GioiTinhValue = 'Nam' | 'Nu' | 'Khac';
type VaiTroValue =
  | 'KhachVangLai'
  | 'NguoiThue'
  | 'Freelancer'
  | 'DonViGiamSat'
  | 'Admin';
type TrangThaiValue = 'HoatDong' | 'BiKhoa' | 'ChoDuyet' | 'DaBi';

type TaiKhoanRecord = {
  TaiKhoanID: number;
  TenDangNhap: string;
  MatKhau: string;
  Email: string;
  HoTen: string;
  SoDienThoai: string | null;
  GioiTinh: GioiTinhValue | null;
  DiaChi: string | null;
  VaiTro: VaiTroValue;
  TrangThai: TrangThaiValue;
  NgayTao: Date;
};

const GIOI_TINH_VALUES: readonly GioiTinhValue[] = ['Nam', 'Nu', 'Khac'];
const VAI_TRO_NGUOI_THUE: VaiTroValue = 'NguoiThue';
const VAI_TRO_FREELANCER: VaiTroValue = 'Freelancer';
const VAI_TRO_DON_VI_GIAM_SAT: VaiTroValue = 'DonViGiamSat';
const TRANG_THAI_HOAT_DONG: TrangThaiValue = 'HoatDong';

@Injectable()
export class AuthService {
  constructor(private readonly prisma: PrismaService) {}

  async register(payload: AuthRegisterDto): Promise<AuthResponseDto> {
    const tenDangNhap = this.requireText(payload.tenDangNhap, 'tenDangNhap');
    const matKhau = this.requireText(payload.matKhau, 'matKhau');
    const email = this.requireText(payload.email, 'email').toLowerCase();
    const hoTen = this.requireText(payload.hoTen, 'hoTen');

    this.ensureValidGioiTinh(payload.gioiTinh);

    const vaiTro = payload.vaiTro ?? VAI_TRO_NGUOI_THUE;
    this.ensureValidVaiTro(vaiTro);

    const duplicated = await this.prisma.taiKhoan.findFirst({
      where: {
        OR: [{ TenDangNhap: tenDangNhap }, { Email: email }],
      },
      select: {
        TenDangNhap: true,
        Email: true,
      },
    });

    if (duplicated?.TenDangNhap === tenDangNhap) {
      throw new BadRequestException('Ten dang nhap da ton tai');
    }

    if (duplicated?.Email === email) {
      throw new BadRequestException('Email da ton tai');
    }

    const taiKhoan = await this.prisma.$transaction(async (tx) => {
      const created = await tx.taiKhoan.create({
        data: {
          TenDangNhap: tenDangNhap,
          MatKhau: matKhau,
          Email: email,
          HoTen: hoTen,
          SoDienThoai: this.cleanOptionalText(payload.soDienThoai),
          GioiTinh: payload.gioiTinh,
          DiaChi: this.cleanOptionalText(payload.diaChi),
          VaiTro: vaiTro,
          TrangThai: TRANG_THAI_HOAT_DONG,
        },
      });

      if (vaiTro === VAI_TRO_NGUOI_THUE) {
        await tx.nguoiThue.create({
          data: { TaiKhoanID: created.TaiKhoanID },
        });
      }

      if (vaiTro === VAI_TRO_FREELANCER) {
        await tx.freelancer.create({
          data: { TaiKhoanID: created.TaiKhoanID },
        });
      }

      if (vaiTro === VAI_TRO_DON_VI_GIAM_SAT) {
        await tx.donViGiamSat.create({
          data: {
            TaiKhoanID: created.TaiKhoanID,
            TenDonVi: this.cleanOptionalText(payload.tenDonVi) ?? hoTen,
          },
        });
      }

      return created;
    });

    return {
      message: 'Dang ky thanh cong',
      user: this.toAuthUser(taiKhoan),
    };
  }

  async login(payload: AuthLoginDto): Promise<AuthResponseDto> {
    const email = this.requireText(payload.email, 'email').toLowerCase();
    const matKhau = this.requireText(payload.matKhau, 'matKhau');

    const taiKhoan = await this.prisma.taiKhoan.findUnique({
      where: { Email: email },
    });

    if (!taiKhoan || taiKhoan.MatKhau !== matKhau) {
      throw new UnauthorizedException('Thong tin dang nhap khong chinh xac');
    }

    if (taiKhoan.TrangThai !== TRANG_THAI_HOAT_DONG) {
      throw new UnauthorizedException('Tai khoan khong hoat dong');
    }

    return {
      message: 'Dang nhap thanh cong',
      user: this.toAuthUser(taiKhoan),
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
    if (!gioiTinh) {
      return;
    }

    if (
      typeof gioiTinh !== 'string' ||
      !GIOI_TINH_VALUES.includes(gioiTinh as GioiTinhValue)
    ) {
      throw new BadRequestException('GioiTinh khong hop le');
    }
  }

  private ensureValidVaiTro(vaiTro: VaiTroValue): void {
    const allowedRoles: VaiTroValue[] = [
      VAI_TRO_NGUOI_THUE,
      VAI_TRO_FREELANCER,
      VAI_TRO_DON_VI_GIAM_SAT,
    ];

    if (!allowedRoles.includes(vaiTro)) {
      throw new BadRequestException('VaiTro khong hop le');
    }
  }

  private toAuthUser(taiKhoan: TaiKhoanRecord): AuthUserDto {
    return {
      taiKhoanId: taiKhoan.TaiKhoanID,
      tenDangNhap: taiKhoan.TenDangNhap,
      email: taiKhoan.Email,
      hoTen: taiKhoan.HoTen,
      soDienThoai: taiKhoan.SoDienThoai,
      gioiTinh: taiKhoan.GioiTinh,
      diaChi: taiKhoan.DiaChi,
      vaiTro: taiKhoan.VaiTro,
      trangThai: taiKhoan.TrangThai,
      ngayTao: taiKhoan.NgayTao.toISOString(),
    };
  }
}
