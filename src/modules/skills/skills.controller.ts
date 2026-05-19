import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  ParseIntPipe,
  Post,
  Put,
} from '@nestjs/common';
import { SkillsService } from './skills.service';
import type {
  CreateSkillDto,
  SkillDeleteResponseDto,
  SkillMutationResponseDto,
  SkillResponseDto,
  SkillsListResponseDto,
  UpdateSkillDto,
} from './dto';

@Controller('skills')
export class SkillsController {
  constructor(private readonly skillsService: SkillsService) {}

  // GET /skills
  @Get()
  findAll(): Promise<SkillsListResponseDto> {
    return this.skillsService.findAll();
  }

  // GET /skills/:id
  @Get(':id')
  findOne(@Param('id', ParseIntPipe) id: number): Promise<SkillResponseDto> {
    return this.skillsService.findOne(id);
  }

  // POST /skills
  @Post()
  create(@Body() payload: CreateSkillDto): Promise<SkillMutationResponseDto> {
    return this.skillsService.create(payload);
  }

  // PUT /skills/:id
  @Put(':id')
  update(
    @Param('id', ParseIntPipe) id: number,
    @Body() payload: UpdateSkillDto,
  ): Promise<SkillMutationResponseDto> {
    return this.skillsService.update(id, payload);
  }

  // DELETE /skills/:id
  @Delete(':id')
  remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<SkillDeleteResponseDto> {
    return this.skillsService.remove(id);
  }
}
