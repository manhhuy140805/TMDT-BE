export type SkillDto = {
  kyNangId: number;
  tenKyNang: string;
  moTa: string | null;
};

export type SkillsListResponseDto = {
  total: number;
  skills: SkillDto[];
};

export type SkillResponseDto = {
  skill: SkillDto;
};

export type CreateSkillDto = {
  tenKyNang: string;
  moTa?: string;
};

export type UpdateSkillDto = {
  tenKyNang?: string;
  moTa?: string;
};

export type SkillMutationResponseDto = {
  message: string;
  skill: SkillDto;
};

export type SkillDeleteResponseDto = {
  message: string;
  kyNangId: number;
};
