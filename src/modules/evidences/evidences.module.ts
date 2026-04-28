import { Module } from '@nestjs/common';
import { PrismaModule } from '../../common/prisma/prisma.module';
import { EvidencesController } from './evidences.controller';
import { EvidencesService } from './evidences.service';

@Module({
  imports: [PrismaModule],
  controllers: [EvidencesController],
  providers: [EvidencesService],
  exports: [EvidencesService],
})
export class EvidencesModule {}
