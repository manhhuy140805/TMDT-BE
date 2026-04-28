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
import { PaymentsModule } from './modules/payments/payments.module';
import { DisputesModule } from './modules/disputes/disputes.module';
import { EvidencesModule } from './modules/evidences/evidences.module';
import { ReviewsModule } from './modules/reviews/reviews.module';
import { ChatModule } from './modules/chat/chat.module';
import { NotificationsModule } from './modules/notifications/notifications.module';
import { ReportsModule } from './modules/reports/reports.module';
import { AdminModule } from './modules/admin/admin.module';

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
    PaymentsModule,
    DisputesModule,
    EvidencesModule,
    ReviewsModule,
    ChatModule,
    NotificationsModule,
    ReportsModule,
    AdminModule,
  ],
})
export class AppModule {}
