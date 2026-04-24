import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  ParseIntPipe,
  Put,
  Query,
} from '@nestjs/common';
import { JobsService } from '../jobs/jobs.service';
import { ContractsService } from '../contracts/contracts.service';
import type { JobsListResponseDto } from '../jobs/dto';
import type { ContractsListResponseDto } from '../contracts/dto';
import type {
  SearchUsersQueryDto,
  UpdateUserDto,
  UserDeleteResponseDto,
  UserMutationResponseDto,
  UserProfileResponseDto,
  UserResponseDto,
  UsersListResponseDto,
} from './dto';
import { UsersService } from './users.service';

@Controller('users')
export class UsersController {
  constructor(
    private readonly usersService: UsersService,
    private readonly jobsService: JobsService,
    private readonly contractsService: ContractsService,
  ) {}

  @Get()
  findAll(): Promise<UsersListResponseDto> {
    return this.usersService.findAll();
  }

  @Get('search')
  search(@Query() query: SearchUsersQueryDto): Promise<UsersListResponseDto> {
    return this.usersService.search(query);
  }

  @Get(':id/profile')
  getProfile(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<UserProfileResponseDto> {
    return this.usersService.getProfile(id);
  }

  @Get(':id/jobs')
  getUserJobs(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<JobsListResponseDto> {
    return this.jobsService.findByUserId(id);
  }

  @Get(':id/contracts')
  getUserContracts(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<ContractsListResponseDto> {
    return this.contractsService.findByUserId(id);
  }

  @Get(':id')
  findOne(@Param('id', ParseIntPipe) id: number): Promise<UserResponseDto> {
    return this.usersService.findOne(id);
  }

  @Put(':id')
  update(
    @Param('id', ParseIntPipe) id: number,
    @Body() payload: UpdateUserDto,
  ): Promise<UserMutationResponseDto> {
    return this.usersService.update(id, payload);
  }

  @Delete(':id')
  remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<UserDeleteResponseDto> {
    return this.usersService.remove(id);
  }
}
