import { Module } from '@nestjs/common';
import { PrismaModule } from '../../common/prisma/prisma.module';
import { SupervisorsController } from './supervisors.controller';
import { SupervisorsService } from './supervisors.service';

@Module({
  imports: [PrismaModule],
  controllers: [SupervisorsController],
  providers: [SupervisorsService],
  exports: [SupervisorsService],
})
export class SupervisorsModule {}
