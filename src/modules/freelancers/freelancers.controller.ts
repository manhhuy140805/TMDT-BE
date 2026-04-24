import { Controller, Get, Param, ParseIntPipe } from '@nestjs/common';
import { ProposalsService } from '../proposals/proposals.service';
import type { ProposalsListResponseDto } from '../proposals/dto';

@Controller('freelancers')
export class FreelancersController {
  constructor(private readonly proposalsService: ProposalsService) {}

  @Get(':id/proposals')
  getFreelancerProposals(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<ProposalsListResponseDto> {
    return this.proposalsService.findByFreelancerId(id);
  }
}
