import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  ParseIntPipe,
  Post,
} from '@nestjs/common';
import { EvidencesService } from './evidences.service';
import type {
  CreateEvidenceDto,
  EvidenceListResponseDto,
  EvidenceMutationResponseDto,
} from './dto';

@Controller()
export class EvidencesController {
  constructor(private readonly evidencesService: EvidencesService) {}

  @Post('disputes/:id/evidences')
  create(
    @Param('id', ParseIntPipe) disputeId: number,
    @Body() payload: CreateEvidenceDto,
  ): Promise<EvidenceMutationResponseDto> {
    return this.evidencesService.create(disputeId, payload);
  }

  @Get('disputes/:id/evidences')
  findByDispute(
    @Param('id', ParseIntPipe) disputeId: number,
  ): Promise<EvidenceListResponseDto> {
    return this.evidencesService.findByDisputeId(disputeId);
  }

  @Delete('evidences/:id')
  delete(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<EvidenceMutationResponseDto> {
    return this.evidencesService.delete(id);
  }
}
