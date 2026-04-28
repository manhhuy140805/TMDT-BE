import { Controller, Get, Param, ParseIntPipe, Put } from '@nestjs/common';
import { AdminService } from './admin.service';
import type {
  AdminMutationResponseDto,
  AdminStatisticsResponseDto,
  AdminSupervisorListResponseDto,
  AdminUserListResponseDto,
} from './dto';

@Controller('admin')
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  @Get('users')
  getUsers(): Promise<AdminUserListResponseDto> {
    return this.adminService.getUsers();
  }

  @Put('users/:id/ban')
  banUser(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<AdminMutationResponseDto> {
    return this.adminService.banUser(id);
  }

  @Get('supervisors')
  getSupervisors(): Promise<AdminSupervisorListResponseDto> {
    return this.adminService.getSupervisors();
  }

  @Put('supervisors/:id/approve')
  approveSupervisor(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<AdminMutationResponseDto> {
    return this.adminService.approveSupervisor(id);
  }

  @Get('statistics')
  getStatistics(): Promise<AdminStatisticsResponseDto> {
    return this.adminService.getStatistics();
  }
}
