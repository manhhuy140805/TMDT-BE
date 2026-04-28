import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../../common/prisma/prisma.service';
import type { Prisma } from '@prisma/client';
import type {
  CreateDisputeDto,
  DisputeDto,
  DisputeListResponseDto,
  DisputeMutationResponseDto,
  DisputeResponseDto,
  ResolveDisputeDto,
  ReviewDisputeDto,
} from './dto';

const DISPUTE_SELECT = {
  TranhChapID: true,
  CongViecID: true,
  NguoiGuiID: true,
  GiamSatID: true,
  LyDo: true,
  MoTa: true,
  TrangThai: true,
  YeuCauHoanTien: true,
  NgayMo: true,
  NgayDong: true,
} as const;

type DisputeEntity = Prisma.TranhChapGetPayload<{
  select: typeof DISPUTE_SELECT;
}>;

@Injectable()
export class DisputesService {
  constructor(private readonly prisma: PrismaService) {}

  async findById(id: number): Promise<DisputeResponseDto> {
    const dispute = await this.prisma.tranhChap.findUnique({
      where: { TranhChapID: id },
      select: DISPUTE_SELECT,
    });

    if (!dispute) {
      throw new NotFoundException('Tranh chap khong ton tai');
    }

    return { dispute: this.toDisputeDto(dispute) };
  }

  async findByContractId(contractId: number): Promise<DisputeListResponseDto> {
    const disputes = await this.prisma.tranhChap.findMany({
      where: { CongViecID: contractId },
      select: DISPUTE_SELECT,
      orderBy: { NgayMo: 'desc' },
    });

    return {
      total: disputes.length,
      disputes: disputes.map((d) => this.toDisputeDto(d)),
    };
  }

  async create(
    payload: CreateDisputeDto,
  ): Promise<DisputeMutationResponseDto> {
    const contract = await this.prisma.congViec.findUnique({
      where: { CongViecID: payload.congViecId },
    });

    if (!contract) {
      throw new NotFoundException('Hop dong khong ton tai');
    }

    // Determine if the sender is part of this contract
    const isFreelancer = contract.FreelancerID === payload.nguoiGuiId;
    const isNguoiThue = contract.NguoiThueID === payload.nguoiGuiId;

    // Check account existence for sender ID
    const nguoiGui = await this.prisma.taiKhoan.findUnique({
      where: { TaiKhoanID: payload.nguoiGuiId },
    });

    if (!nguoiGui) {
      throw new BadRequestException('Nguoi gui khong ton tai');
    }

    // Create the dispute
    const dispute = await this.prisma.tranhChap.create({
      data: {
        CongViecID: payload.congViecId,
        NguoiGuiID: payload.nguoiGuiId,
        LyDo: payload.lyDo,
        MoTa: payload.moTa,
        YeuCauHoanTien: payload.yeuCauHoanTien,
        TrangThai: 'MoiMo',
      },
      select: DISPUTE_SELECT,
    });

    // Update contract status to TranhChap
    await this.prisma.congViec.update({
      where: { CongViecID: payload.congViecId },
      data: {
        TrangThai: 'TranhChap',
      },
    });

    return {
      message: 'Mo tranh chap thanh cong',
      dispute: this.toDisputeDto(dispute),
    };
  }

  async review(
    id: number,
    payload: ReviewDisputeDto,
  ): Promise<DisputeMutationResponseDto> {
    const dispute = await this.prisma.tranhChap.findUnique({
      where: { TranhChapID: id },
    });

    if (!dispute) {
      throw new NotFoundException('Tranh chap khong ton tai');
    }

    if (dispute.TrangThai !== 'MoiMo') {
      throw new BadRequestException('Khong the xu ly tranh chap o trang thai hien tai');
    }

    // Verify supervisor
    const supervisor = await this.prisma.donViGiamSat.findUnique({
      where: { GiamSatID: payload.giamSatId },
    });

    if (!supervisor) {
      throw new BadRequestException('Don vi giam sat khong ton tai');
    }

    const updatedDispute = await this.prisma.tranhChap.update({
      where: { TranhChapID: id },
      data: {
        TrangThai: 'DangXuLy',
        GiamSatID: payload.giamSatId,
      },
      select: DISPUTE_SELECT,
    });

    return {
      message: 'Bat dau xu ly tranh chap',
      dispute: this.toDisputeDto(updatedDispute),
    };
  }

  async resolve(
    id: number,
    payload: ResolveDisputeDto,
  ): Promise<DisputeMutationResponseDto> {
    const dispute = await this.prisma.tranhChap.findUnique({
      where: { TranhChapID: id },
    });

    if (!dispute) {
      throw new NotFoundException('Tranh chap khong ton tai');
    }

    if (dispute.TrangThai !== 'DangXuLy') {
      throw new BadRequestException('Tranh chap chua duoc xu ly hoac da ket luan');
    }

    if (dispute.GiamSatID !== payload.giamSatId) {
      throw new BadRequestException('Chi don vi giam sat dang xu ly moi duoc ket luan');
    }

    // 1. Create conclusion record
    await this.prisma.ketLuanTranhChap.create({
      data: {
        TranhChapID: id,
        GiamSatID: payload.giamSatId,
        KetQua: payload.ketQua,
        LyDo: payload.lyDo,
        SoTienHoan: payload.soTienHoan,
        BenChiuPhi: payload.benChiuPhi,
      },
    });

    // 2. Update dispute status
    const updatedDispute = await this.prisma.tranhChap.update({
      where: { TranhChapID: id },
      data: {
        TrangThai: 'DaKetLuan',
        NgayDong: new Date(),
      },
      select: DISPUTE_SELECT,
    });

    // Note: Depending on the 'ketQua', further actions like calling PaymentService 
    // to refund or continue might be needed here. 
    // For now, we are just saving the conclusion to keep concerns separated.

    return {
      message: 'Ket luan tranh chap thanh cong',
      dispute: this.toDisputeDto(updatedDispute),
    };
  }

  private toDisputeDto(dispute: DisputeEntity): DisputeDto {
    return {
      tranhChapId: dispute.TranhChapID,
      congViecId: dispute.CongViecID,
      nguoiGuiId: dispute.NguoiGuiID,
      giamSatId: dispute.GiamSatID,
      lyDo: dispute.LyDo,
      moTa: dispute.MoTa,
      trangThai: dispute.TrangThai,
      yeuCauHoanTien: dispute.YeuCauHoanTien.toString(),
      ngayMo: dispute.NgayMo.toISOString(),
      ngayDong: dispute.NgayDong ? dispute.NgayDong.toISOString() : null,
    };
  }
}
