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
  SelectSupervisorDto,
  SupervisorResponseDto,
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
      FreelancerID: true,
      TaiKhoan: {
        select: {
          TaiKhoanID: true,
          HoTen: true,
          Email: true,
        },
      },
    },
  },
  NguoiThue: {
    select: {
      NguoiThueID: true,
      TaiKhoan: {
        select: {
          TaiKhoanID: true,
          HoTen: true,
          Email: true,
        },
      },
    },
  },
  GiamSat: {
    select: {
      GiamSatID: true,
      TenDonVi: true,
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
  'TranhChap',
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
    // Check if user is NguoiThue
    const nguoiThue = await this.prisma.nguoiThue.findFirst({
      where: { TaiKhoanID: userId },
      select: { NguoiThueID: true },
    });

    if (nguoiThue) {
      const contracts = await this.prisma.congViec.findMany({
        where: { NguoiThueID: nguoiThue.NguoiThueID },
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

    // Check if user is Freelancer
    const freelancer = await this.prisma.freelancer.findFirst({
      where: { TaiKhoanID: userId },
      select: { FreelancerID: true },
    });

    if (freelancer) {
      const contracts = await this.prisma.congViec.findMany({
        where: { FreelancerID: freelancer.FreelancerID },
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

    throw new NotFoundException('Nguoi dung khong ton tai');
  }

  async create(
    payload: CreateContractDto,
  ): Promise<ContractMutationResponseDto> {
    await this.validateYeuCau(payload.yeuCauId);
    await this.validateFreelancer(payload.freelancerId);
    await this.validateNguoiThue(payload.nguoiThueId);

    if (payload.giaThoa <= 0) {
      throw new BadRequestException('Gia thoa phai lon hon 0');
    }

    if (payload.thoiGianThoa <= 0) {
      throw new BadRequestException('Thoi gian thoa phai lon hon 0');
    }

    const contract = await this.prisma.congViec.create({
      data: {
        YeuCauID: payload.yeuCauId,
        FreelancerID: payload.freelancerId,
        NguoiThueID: payload.nguoiThueId,
        GiaThoa: payload.giaThoa,
        ThoiGianThoa: payload.thoiGianThoa,
        TrangThai: 'MoiTao',
      },
      select: CONTRACT_SELECT,
    });

    return {
      message: 'Tao hop dong thanh cong',
      contract: this.toContractWithDetailsDto(contract),
    };
  }

  async updateStatus(
    id: number,
    payload: UpdateContractStatusDto,
  ): Promise<ContractMutationResponseDto> {
    await this.findContractOrThrow(id);

    this.ensureValidTrangThai(payload.trangThai);

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
    const freelancer = await this.prisma.freelancer.findUnique({
      where: { FreelancerID: freelancerId },
      select: { FreelancerID: true },
    });

    if (!freelancer) {
      throw new BadRequestException('Freelancer khong ton tai');
    }
  }

  private async validateNguoiThue(nguoiThueId: number): Promise<void> {
    const nguoiThue = await this.prisma.nguoiThue.findUnique({
      where: { NguoiThueID: nguoiThueId },
      select: { NguoiThueID: true },
    });

    if (!nguoiThue) {
      throw new BadRequestException('Nguoi thue khong ton tai');
    }
  }

  private toContractWithDetailsDto(
    contract: ContractEntity,
  ): ContractWithDetailsDto {
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
      giamSatId: contract.GiamSatID,
      trangThaiGiamSat: contract.TrangThaiGiamSat,
      phiGiamSat: contract.PhiGiamSat.toString(),
      ngayTao: contract.NgayTao.toISOString(),
      yeuCau: {
        yeuCauId: contract.YeuCau.YeuCauID,
        tieuDe: contract.YeuCau.TieuDe,
        moTa: contract.YeuCau.MoTa,
      },
      freelancer: {
        freelancerId: contract.Freelancer.FreelancerID,
        taiKhoanId: contract.Freelancer.TaiKhoan.TaiKhoanID,
        hoTen: contract.Freelancer.TaiKhoan.HoTen,
        email: contract.Freelancer.TaiKhoan.Email,
      },
      nguoiThue: {
        nguoiThueId: contract.NguoiThue.NguoiThueID,
        taiKhoanId: contract.NguoiThue.TaiKhoan.TaiKhoanID,
        hoTen: contract.NguoiThue.TaiKhoan.HoTen,
        email: contract.NguoiThue.TaiKhoan.Email,
      },
      giamSat: contract.GiamSat
        ? {
            giamSatId: contract.GiamSat.GiamSatID,
            tenDonVi: contract.GiamSat.TenDonVi,
          }
        : null,
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

  async selectSupervisor(
    id: number,
    payload: SelectSupervisorDto,
  ): Promise<SupervisorResponseDto> {
    const contract = await this.findContractOrThrow(id);

    // Validate supervisor exists
    const supervisor = await this.prisma.donViGiamSat.findUnique({
      where: { GiamSatID: payload.giamSatId },
      select: { GiamSatID: true, TrangThai: true },
    });

    if (!supervisor) {
      throw new BadRequestException('Don vi giam sat khong ton tai');
    }

    if (supervisor.TrangThai !== 'HoatDong') {
      throw new BadRequestException('Don vi giam sat khong hoat dong');
    }

    if (payload.phiGiamSat < 0) {
      throw new BadRequestException('Phi giam sat phai lon hon hoac bang 0');
    }

    // Get freelancer from contract
    const freelancer = await this.prisma.freelancer.findUnique({
      where: { FreelancerID: contract.FreelancerID },
      select: { FreelancerID: true },
    });

    if (!freelancer) {
      throw new BadRequestException('Freelancer khong ton tai');
    }

    // Create YeuCauGiamSat record
    const yeuCauGiamSat = await this.prisma.yeuCauGiamSat.create({
      data: {
        CongViecID: id,
        NguoiThueID: contract.NguoiThueID,
        GiamSatID: payload.giamSatId,
        FreelancerID: contract.FreelancerID,
        PhiGiamSatThoa: payload.phiGiamSat,
        TrangThai: 'ChoDuyet',
      },
    });

    // Update contract with supervisor info
    await this.prisma.congViec.update({
      where: { CongViecID: id },
      data: {
        GiamSatID: payload.giamSatId,
        PhiGiamSat: payload.phiGiamSat,
        TrangThaiGiamSat: 'ChoDuyet',
      },
    });

    return {
      message: 'Chon don vi giam sat thanh cong',
      yeuCauGiamSatId: yeuCauGiamSat.YCGiamSatID,
      trangThai: yeuCauGiamSat.TrangThai,
    };
  }

  async acceptSupervisor(id: number): Promise<SupervisorResponseDto> {
    const contract = await this.findContractOrThrow(id);

    if (!contract.GiamSatID) {
      throw new BadRequestException('Hop dong chua co don vi giam sat');
    }

    // Find pending YeuCauGiamSat
    const yeuCauGiamSat = await this.prisma.yeuCauGiamSat.findFirst({
      where: {
        CongViecID: id,
        TrangThai: 'ChoDuyet',
      },
    });

    if (!yeuCauGiamSat) {
      throw new NotFoundException('Khong tim thay yeu cau giam sat cho duyet');
    }

    // Update YeuCauGiamSat status
    const updated = await this.prisma.yeuCauGiamSat.update({
      where: { YCGiamSatID: yeuCauGiamSat.YCGiamSatID },
      data: {
        TrangThai: 'DaChapNhan',
        NgayChapNhan: new Date(),
      },
    });

    // Update contract supervision status
    await this.prisma.congViec.update({
      where: { CongViecID: id },
      data: {
        TrangThaiGiamSat: 'DangGiamSat',
      },
    });

    return {
      message: 'Chap nhan don vi giam sat thanh cong',
      yeuCauGiamSatId: updated.YCGiamSatID,
      trangThai: updated.TrangThai,
    };
  }

  async rejectSupervisor(id: number): Promise<SupervisorResponseDto> {
    const contract = await this.findContractOrThrow(id);

    if (!contract.GiamSatID) {
      throw new BadRequestException('Hop dong chua co don vi giam sat');
    }

    // Find pending YeuCauGiamSat
    const yeuCauGiamSat = await this.prisma.yeuCauGiamSat.findFirst({
      where: {
        CongViecID: id,
        TrangThai: 'ChoDuyet',
      },
    });

    if (!yeuCauGiamSat) {
      throw new NotFoundException('Khong tim thay yeu cau giam sat cho duyet');
    }

    // Update YeuCauGiamSat status
    const updated = await this.prisma.yeuCauGiamSat.update({
      where: { YCGiamSatID: yeuCauGiamSat.YCGiamSatID },
      data: {
        TrangThai: 'TuChoi',
        LyDoTuChoi: 'Freelancer tu choi',
      },
    });

    // Update contract - remove supervisor
    await this.prisma.congViec.update({
      where: { CongViecID: id },
      data: {
        GiamSatID: null,
        PhiGiamSat: 0,
        TrangThaiGiamSat: 'KhongCo',
      },
    });

    return {
      message: 'Tu choi don vi giam sat thanh cong',
      yeuCauGiamSatId: updated.YCGiamSatID,
      trangThai: updated.TrangThai,
    };
  }
}
