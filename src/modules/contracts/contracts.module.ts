import { Module } from '@nestjs/common';
import { PrismaModule } from '../../common/prisma/prisma.module';
import { ProgressModule } from '../progress/progress.module';
import { ChatModule } from '../chat/chat.module';
import { ContractsController } from './contracts.controller';
import { ContractsService } from './contracts.service';
import { ContractFlowService } from './contract-flow.service';

@Module({
  imports: [PrismaModule, ProgressModule, ChatModule],
  controllers: [ContractsController],
  providers: [ContractsService, ContractFlowService],
  exports: [ContractsService],
})
export class ContractsModule {}
