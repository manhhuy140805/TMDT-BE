import type { LoaiBangChung } from '@prisma/client';

export type EvidenceDto = {
  bangChungId: number;
  tranhChapId: number;
  nguoiNopId: number;
  loaiBangChung: LoaiBangChung;
  noiDung: string | null;
  duongDanFile: string | null;
  ngayNop: string;
};

export type EvidenceListResponseDto = {
  total: number;
  evidences: EvidenceDto[];
};

export type EvidenceResponseDto = {
  evidence: EvidenceDto;
};

export type CreateEvidenceDto = {
  nguoiNopId: number;
  loaiBangChung: LoaiBangChung;
  noiDung?: string;
  duongDanFile?: string;
};

export type EvidenceMutationResponseDto = {
  message: string;
  evidence: EvidenceDto | null;
};
