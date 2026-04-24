import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  ParseIntPipe,
  Post,
  Put,
} from '@nestjs/common';
import { ProgressService } from './progress.service';
import type {
  CreateProgressDto,
  ProgressDeleteResponseDto,
  ProgressMutationResponseDto,
  ProgressResponseDto,
  UpdateProgressDto,
} from './dto/progress.dto';

@Controller('progress')
export class ProgressController {
  constructor(private readonly progressService: ProgressService) {}

  @Get(':id')
  findOne(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<ProgressResponseDto> {
    return this.progressService.findOne(id);
  }

  @Post()
  create(
    @Body() payload: CreateProgressDto,
  ): Promise<ProgressMutationResponseDto> {
    return this.progressService.create(payload);
  }

  @Put(':id')
  update(
    @Param('id', ParseIntPipe) id: number,
    @Body() payload: UpdateProgressDto,
  ): Promise<ProgressMutationResponseDto> {
    return this.progressService.update(id, payload);
  }

  @Delete(':id')
  remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<ProgressDeleteResponseDto> {
    return this.progressService.remove(id);
  }
}
