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
  JobSkillsMutationResponseDto,
  JobsListResponseDto,
  SearchJobsQueryDto,
  SetJobSkillsDto,
  UpdateJobDto,
} from './dto';

@Controller('jobs')
export class JobsController {
  constructor(
    private readonly jobsService: JobsService,
    private readonly proposalsService: ProposalsService,
  ) {}

  // GET /jobs
  @Get()
  findAll(): Promise<JobsListResponseDto> {
    return this.jobsService.findAll();
  }

  // GET /jobs/search?keyword=&category=&budget=&skills=1,2,3
  @Get('search')
  search(@Query() query: SearchJobsQueryDto): Promise<JobsListResponseDto> {
    return this.jobsService.search(query);
  }

  // GET /jobs/:id
  @Get(':id')
  findOne(@Param('id', ParseIntPipe) id: number): Promise<JobResponseDto> {
    return this.jobsService.findOne(id);
  }

  // GET /jobs/:id/proposals
  @Get(':id/proposals')
  getJobProposals(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<ProposalsListResponseDto> {
    return this.proposalsService.findByJobId(id);
  }

  // GET /jobs/:id/skills
  @Get(':id/skills')
  getJobSkills(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<JobSkillsMutationResponseDto> {
    return this.jobsService.getJobSkills(id);
  }

  // POST /jobs
  @Post()
  create(@Body() payload: CreateJobDto): Promise<JobMutationResponseDto> {
    return this.jobsService.create(payload);
  }

  // PUT /jobs/:id
  @Put(':id')
  update(
    @Param('id', ParseIntPipe) id: number,
    @Body() payload: UpdateJobDto,
  ): Promise<JobMutationResponseDto> {
    return this.jobsService.update(id, payload);
  }

  // PUT /jobs/:id/skills  — thay thế toàn bộ danh sách kỹ năng
  @Put(':id/skills')
  setJobSkills(
    @Param('id', ParseIntPipe) id: number,
    @Body() payload: SetJobSkillsDto,
  ): Promise<JobSkillsMutationResponseDto> {
    return this.jobsService.setJobSkills(id, payload);
  }

  // POST /jobs/:id/skills/:kyNangId — thêm 1 kỹ năng
  @Post(':id/skills/:kyNangId')
  addJobSkill(
    @Param('id', ParseIntPipe) id: number,
    @Param('kyNangId', ParseIntPipe) kyNangId: number,
  ): Promise<JobSkillsMutationResponseDto> {
    return this.jobsService.addJobSkill(id, kyNangId);
  }

  // DELETE /jobs/:id/skills/:kyNangId — xóa 1 kỹ năng
  @Delete(':id/skills/:kyNangId')
  removeJobSkill(
    @Param('id', ParseIntPipe) id: number,
    @Param('kyNangId', ParseIntPipe) kyNangId: number,
  ): Promise<JobSkillsMutationResponseDto> {
    return this.jobsService.removeJobSkill(id, kyNangId);
  }

  // DELETE /jobs/:id
  @Delete(':id')
  remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<JobDeleteResponseDto> {
    return this.jobsService.remove(id);
  }
}
