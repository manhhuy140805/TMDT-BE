import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../../common/prisma/prisma.service';
import type { Prisma } from '@prisma/client';
import type {
  CloseConversationResponseDto,
  ConversationDto,
  ConversationListResponseDto,
  ConversationMutationResponseDto,
  ConversationResponseDto,
  CreateConversationDto,
  CreateMessageDto,
  MarkReadResponseDto,
  MemberSummaryDto,
  MessageDto,
  MessageListResponseDto,
  MessageMutationResponseDto,
} from './dto';

const CONVERSATION_SELECT = {
  CuocHoiThoaiID: true,
  CongViecID: true,
  ThanhVien1ID: true,
  ThanhVien2ID: true,
  TinNhanCuoi: true,
  TrangThai: true,
  NgayTao: true,
  ThanhVien1: {
    select: { TaiKhoanID: true, HoTen: true, Email: true },
  },
  ThanhVien2: {
    select: { TaiKhoanID: true, HoTen: true, Email: true },
  },
} as const;

const MESSAGE_SELECT = {
  TinNhanID: true,
  CuocHoiThoaiID: true,
  NguoiGuiID: true,
  NoiDung: true,
  LoaiTin: true,
  DaDoc: true,
  NgayTao: true,
  NguoiGui: {
    select: { TaiKhoanID: true, HoTen: true, Email: true },
  },
} as const;

type ConversationEntity = Prisma.CuocHoiThoaiGetPayload<{
  select: typeof CONVERSATION_SELECT;
}>;

type MessageEntity = Prisma.TinNhanGetPayload<{
  select: typeof MESSAGE_SELECT;
}>;

@Injectable()
export class ChatService {
  constructor(private readonly prisma: PrismaService) {}

  // ── Conversations ──────────────────────────────────────────────────────────

  async findConversationById(id: number): Promise<ConversationResponseDto> {
    const conversation = await this.prisma.cuocHoiThoai.findUnique({
      where: { CuocHoiThoaiID: id },
      select: CONVERSATION_SELECT,
    });

    if (!conversation) {
      throw new NotFoundException('Cuoc hoi thoai khong ton tai');
    }

    return { conversation: this.toConversationDto(conversation) };
  }

  async findConversationsByUserId(
    userId: number,
  ): Promise<ConversationListResponseDto> {
    const conversations = await this.prisma.cuocHoiThoai.findMany({
      where: {
        OR: [{ ThanhVien1ID: userId }, { ThanhVien2ID: userId }],
      },
      select: CONVERSATION_SELECT,
      orderBy: { TinNhanCuoi: { sort: 'desc', nulls: 'last' } },
    });

    return {
      total: conversations.length,
      conversations: conversations.map((c) => this.toConversationDto(c)),
    };
  }

  async findConversationsByContractId(
    contractId: number,
  ): Promise<ConversationListResponseDto> {
    const conversations = await this.prisma.cuocHoiThoai.findMany({
      where: { CongViecID: contractId },
      select: CONVERSATION_SELECT,
      orderBy: { NgayTao: 'desc' },
    });

    return {
      total: conversations.length,
      conversations: conversations.map((c) => this.toConversationDto(c)),
    };
  }

  async createConversation(
    payload: CreateConversationDto,
  ): Promise<ConversationMutationResponseDto> {
    // Validate members exist
    await this.validateUser(payload.thanhVien1Id);
    await this.validateUser(payload.thanhVien2Id);

    if (payload.thanhVien1Id === payload.thanhVien2Id) {
      throw new BadRequestException('Khong the tao hoi thoai voi chinh minh');
    }

    // Check if conversation already exists between these 2 members for same contract
    const existing = await this.prisma.cuocHoiThoai.findFirst({
      where: {
        CongViecID: payload.congViecId || null,
        OR: [
          { ThanhVien1ID: payload.thanhVien1Id, ThanhVien2ID: payload.thanhVien2Id },
          { ThanhVien1ID: payload.thanhVien2Id, ThanhVien2ID: payload.thanhVien1Id },
        ],
      },
      select: CONVERSATION_SELECT,
    });

    if (existing) {
      return {
        message: 'Cuoc hoi thoai da ton tai',
        conversation: this.toConversationDto(existing),
      };
    }

    const conversation = await this.prisma.cuocHoiThoai.create({
      data: {
        CongViecID: payload.congViecId || null,
        ThanhVien1ID: payload.thanhVien1Id,
        ThanhVien2ID: payload.thanhVien2Id,
        TrangThai: 'DangMo',
      },
      select: CONVERSATION_SELECT,
    });

    return {
      message: 'Tao cuoc hoi thoai thanh cong',
      conversation: this.toConversationDto(conversation),
    };
  }

  async closeConversation(id: number): Promise<CloseConversationResponseDto> {
    const conversation = await this.prisma.cuocHoiThoai.findUnique({
      where: { CuocHoiThoaiID: id },
      select: CONVERSATION_SELECT,
    });

    if (!conversation) {
      throw new NotFoundException('Cuoc hoi thoai khong ton tai');
    }

    if (conversation.TrangThai === 'DaDong') {
      throw new BadRequestException('Cuoc hoi thoai da dong');
    }

    const updated = await this.prisma.cuocHoiThoai.update({
      where: { CuocHoiThoaiID: id },
      data: { TrangThai: 'DaDong' },
      select: CONVERSATION_SELECT,
    });

    return {
      message: 'Dong cuoc hoi thoai thanh cong',
      conversation: this.toConversationDto(updated),
    };
  }

  // ── Messages ───────────────────────────────────────────────────────────────

  async getMessages(conversationId: number): Promise<MessageListResponseDto> {
    const conversation = await this.prisma.cuocHoiThoai.findUnique({
      where: { CuocHoiThoaiID: conversationId },
      select: { CuocHoiThoaiID: true },
    });

    if (!conversation) {
      throw new NotFoundException('Cuoc hoi thoai khong ton tai');
    }

    const messages = await this.prisma.tinNhan.findMany({
      where: { CuocHoiThoaiID: conversationId },
      select: MESSAGE_SELECT,
      orderBy: { NgayTao: 'asc' },
    });

    return {
      total: messages.length,
      messages: messages.map((m) => this.toMessageDto(m)),
    };
  }

  async createMessage(
    payload: CreateMessageDto,
  ): Promise<MessageMutationResponseDto> {
    const conversation = await this.prisma.cuocHoiThoai.findUnique({
      where: { CuocHoiThoaiID: payload.cuocHoiThoaiId },
      select: { CuocHoiThoaiID: true, TrangThai: true, ThanhVien1ID: true, ThanhVien2ID: true },
    });

    if (!conversation) {
      throw new NotFoundException('Cuoc hoi thoai khong ton tai');
    }

    if (conversation.TrangThai !== 'DangMo') {
      throw new BadRequestException('Cuoc hoi thoai da dong');
    }

    // Validate sender is a member
    if (
      payload.nguoiGuiId !== conversation.ThanhVien1ID &&
      payload.nguoiGuiId !== conversation.ThanhVien2ID
    ) {
      throw new BadRequestException('Nguoi gui khong thuoc cuoc hoi thoai nay');
    }

    const noiDung = payload.noiDung?.trim();
    if (!noiDung) {
      throw new BadRequestException('Noi dung khong duoc de trong');
    }

    const message = await this.prisma.tinNhan.create({
      data: {
        CuocHoiThoaiID: payload.cuocHoiThoaiId,
        NguoiGuiID: payload.nguoiGuiId,
        NoiDung: noiDung,
        LoaiTin: payload.loaiTin || 'VanBan',
      },
      select: MESSAGE_SELECT,
    });

    // Update conversation last message time
    await this.prisma.cuocHoiThoai.update({
      where: { CuocHoiThoaiID: payload.cuocHoiThoaiId },
      data: { TinNhanCuoi: new Date() },
    });

    return {
      message: 'Gui tin nhan thanh cong',
      data: this.toMessageDto(message),
    };
  }

  async markAsRead(
    conversationId: number,
    userId: number,
  ): Promise<MarkReadResponseDto> {
    const conversation = await this.prisma.cuocHoiThoai.findUnique({
      where: { CuocHoiThoaiID: conversationId },
      select: { CuocHoiThoaiID: true },
    });

    if (!conversation) {
      throw new NotFoundException('Cuoc hoi thoai khong ton tai');
    }

    // Mark all messages NOT sent by this user as read
    const result = await this.prisma.tinNhan.updateMany({
      where: {
        CuocHoiThoaiID: conversationId,
        NguoiGuiID: { not: userId },
        DaDoc: false,
      },
      data: { DaDoc: true },
    });

    return {
      message: 'Danh dau da doc thanh cong',
      count: result.count,
    };
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  private async validateUser(userId: number): Promise<void> {
    const user = await this.prisma.taiKhoan.findUnique({
      where: { TaiKhoanID: userId },
      select: { TaiKhoanID: true },
    });

    if (!user) {
      throw new BadRequestException(`Tai khoan ${userId} khong ton tai`);
    }
  }

  private toConversationDto(c: ConversationEntity): ConversationDto {
    return {
      cuocHoiThoaiId: c.CuocHoiThoaiID,
      congViecId: c.CongViecID,
      thanhVien1: this.toMemberDto(c.ThanhVien1),
      thanhVien2: this.toMemberDto(c.ThanhVien2),
      tinNhanCuoi: c.TinNhanCuoi ? c.TinNhanCuoi.toISOString() : null,
      trangThai: c.TrangThai,
      ngayTao: c.NgayTao.toISOString(),
    };
  }

  private toMessageDto(m: MessageEntity): MessageDto {
    return {
      tinNhanId: m.TinNhanID,
      cuocHoiThoaiId: m.CuocHoiThoaiID,
      nguoiGui: this.toMemberDto(m.NguoiGui),
      noiDung: m.NoiDung,
      loaiTin: m.LoaiTin,
      daDoc: m.DaDoc,
      ngayTao: m.NgayTao.toISOString(),
    };
  }

  private toMemberDto(member: {
    TaiKhoanID: number;
    HoTen: string;
    Email: string;
  }): MemberSummaryDto {
    return {
      taiKhoanId: member.TaiKhoanID,
      hoTen: member.HoTen,
      email: member.Email,
    };
  }
}
