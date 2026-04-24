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
import { ProposalsService } from '../proposals/proposals.service';
import type { ProposalsListResponseDto } from '../proposals/dto';
import { JobsService } from './jobs.service';
import type {
  CreateJobDto,
  JobDeleteResponseDto,
  JobMutationResponseDto,
  JobResponseDto,
  JobsListResponseDto,
  SearchJobsQueryDto,
  UpdateJobDto,
} from './dto';

@Controller('jobs')
export class JobsController {
  constructor(
    private readonly jobsService: JobsService,
    private readonly proposalsService: ProposalsService,
  ) {}

  @Get()
  findAll(): Promise<JobsListResponseDto> {
    return this.jobsService.findAll();
  }

  @Get('search')
  search(@Query() query: SearchJobsQueryDto): Promise<JobsListResponseDto> {
    return this.jobsService.search(query);
  }

  @Get(':id')
  findOne(@Param('id', ParseIntPipe) id: number): Promise<JobResponseDto> {
    return this.jobsService.findOne(id);
  }

  @Get(':id/proposals')
  getJobProposals(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<ProposalsListResponseDto> {
    return this.proposalsService.findByJobId(id);
  }

  @Post()
  create(@Body() payload: CreateJobDto): Promise<JobMutationResponseDto> {
    return this.jobsService.create(payload);
  }

  @Put(':id')
  update(
    @Param('id', ParseIntPipe) id: number,
    @Body() payload: UpdateJobDto,
  ): Promise<JobMutationResponseDto> {
    return this.jobsService.update(id, payload);
  }

  @Delete(':id')
  remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<JobDeleteResponseDto> {
    return this.jobsService.remove(id);
  }
}
