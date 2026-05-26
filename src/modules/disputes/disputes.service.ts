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

    if (contract.TrangThai !== 'HoanThanh') {
      throw new BadRequestException(
        'Chi co the tranh chap sau khi cong viec da hoan thanh',
      );
    }

    if (contract.NguoiThueID !== payload.nguoiGuiId) {
      throw new BadRequestException(
        'Chi khach hang moi co the mo tranh chap ve ket qua cong viec',
      );
    }

    const activeDispute = await this.prisma.tranhChap.findFirst({
      where: {
        CongViecID: payload.congViecId,
        TrangThai: { in: ['MoiMo', 'DangXuLy'] },
      },
      select: { TranhChapID: true },
    });

    if (activeDispute) {
      throw new BadRequestException('Cong viec dang co tranh chap can xu ly');
    }

    const lyDo = payload.lyDo?.trim();
    if (!lyDo) {
      throw new BadRequestException('Ly do tranh chap la bat buoc');
    }

    if (payload.yeuCauHoanTien < 0) {
      throw new BadRequestException(
        'Yeu cau hoan tien phai lon hon hoac bang 0',
      );
    }

    const dispute = await this.prisma.tranhChap.create({
      data: {
        CongViecID: payload.congViecId,
        NguoiGuiID: payload.nguoiGuiId,
        GiamSatID: contract.GiamSatID,
        LyDo: lyDo,
        MoTa: payload.moTa?.trim() || null,
        YeuCauHoanTien: payload.yeuCauHoanTien,
        TrangThai: 'MoiMo',
      },
      select: DISPUTE_SELECT,
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

    if (dispute.GiamSatID !== payload.giamSatId) {
      throw new BadRequestException(
        'Chi don vi giam sat cua cong viec moi duoc xu ly tranh chap',
      );
    }

    const supervisor = await this.prisma.donViGiamSat.findFirst({
      where: { TaiKhoanID: payload.giamSatId, TrangThai: 'HoatDong' },
    });

    if (!supervisor) {
      throw new BadRequestException('Don vi giam sat khong hoat dong');
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
      giamSatId: dispute.GiamSatID!,
      lyDo: dispute.LyDo,
      moTa: dispute.MoTa,
      trangThai: dispute.TrangThai,
      yeuCauHoanTien: dispute.YeuCauHoanTien.toString(),
      ngayMo: dispute.NgayMo.toISOString(),
      ngayDong: dispute.NgayDong ? dispute.NgayDong.toISOString() : null,
    };
  }
}
