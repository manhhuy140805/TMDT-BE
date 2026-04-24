import { Module } from '@nestjs/common';
import { AuthModule } from './modules/auth/auth.module';
import { CategoriesModule } from './modules/categories/categories.module';
import { ContractsModule } from './modules/contracts/contracts.module';
import { FreelancersModule } from './modules/freelancers/freelancers.module';
import { HealthModule } from './modules/health/health.module';
import { JobsModule } from './modules/jobs/jobs.module';
import { ProgressModule } from './modules/progress/progress.module';
import { ProposalsModule } from './modules/proposals/proposals.module';
import { SupervisorsModule } from './modules/supervisors/supervisors.module';
import { UsersModule } from './modules/users/users.module';

@Module({
  imports: [
    HealthModule,
    AuthModule,
    UsersModule,
    CategoriesModule,
    JobsModule,
    ProposalsModule,
    FreelancersModule,
    ContractsModule,
    SupervisorsModule,
    ProgressModule,
  ],
})
export class AppModule {}
