import {
  Body,
  Controller,
  Get,
  Param,
  ParseIntPipe,
  Post,
  Put,
} from '@nestjs/common';
import { ReportsService } from './reports.service';
import type {
  CreateReportDto,
  ReportListResponseDto,
  ReportMutationResponseDto,
  ResolveReportDto,
} from './dto';

@Controller('reports')
export class ReportsController {
  constructor(private readonly reportsService: ReportsService) {}

  @Post()
  create(
    @Body() payload: CreateReportDto,
  ): Promise<ReportMutationResponseDto> {
    return this.reportsService.create(payload);
  }

  @Get()
  findAll(): Promise<ReportListResponseDto> {
    return this.reportsService.findAll();
  }

  @Put(':id/resolve')
  resolve(
    @Param('id', ParseIntPipe) id: number,
    @Body() payload: ResolveReportDto,
  ): Promise<ReportMutationResponseDto> {
    return this.reportsService.resolve(id, payload);
  }
}
