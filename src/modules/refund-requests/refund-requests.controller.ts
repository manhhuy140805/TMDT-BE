import {
  Body,
  Controller,
  Get,
  Param,
  ParseIntPipe,
  Post,
  Put,
} from '@nestjs/common';
import { RefundRequestsService } from './refund-requests.service';
import type {
  CreateRefundRequestDto,
  DecideRefundRequestDto,
  RefundRequestListResponseDto,
  RefundRequestMutationResponseDto,
  RefundRequestResponseDto,
} from './dto';

@Controller()
export class RefundRequestsController {
  constructor(private readonly refundRequestsService: RefundRequestsService) {}

  @Post('refund-requests')
  create(
    @Body() payload: CreateRefundRequestDto,
  ): Promise<RefundRequestMutationResponseDto> {
    return this.refundRequestsService.create(payload);
  }

  @Get('refund-requests/:id')
  findOne(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<RefundRequestResponseDto> {
    return this.refundRequestsService.findById(id);
  }

  @Get('contracts/:id/refund-requests')
  findByContract(
    @Param('id', ParseIntPipe) contractId: number,
  ): Promise<RefundRequestListResponseDto> {
    return this.refundRequestsService.findByContractId(contractId);
  }

  @Put('refund-requests/:id/accept')
  accept(
    @Param('id', ParseIntPipe) id: number,
    @Body() payload: DecideRefundRequestDto,
  ): Promise<RefundRequestMutationResponseDto> {
    return this.refundRequestsService.accept(id, payload);
  }

  @Put('refund-requests/:id/reject')
  reject(
    @Param('id', ParseIntPipe) id: number,
    @Body() payload: DecideRefundRequestDto,
  ): Promise<RefundRequestMutationResponseDto> {
    return this.refundRequestsService.reject(id, payload);
  }
}
