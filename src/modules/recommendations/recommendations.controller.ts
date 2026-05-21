import { Controller, Get, Param, ParseIntPipe } from '@nestjs/common';
import { RecommendationsService } from './recommendations.service';
import type {
  RecommendedFreelancersResponseDto,
  RecommendedSupervisorsResponseDto,
} from './dto';

@Controller('recommendations')
export class RecommendationsController {
  constructor(
    private readonly recommendationsService: RecommendationsService,
  ) {}

  // GET /recommendations/freelancers/:yeuCauId
  @Get('freelancers/:yeuCauId')
  recommendFreelancers(
    @Param('yeuCauId', ParseIntPipe) yeuCauId: number,
  ): Promise<RecommendedFreelancersResponseDto> {
    return this.recommendationsService.recommendFreelancers(yeuCauId);
  }

  // GET /recommendations/supervisors
  @Get('supervisors')
  recommendSupervisors(): Promise<RecommendedSupervisorsResponseDto> {
    return this.recommendationsService.recommendSupervisors();
  }
}
