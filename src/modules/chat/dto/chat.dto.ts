import type { LoaiTinNhan, TrangThaiCuocHoiThoai } from '@prisma/client';

export type ConversationDto = {
  cuocHoiThoaiId: number;
  congViecId: number | null;
  thanhVien1Id: number;
  thanhVien2Id: number;
  giamSatId: number | null;
  tinNhanCuoi: string | null;
  trangThai: TrangThaiCuocHoiThoai;
  ngayTao: string;
};

export type ConversationListResponseDto = {
  total: number;
  conversations: ConversationDto[];
};

export type ConversationResponseDto = {
  conversation: ConversationDto;
};

export type CreateConversationDto = {
  congViecId?: number;
  thanhVien1Id: number;
  thanhVien2Id: number;
  giamSatId?: number;
};

export type ConversationMutationResponseDto = {
  message: string;
  conversation: ConversationDto;
};

export type MessageDto = {
  tinNhanId: number;
  cuocHoiThoaiId: number;
  nguoiGuiId: number;
  noiDung: string;
  loaiTin: LoaiTinNhan;
  daDoc: boolean;
  ngayTao: string;
};

export type MessageListResponseDto = {
  total: number;
  messages: MessageDto[];
};

export type CreateMessageDto = {
  cuocHoiThoaiId: number;
  nguoiGuiId: number;
  noiDung: string;
  loaiTin?: LoaiTinNhan;
};

export type MessageMutationResponseDto = {
  message: string;
  data: MessageDto;
};
