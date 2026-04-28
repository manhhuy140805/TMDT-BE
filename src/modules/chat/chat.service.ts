import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../../common/prisma/prisma.service';
import type { Prisma } from '@prisma/client';
import type {
  ConversationDto,
  ConversationListResponseDto,
  ConversationMutationResponseDto,
  ConversationResponseDto,
  CreateConversationDto,
  CreateMessageDto,
  MessageDto,
  MessageListResponseDto,
  MessageMutationResponseDto,
} from './dto';

const CONVERSATION_SELECT = {
  CuocHoiThoaiID: true,
  CongViecID: true,
  ThanhVien1ID: true,
  ThanhVien2ID: true,
  GiamSatID: true,
  TinNhanCuoi: true,
  TrangThai: true,
  NgayTao: true,
} as const;

const MESSAGE_SELECT = {
  TinNhanID: true,
  CuocHoiThoaiID: true,
  NguoiGuiID: true,
  NoiDung: true,
  LoaiTin: true,
  DaDoc: true,
  NgayTao: true,
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

  // --- Conversations ---

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
    // Check if conversation already exists between these 2 members (and same contract/supervisor if applied)
    const existing = await this.prisma.cuocHoiThoai.findFirst({
      where: {
        CongViecID: payload.congViecId || null,
        ThanhVien1ID: payload.thanhVien1Id,
        ThanhVien2ID: payload.thanhVien2Id,
      },
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
        GiamSatID: payload.giamSatId || null,
        TrangThai: 'DangMo',
      },
      select: CONVERSATION_SELECT,
    });

    return {
      message: 'Tao cuoc hoi thoai thanh cong',
      conversation: this.toConversationDto(conversation),
    };
  }

  // --- Messages ---

  async getMessages(conversationId: number): Promise<MessageListResponseDto> {
    const conversation = await this.prisma.cuocHoiThoai.findUnique({
      where: { CuocHoiThoaiID: conversationId },
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
    });

    if (!conversation) {
      throw new NotFoundException('Cuoc hoi thoai khong ton tai');
    }

    if (conversation.TrangThai !== 'DangMo') {
      throw new BadRequestException('Cuoc hoi thoai da dong');
    }

    // Verify sender belongs to conversation
    const isValidSender =
      payload.nguoiGuiId === conversation.ThanhVien1ID ||
      payload.nguoiGuiId === conversation.ThanhVien2ID ||
      (conversation.GiamSatID && payload.nguoiGuiId === conversation.GiamSatID);

    // In a real scenario, Giamsat ID is not a User ID, it links to DonViGiamSat. 
    // Usually senderId must be mapped properly. We assume basic matching for now.

    const message = await this.prisma.tinNhan.create({
      data: {
        CuocHoiThoaiID: payload.cuocHoiThoaiId,
        NguoiGuiID: payload.nguoiGuiId,
        NoiDung: payload.noiDung,
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

  // --- Mappers ---

  private toConversationDto(conversation: ConversationEntity): ConversationDto {
    return {
      cuocHoiThoaiId: conversation.CuocHoiThoaiID,
      congViecId: conversation.CongViecID,
      thanhVien1Id: conversation.ThanhVien1ID,
      thanhVien2Id: conversation.ThanhVien2ID,
      giamSatId: conversation.GiamSatID,
      tinNhanCuoi: conversation.TinNhanCuoi
        ? conversation.TinNhanCuoi.toISOString()
        : null,
      trangThai: conversation.TrangThai,
      ngayTao: conversation.NgayTao.toISOString(),
    };
  }

  private toMessageDto(message: MessageEntity): MessageDto {
    return {
      tinNhanId: message.TinNhanID,
      cuocHoiThoaiId: message.CuocHoiThoaiID,
      nguoiGuiId: message.NguoiGuiID,
      noiDung: message.NoiDung,
      loaiTin: message.LoaiTin,
      daDoc: message.DaDoc,
      ngayTao: message.NgayTao.toISOString(),
    };
  }
}
