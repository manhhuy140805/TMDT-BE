import { Module } from '@nestjs/common';
import { PrismaModule } from '../../common/prisma/prisma.module';
import { RefundRequestsController } from './refund-requests.controller';
import { RefundRequestsService } from './refund-requests.service';

@Module({
  imports: [PrismaModule],
  controllers: [RefundRequestsController],
  providers: [RefundRequestsService],
  exports: [RefundRequestsService],
})
export class RefundRequestsModule {}
