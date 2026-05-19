import type { SkillSummaryDto } from '../../jobs/dto';

export type FreelancerSkillsResponseDto = {
  message: string;
  freelancerId: number;
  kyNangs: SkillSummaryDto[];
};

export type SetFreelancerSkillsDto = {
  kyNangIds: number[];
};
