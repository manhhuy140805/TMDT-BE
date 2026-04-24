import { Module } from '@nestjs/common';
import { ProposalsModule } from '../proposals/proposals.module';
import { FreelancersController } from './freelancers.controller';

@Module({
  imports: [ProposalsModule],
  controllers: [FreelancersController],
})
export class FreelancersModule {}
