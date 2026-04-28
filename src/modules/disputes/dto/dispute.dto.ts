import type {
  BenChiuPhiKetLuan,
  KetQuaTranhChap,
  TrangThaiTranhChap,
} from '@prisma/client';

export type DisputeDto = {
  tranhChapId: number;
  congViecId: number;
  nguoiGuiId: number;
  giamSatId: number | null;
  lyDo: string;
  moTa: string | null;
  trangThai: TrangThaiTranhChap;
  yeuCauHoanTien: string;
  ngayMo: string;
  ngayDong: string | null;
};

export type DisputeListResponseDto = {
  total: number;
  disputes: DisputeDto[];
};

export type DisputeResponseDto = {
  dispute: DisputeDto;
};

export type CreateDisputeDto = {
  congViecId: number;
  nguoiGuiId: number;
  lyDo: string;
  moTa?: string;
  yeuCauHoanTien: number;
};

export type ReviewDisputeDto = {
  giamSatId: number;
};

export type ResolveDisputeDto = {
  giamSatId: number;
  ketQua: KetQuaTranhChap;
  lyDo: string;
  soTienHoan: number;
  benChiuPhi: BenChiuPhiKetLuan;
};

export type DisputeMutationResponseDto = {
  message: string;
  dispute: DisputeDto;
};
