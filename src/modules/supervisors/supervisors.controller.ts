import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  ParseIntPipe,
  Post,
  Put,
  Query,
} from '@nestjs/common';
import { SupervisorsService } from './supervisors.service';
import type {
  CreateSupervisorDto,
  SupervisorDeleteResponseDto,
  SupervisorMutationResponseDto,
  SupervisorResponseDto,
  SupervisorsListResponseDto,
  SearchSupervisorsQueryDto,
  UpdateSupervisorDto,
} from './dto';

@Controller('supervisors')
export class SupervisorsController {
  constructor(private readonly supervisorsService: SupervisorsService) {}

  @Get()
  findAll(): Promise<SupervisorsListResponseDto> {
    return this.supervisorsService.findAll();
  }

  @Get('search')
  search(
    @Query() query: SearchSupervisorsQueryDto,
  ): Promise<SupervisorsListResponseDto> {
    return this.supervisorsService.search(query);
  }

  @Get(':id')
  findOne(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<SupervisorResponseDto> {
    return this.supervisorsService.findOne(id);
  }

  @Post()
  create(
    @Body() payload: CreateSupervisorDto,
  ): Promise<SupervisorMutationResponseDto> {
    return this.supervisorsService.create(payload);
  }

  @Put(':id')
  update(
    @Param('id', ParseIntPipe) id: number,
    @Body() payload: UpdateSupervisorDto,
  ): Promise<SupervisorMutationResponseDto> {
    return this.supervisorsService.update(id, payload);
  }

  @Delete(':id')
  remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<SupervisorDeleteResponseDto> {
    return this.supervisorsService.remove(id);
  }
}
