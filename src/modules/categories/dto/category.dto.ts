export type CategoryDto = {
  loaiDichVuId: number;
  tenLoai: string;
  moTa: string | null;
  hinhAnh: string | null;
};

export type CategoriesListResponseDto = {
  total: number;
  categories: CategoryDto[];
};

export type CategoryResponseDto = {
  category: CategoryDto;
};

export type CreateCategoryDto = {
  tenLoai: string;
  moTa?: string;
  hinhAnh?: string;
};

export type UpdateCategoryDto = {
  tenLoai?: string;
  moTa?: string;
  hinhAnh?: string;
};

export type CategoryMutationResponseDto = {
  message: string;
  category: CategoryDto;
};

export type CategoryDeleteResponseDto = {
  message: string;
  categoryId: number;
};
