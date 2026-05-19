import { Module } from '@nestjs/common';
import { PrismaModule } from '../../common/prisma/prisma.module';
import { ProposalsModule } from '../proposals/proposals.module';
import { FreelancersController } from './freelancers.controller';
import { FreelancersService } from './freelancers.service';

@Module({
  imports: [PrismaModule, ProposalsModule],
  controllers: [FreelancersController],
  providers: [FreelancersService],
  exports: [FreelancersService],
})
export class FreelancersModule {}
