import {
  Controller,
  Delete,
  Get,
  Param,
  ParseIntPipe,
  Put,
  Query,
} from '@nestjs/common';
import { NotificationsService } from './notifications.service';
import type {
  NotificationListResponseDto,
  NotificationMutationResponseDto,
} from './dto';

@Controller('notifications')
export class NotificationsController {
  constructor(private readonly notificationsService: NotificationsService) {}

  @Get()
  findByUser(
    @Query('userId', ParseIntPipe) userId: number,
  ): Promise<NotificationListResponseDto> {
    // In a real application, userId would be extracted from the authenticated request context (e.g. JWT token)
    return this.notificationsService.findByUserId(userId);
  }

  @Put(':id/read')
  markAsRead(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<NotificationMutationResponseDto> {
    return this.notificationsService.markAsRead(id);
  }

  @Delete(':id')
  delete(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<NotificationMutationResponseDto> {
    return this.notificationsService.delete(id);
  }
}
