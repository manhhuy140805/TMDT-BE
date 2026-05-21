import {
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../../common/prisma/prisma.service';
import type { Prisma } from '@prisma/client';
import type {
  NotificationDto,
  NotificationListResponseDto,
  NotificationMutationResponseDto,
} from './dto';

const NOTIFICATION_SELECT = {
  ThongBaoID: true,
  TaiKhoanID: true,
  TieuDe: true,
  NoiDung: true,
  LoaiThongBao: true,
  DaDoc: true,
  NgayTao: true,
} as const;

type NotificationEntity = Prisma.ThongBaoGetPayload<{
  select: typeof NOTIFICATION_SELECT;
}>;

@Injectable()
export class NotificationsService {
  constructor(private readonly prisma: PrismaService) {}

  async findByUserId(userId: number): Promise<NotificationListResponseDto> {
    const notifications = await this.prisma.thongBao.findMany({
      where: { TaiKhoanID: userId },
      select: NOTIFICATION_SELECT,
      orderBy: { NgayTao: 'desc' },
    });

    return {
      total: notifications.length,
      notifications: notifications.map((n) => this.toNotificationDto(n)),
    };
  }

  async markAsRead(id: number): Promise<NotificationMutationResponseDto> {
    const notification = await this.prisma.thongBao.findUnique({
      where: { ThongBaoID: id },
    });

    if (!notification) {
      throw new NotFoundException('Thong bao khong ton tai');
    }

    const updated = await this.prisma.thongBao.update({
      where: { ThongBaoID: id },
      data: { DaDoc: true },
      select: NOTIFICATION_SELECT,
    });

    return {
      message: 'Da danh dau la da doc',
      notification: this.toNotificationDto(updated),
    };
  }

  async delete(id: number): Promise<NotificationMutationResponseDto> {
    const notification = await this.prisma.thongBao.findUnique({
      where: { ThongBaoID: id },
    });

    if (!notification) {
      throw new NotFoundException('Thong bao khong ton tai');
    }

    await this.prisma.thongBao.delete({
      where: { ThongBaoID: id },
    });

    return {
      message: 'Xoa thong bao thanh cong',
    };
  }

  private toNotificationDto(notification: NotificationEntity): NotificationDto {
    return {
      thongBaoId: notification.ThongBaoID,
      taiKhoanId: notification.TaiKhoanID,
      tieuDe: notification.TieuDe,
      noiDung: notification.NoiDung,
      loaiThongBao: notification.LoaiThongBao,
      daDoc: notification.DaDoc,
      ngayTao: notification.NgayTao.toISOString(),
    };
  }
}
