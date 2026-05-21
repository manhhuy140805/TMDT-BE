import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../../common/prisma/prisma.service';
import type { Prisma } from '@prisma/client';
import type {
  CreateEvidenceDto,
  EvidenceDto,
  EvidenceListResponseDto,
  EvidenceMutationResponseDto,
} from './dto';

const EVIDENCE_SELECT = {
  BangChungID: true,
  TranhChapID: true,
  NguoiNopID: true,
  LoaiBangChung: true,
  NoiDung: true,
  DuongDanFile: true,
  NgayNop: true,
} as const;

type EvidenceEntity = Prisma.BangChungTranhChapGetPayload<{
  select: typeof EVIDENCE_SELECT;
}>;

@Injectable()
export class EvidencesService {
  constructor(private readonly prisma: PrismaService) {}

  async findByDisputeId(disputeId: number): Promise<EvidenceListResponseDto> {
    const dispute = await this.prisma.tranhChap.findUnique({
      where: { TranhChapID: disputeId },
    });

    if (!dispute) {
      throw new NotFoundException('Tranh chap khong ton tai');
    }

    const evidences = await this.prisma.bangChungTranhChap.findMany({
      where: { TranhChapID: disputeId },
      select: EVIDENCE_SELECT,
      orderBy: { NgayNop: 'desc' },
    });

    return {
      total: evidences.length,
      evidences: evidences.map((e) => this.toEvidenceDto(e)),
    };
  }

  async create(
    disputeId: number,
    payload: CreateEvidenceDto,
  ): Promise<EvidenceMutationResponseDto> {
    const dispute = await this.prisma.tranhChap.findUnique({
      where: { TranhChapID: disputeId },
    });

    if (!dispute) {
      throw new NotFoundException('Tranh chap khong ton tai');
    }

    // Check account existence for sender ID
    const nguoiNop = await this.prisma.taiKhoan.findUnique({
      where: { TaiKhoanID: payload.nguoiNopId },
    });

    if (!nguoiNop) {
      throw new BadRequestException('Nguoi nop khong ton tai');
    }

    const evidence = await this.prisma.bangChungTranhChap.create({
      data: {
        TranhChapID: disputeId,
        NguoiNopID: payload.nguoiNopId,
        LoaiBangChung: payload.loaiBangChung,
        NoiDung: payload.noiDung,
        DuongDanFile: payload.duongDanFile,
      },
      select: EVIDENCE_SELECT,
    });

    return {
      message: 'Nop bang chung thanh cong',
      evidence: this.toEvidenceDto(evidence),
    };
  }

  async delete(id: number): Promise<EvidenceMutationResponseDto> {
    const evidence = await this.prisma.bangChungTranhChap.findUnique({
      where: { BangChungID: id },
    });

    if (!evidence) {
      throw new NotFoundException('Bang chung khong ton tai');
    }

    await this.prisma.bangChungTranhChap.delete({
      where: { BangChungID: id },
    });

    return {
      message: 'Xoa bang chung thanh cong',
      evidence: null,
    };
  }

  private toEvidenceDto(evidence: EvidenceEntity): EvidenceDto {
    return {
      bangChungId: evidence.BangChungID,
      tranhChapId: evidence.TranhChapID,
      nguoiNopId: evidence.NguoiNopID,
      loaiBangChung: evidence.LoaiBangChung,
      noiDung: evidence.NoiDung,
      duongDanFile: evidence.DuongDanFile,
      ngayNop: evidence.NgayNop.toISOString(),
    };
  }
}
