import {
  Body,
  Controller,
  Get,
  Param,
  ParseIntPipe,
  Post,
} from '@nestjs/common';
import { ReviewsService } from './reviews.service';
import type {
  CreateReviewDto,
  ReviewListResponseDto,
  ReviewMutationResponseDto,
  ReviewResponseDto,
} from './dto';

@Controller()
export class ReviewsController {
  constructor(private readonly reviewsService: ReviewsService) {}

  @Post('reviews')
  create(
    @Body() payload: CreateReviewDto,
  ): Promise<ReviewMutationResponseDto> {
    return this.reviewsService.create(payload);
  }

  @Get('reviews/:id')
  findOne(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<ReviewResponseDto> {
    return this.reviewsService.findById(id);
  }

  @Get('users/:id/reviews')
  findByUser(
    @Param('id', ParseIntPipe) userId: number,
  ): Promise<ReviewListResponseDto> {
    return this.reviewsService.findByUserId(userId);
  }

  @Get('contracts/:id/reviews')
  findByContract(
    @Param('id', ParseIntPipe) contractId: number,
  ): Promise<ReviewListResponseDto> {
    return this.reviewsService.findByContractId(contractId);
  }
}
