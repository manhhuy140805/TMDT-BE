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
import { ProposalsService } from '../proposals/proposals.service';
import type { ProposalsListResponseDto } from '../proposals/dto';
import { FreelancersService } from './freelancers.service';
import type {
  FreelancerSkillsResponseDto,
  SetFreelancerSkillsDto,
} from './dto';

@Controller('freelancers')
export class FreelancersController {
  constructor(
    private readonly freelancersService: FreelancersService,
    private readonly proposalsService: ProposalsService,
  ) {}

  // GET /freelancers/:id/proposals
  @Get(':id/proposals')
  getFreelancerProposals(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<ProposalsListResponseDto> {
    return this.proposalsService.findByFreelancerId(id);
  }

  // GET /freelancers/:id/skills
  @Get(':id/skills')
  getSkills(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<FreelancerSkillsResponseDto> {
    return this.freelancersService.getSkills(id);
  }

  // PUT /freelancers/:id/skills — thay thế toàn bộ danh sách kỹ năng
  @Put(':id/skills')
  setSkills(
    @Param('id', ParseIntPipe) id: number,
    @Body() payload: SetFreelancerSkillsDto,
  ): Promise<FreelancerSkillsResponseDto> {
    return this.freelancersService.setSkills(id, payload);
  }

  // POST /freelancers/:id/skills/:kyNangId — thêm 1 kỹ năng
  @Post(':id/skills/:kyNangId')
  addSkill(
    @Param('id', ParseIntPipe) id: number,
    @Param('kyNangId', ParseIntPipe) kyNangId: number,
  ): Promise<FreelancerSkillsResponseDto> {
    return this.freelancersService.addSkill(id, kyNangId);
  }

  // DELETE /freelancers/:id/skills/:kyNangId — xóa 1 kỹ năng
  @Delete(':id/skills/:kyNangId')
  removeSkill(
    @Param('id', ParseIntPipe) id: number,
    @Param('kyNangId', ParseIntPipe) kyNangId: number,
  ): Promise<FreelancerSkillsResponseDto> {
    return this.freelancersService.removeSkill(id, kyNangId);
  }
}
