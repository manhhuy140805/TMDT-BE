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
import { CategoriesService } from './categories.service';
import type {
  CategoriesListResponseDto,
  CategoryDeleteResponseDto,
  CategoryMutationResponseDto,
  CategoryResponseDto,
  CreateCategoryDto,
  UpdateCategoryDto,
} from './dto';

@Controller('categories')
export class CategoriesController {
  constructor(private readonly categoriesService: CategoriesService) {}

  @Get()
  findAll(): Promise<CategoriesListResponseDto> {
    return this.categoriesService.findAll();
  }

  @Get(':id')
  findOne(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<CategoryResponseDto> {
    return this.categoriesService.findOne(id);
  }

  @Post()
  create(
    @Body() payload: CreateCategoryDto,
  ): Promise<CategoryMutationResponseDto> {
    return this.categoriesService.create(payload);
  }

  @Put(':id')
  update(
    @Param('id', ParseIntPipe) id: number,
    @Body() payload: UpdateCategoryDto,
  ): Promise<CategoryMutationResponseDto> {
    return this.categoriesService.update(id, payload);
  }

  @Delete(':id')
  remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<CategoryDeleteResponseDto> {
    return this.categoriesService.remove(id);
  }
}
