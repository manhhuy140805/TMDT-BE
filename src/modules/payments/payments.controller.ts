import {
  Body,
  Controller,
  Get,
  Param,
  ParseIntPipe,
  Post,
  Put,
} from '@nestjs/common';
import { PaymentsService } from './payments.service';
import type {
  CreateDepositDto,
  PaymentsListResponseDto,
  PaymentMutationResponseDto,
  PaymentResponseDto,
} from './dto';

@Controller()
export class PaymentsController {
  constructor(private readonly paymentsService: PaymentsService) {}

  @Post('payments/deposit')
  deposit(
    @Body() payload: CreateDepositDto,
  ): Promise<PaymentMutationResponseDto> {
    return this.paymentsService.deposit(payload);
  }

  @Get('payments/:id')
  findOne(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<PaymentResponseDto> {
    return this.paymentsService.findById(id);
  }

  @Get('contracts/:id/payments')
  findByContract(
    @Param('id', ParseIntPipe) contractId: number,
  ): Promise<PaymentsListResponseDto> {
    return this.paymentsService.findByContractId(contractId);
  }

  @Put('payments/:id/release')
  release(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<PaymentMutationResponseDto> {
    return this.paymentsService.release(id);
  }

  @Put('payments/:id/refund')
  refund(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<PaymentMutationResponseDto> {
    return this.paymentsService.refund(id);
  }
}
