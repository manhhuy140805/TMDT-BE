import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import type { Prisma, TrangThaiCongViec } from '@prisma/client';
import { PrismaService } from '../../common/prisma/prisma.service';
import type {
  ContractMutationResponseDto,
  ContractResponseDto,
  ContractsListResponseDto,
  ContractWithDetailsDto,
  CreateContractDto,
  UpdateContractStatusDto,
} from './dto/contract.dto';

const CONTRACT_SELECT = {
  CongViecID: true,
  YeuCauID: true,
  FreelancerID: true,
  NguoiThueID: true,
  GiaThoa: true,
  ThoiGianThoa: true,
  TrangThai: true,
  NgayBatDau: true,
  NgayKetThuc: true,
  GiamSatID: true,
  TrangThaiGiamSat: true,
  PhiGiamSat: true,
  NgayTao: true,
  YeuCau: {
    select: {
      YeuCauID: true,
      TieuDe: true,
      MoTa: true,
    },
  },
  Freelancer: {
    select: {
      TaiKhoanID: true,
      HoTen: true,
      Email: true,
    },
  },
  NguoiThue: {
    select: {
      TaiKhoanID: true,
      HoTen: true,
      Email: true,
    },
  },
  GiamSat: {
    select: {
      TaiKhoanID: true,
      HoTen: true,
      Email: true,
      DonViGiamSat: {
        select: {
          GiamSatID: true,
          TenDonVi: true,
        },
      },
    },
  },
} as const;

type ContractEntity = Prisma.CongViecGetPayload<{
  select: typeof CONTRACT_SELECT;
}>;

const TRANG_THAI_VALUES: readonly TrangThaiCongViec[] = [
  'MoiTao',
  'DangThucHien',
  'HoanThanh',
  'DaHuy',
];

@Injectable()
export class ContractsService {
  constructor(private readonly prisma: PrismaService) {}

  async findAll(): Promise<ContractsListResponseDto> {
    const contracts = await this.prisma.congViec.findMany({
      select: CONTRACT_SELECT,
      orderBy: {
        NgayTao: 'desc',
      },
    });

    return {
      total: contracts.length,
      contracts: contracts.map((c) => this.toContractWithDetailsDto(c)),
    };
  }

  async findOne(id: number): Promise<ContractResponseDto> {
    const contract = await this.findContractOrThrow(id);

    return { contract: this.toContractWithDetailsDto(contract) };
  }

  async findByUserId(userId: number): Promise<ContractsListResponseDto> {
    // Since FreelancerID and NguoiThueID now reference TaiKhoan directly
    const contracts = await this.prisma.congViec.findMany({
      where: {
        OR: [
          { NguoiThueID: userId },
          { FreelancerID: userId },
          { GiamSatID: userId },
        ],
      },
      select: CONTRACT_SELECT,
      orderBy: {
        NgayTao: 'desc',
      },
    });

    if (contracts.length === 0) {
      // Verify user exists
      const user = await this.prisma.taiKhoan.findUnique({
        where: { TaiKhoanID: userId },
        select: { TaiKhoanID: true },
      });

      if (!user) {
        throw new NotFoundException('Nguoi dung khong ton tai');
      }
    }

    return {
      total: contracts.length,
      contracts: contracts.map((c) => this.toContractWithDetailsDto(c)),
    };
  }

  create(_payload: CreateContractDto): Promise<ContractMutationResponseDto> {
    void _payload;
    return Promise.reject(
      new BadRequestException(
        'Cong viec chi duoc tao khi chot freelancer qua /contracts/accept-proposal',
      ),
    );
  }

  async updateStatus(
    id: number,
    payload: UpdateContractStatusDto,
  ): Promise<ContractMutationResponseDto> {
    try {
      await this.findContractOrThrow(id);

      this.ensureValidTrangThai(payload.trangThai);

      if (payload.trangThai !== 'HoanThanh' && payload.trangThai !== 'DaHuy') {
        const dispute = await this.prisma.tranhChap.findFirst({
          where: { CongViecID: id },
          select: { TranhChapID: true },
        });

        if (dispute) {
          throw new BadRequestException(
            'Cong viec da co tranh chap ket qua phai giu trang thai hoan thanh hoac huy',
          );
        }
      }

      const data: Prisma.CongViecUpdateInput = {
        TrangThai: payload.trangThai,
      };

      // Set NgayBatDau when status changes to DangThucHien
      if (payload.trangThai === 'DangThucHien') {
        data.NgayBatDau = new Date();
      }

      // Set NgayKetThuc when status changes to HoanThanh or DaHuy
      if (payload.trangThai === 'HoanThanh' || payload.trangThai === 'DaHuy') {
        data.NgayKetThuc = new Date();
      }

      const contract = await this.prisma.congViec.update({
        where: { CongViecID: id },
        data,
        select: CONTRACT_SELECT,
      });

      return {
        message: 'Cap nhat trang thai hop dong thanh cong',
        contract: this.toContractWithDetailsDto(contract),
      };
    } catch (error) {
      console.error('[updateStatus Error]', error);
      throw error;
    }
  }

  async getDetail(id: number): Promise<ContractResponseDto> {
    // Same as findOne but can be extended with more details later
    return this.findOne(id);
  }

  private async findContractOrThrow(id: number): Promise<ContractEntity> {
    const contract = await this.prisma.congViec.findUnique({
      where: { CongViecID: id },
      select: CONTRACT_SELECT,
    });

    if (!contract) {
      throw new NotFoundException('Hop dong khong ton tai');
    }

    return contract;
  }

  private async validateYeuCau(yeuCauId: number): Promise<void> {
    const yeuCau = await this.prisma.yeuCau.findUnique({
      where: { YeuCauID: yeuCauId },
      select: { YeuCauID: true },
    });

    if (!yeuCau) {
      throw new BadRequestException('Yeu cau khong ton tai');
    }
  }

  private async validateFreelancer(freelancerId: number): Promise<void> {
    const taiKhoan = await this.prisma.taiKhoan.findUnique({
      where: { TaiKhoanID: freelancerId },
      select: { TaiKhoanID: true },
    });

    if (!taiKhoan) {
      throw new BadRequestException('Freelancer khong ton tai');
    }
  }

  private async validateNguoiThue(nguoiThueId: number): Promise<void> {
    const taiKhoan = await this.prisma.taiKhoan.findUnique({
      where: { TaiKhoanID: nguoiThueId },
      select: { TaiKhoanID: true },
    });

    if (!taiKhoan) {
      throw new BadRequestException('Nguoi thue khong ton tai');
    }
  }

  private toContractWithDetailsDto(
    contract: ContractEntity,
  ): ContractWithDetailsDto {
    // Nếu chưa assign giám sát, cho phép update status
    if (!contract.GiamSat) {
      return {
        congViecId: contract.CongViecID,
        yeuCauId: contract.YeuCauID,
        freelancerId: contract.FreelancerID,
        nguoiThueId: contract.NguoiThueID,
        giaThoa: contract.GiaThoa.toString(),
        thoiGianThoa: contract.ThoiGianThoa,
        trangThai: contract.TrangThai,
        ngayBatDau: contract.NgayBatDau
          ? contract.NgayBatDau.toISOString()
          : null,
        ngayKetThuc: contract.NgayKetThuc
          ? contract.NgayKetThuc.toISOString()
          : null,
        giamSatId: contract.GiamSatID || null,
        trangThaiGiamSat: contract.TrangThaiGiamSat || null,
        phiGiamSat: contract.PhiGiamSat?.toString() || '0',
        ngayTao: contract.NgayTao.toISOString(),
        yeuCau: {
          yeuCauId: contract.YeuCau.YeuCauID,
          tieuDe: contract.YeuCau.TieuDe,
          moTa: contract.YeuCau.MoTa,
        },
        freelancer: {
          freelancerId: contract.FreelancerID,
          taiKhoanId: contract.Freelancer.TaiKhoanID,
          hoTen: contract.Freelancer.HoTen,
          email: contract.Freelancer.Email,
        },
        nguoiThue: {
          nguoiThueId: contract.NguoiThueID,
          taiKhoanId: contract.NguoiThue.TaiKhoanID,
          hoTen: contract.NguoiThue.HoTen,
          email: contract.NguoiThue.Email,
        },
        giamSat: null,
      } as ContractWithDetailsDto;
    }

    if (!contract.GiamSat.DonViGiamSat) {
      throw new BadRequestException('Giam sat chua co don vi');
    }

    return {
      congViecId: contract.CongViecID,
      yeuCauId: contract.YeuCauID,
      freelancerId: contract.FreelancerID,
      nguoiThueId: contract.NguoiThueID,
      giaThoa: contract.GiaThoa.toString(),
      thoiGianThoa: contract.ThoiGianThoa,
      trangThai: contract.TrangThai,
      ngayBatDau: contract.NgayBatDau
        ? contract.NgayBatDau.toISOString()
        : null,
      ngayKetThuc: contract.NgayKetThuc
        ? contract.NgayKetThuc.toISOString()
        : null,
      giamSatId: contract.GiamSatID!,
      trangThaiGiamSat: contract.TrangThaiGiamSat,
      phiGiamSat: contract.PhiGiamSat.toString(),
      ngayTao: contract.NgayTao.toISOString(),
      yeuCau: {
        yeuCauId: contract.YeuCau.YeuCauID,
        tieuDe: contract.YeuCau.TieuDe,
        moTa: contract.YeuCau.MoTa,
      },
      freelancer: {
        freelancerId: contract.FreelancerID,
        taiKhoanId: contract.Freelancer.TaiKhoanID,
        hoTen: contract.Freelancer.HoTen,
        email: contract.Freelancer.Email,
      },
      nguoiThue: {
        nguoiThueId: contract.NguoiThueID,
        taiKhoanId: contract.NguoiThue.TaiKhoanID,
        hoTen: contract.NguoiThue.HoTen,
        email: contract.NguoiThue.Email,
      },
      giamSat: {
        giamSatId: contract.GiamSat.TaiKhoanID,
        tenDonVi: contract.GiamSat.DonViGiamSat.TenDonVi,
        email: contract.GiamSat.Email,
      },
    };
  }

  private ensureValidTrangThai(trangThai: unknown): void {
    if (
      typeof trangThai !== 'string' ||
      !TRANG_THAI_VALUES.includes(trangThai as TrangThaiCongViec)
    ) {
      throw new BadRequestException('TrangThai khong hop le');
    }
  }
}
