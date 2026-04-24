import { beforeEach, describe, expect, it } from '@jest/globals';
import { Test, TestingModule } from '@nestjs/testing';
import { HealthController } from './health.controller';
import { HealthService } from './health.service';

describe('HealthController', () => {
  let healthController: HealthController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [HealthController],
      providers: [HealthService],
    }).compile();

    healthController = module.get<HealthController>(HealthController);
  });

  it('should return status ok and a timestamp', () => {
    const result = healthController.getHealth();

    expect(result.status).toBe('ok');
    expect(typeof result.timestamp).toBe('string');
  });
});
