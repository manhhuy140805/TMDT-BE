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
import { ProposalsService } from './proposals.service';
import type {
  CreateProposalDto,
  ProposalDeleteResponseDto,
  ProposalMutationResponseDto,
  ProposalResponseDto,
  UpdateProposalDto,
} from './dto';

@Controller('proposals')
export class ProposalsController {
  constructor(private readonly proposalsService: ProposalsService) {}

  @Get(':id')
  findOne(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<ProposalResponseDto> {
    return this.proposalsService.findOne(id);
  }

  @Post()
  create(
    @Body() payload: CreateProposalDto,
  ): Promise<ProposalMutationResponseDto> {
    return this.proposalsService.create(payload);
  }

  @Put(':id')
  update(
    @Param('id', ParseIntPipe) id: number,
    @Body() payload: UpdateProposalDto,
  ): Promise<ProposalMutationResponseDto> {
    return this.proposalsService.update(id, payload);
  }

  @Delete(':id')
  remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<ProposalDeleteResponseDto> {
    return this.proposalsService.remove(id);
  }
}
