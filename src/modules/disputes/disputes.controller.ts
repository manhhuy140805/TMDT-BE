import {
  Body,
  Controller,
  Get,
  Param,
  ParseIntPipe,
  Post,
  Put,
} from '@nestjs/common';
import { DisputesService } from './disputes.service';
import type {
  CreateDisputeDto,
  DisputeListResponseDto,
  DisputeMutationResponseDto,
  DisputeResponseDto,
  ResolveDisputeDto,
  ReviewDisputeDto,
} from './dto';

@Controller()
export class DisputesController {
  constructor(private readonly disputesService: DisputesService) {}

  @Post('disputes')
  create(
    @Body() payload: CreateDisputeDto,
  ): Promise<DisputeMutationResponseDto> {
    return this.disputesService.create(payload);
  }

  @Get('disputes/:id')
  findOne(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<DisputeResponseDto> {
    return this.disputesService.findById(id);
  }

  @Get('contracts/:id/disputes')
  findByContract(
    @Param('id', ParseIntPipe) contractId: number,
  ): Promise<DisputeListResponseDto> {
    return this.disputesService.findByContractId(contractId);
  }

  @Put('disputes/:id/review')
  review(
    @Param('id', ParseIntPipe) id: number,
    @Body() payload: ReviewDisputeDto,
  ): Promise<DisputeMutationResponseDto> {
    return this.disputesService.review(id, payload);
  }

  @Put('disputes/:id/resolve')
  resolve(
    @Param('id', ParseIntPipe) id: number,
    @Body() payload: ResolveDisputeDto,
  ): Promise<DisputeMutationResponseDto> {
    return this.disputesService.resolve(id, payload);
  }
}
