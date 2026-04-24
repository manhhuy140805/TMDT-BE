import { Module } from '@nestjs/common';
import { PrismaModule } from '../../common/prisma/prisma.module';
import { JobsModule } from '../jobs/jobs.module';
import { ContractsModule } from '../contracts/contracts.module';
import { UsersController } from './users.controller';
import { UsersService } from './users.service';

@Module({
  imports: [PrismaModule, JobsModule, ContractsModule],
  controllers: [UsersController],
  providers: [UsersService],
})
export class UsersModule {}
