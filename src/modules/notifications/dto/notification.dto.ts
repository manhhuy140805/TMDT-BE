import type { LoaiThongBao } from '@prisma/client';

export type NotificationDto = {
  thongBaoId: number;
  taiKhoanId: number;
  tieuDe: string;
  noiDung: string | null;
  loaiThongBao: LoaiThongBao;
  daDoc: boolean;
  ngayTao: string;
};

export type NotificationListResponseDto = {
  total: number;
  notifications: NotificationDto[];
};

export type NotificationMutationResponseDto = {
  message: string;
  notification?: NotificationDto;
};
