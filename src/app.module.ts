import { Module } from '@nestjs/common';
import { AuthModule } from './modules/auth/auth.module';
import { CategoriesModule } from './modules/categories/categories.module';
import { ContractsModule } from './modules/contracts/contracts.module';
import { FreelancersModule } from './modules/freelancers/freelancers.module';
import { HealthModule } from './modules/health/health.module';
import { JobsModule } from './modules/jobs/jobs.module';
import { ProgressModule } from './modules/progress/progress.module';
import { ProposalsModule } from './modules/proposals/proposals.module';
import { RecommendationsModule } from './modules/recommendations/recommendations.module';
import { SkillsModule } from './modules/skills/skills.module';
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
import { RefundRequestsModule } from './modules/refund-requests/refund-requests.module';
import { UploadModule } from './modules/upload/upload.module';

@Module({
  imports: [
    HealthModule,
    AuthModule,
    UsersModule,
    CategoriesModule,
    SkillsModule,
    JobsModule,
    ProposalsModule,
    FreelancersModule,
    ContractsModule,
    SupervisorsModule,
    ProgressModule,
    RecommendationsModule,
    PaymentsModule,
    RefundRequestsModule,
    DisputesModule,
    EvidencesModule,
    ReviewsModule,
    ChatModule,
    NotificationsModule,
    ReportsModule,
    AdminModule,
    UploadModule,
  ],
})
export class AppModule {}
