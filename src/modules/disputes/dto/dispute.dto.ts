import type {
  BenChiuPhiKetLuan,
  KetQuaTranhChap,
  LoaiBangChung,
  TrangThaiTranhChap,
} from '@prisma/client';

export type BangChungHoanTienDto = {
  bangChungId: number;
  yeuCauHoanTienId: number;
  nguoiNopId: number;
  loaiBangChung: LoaiBangChung;
  noiDung: string | null;
  duongDanFile: string | null;
  loaiNguoiNop: string; // "NguoiThue" | "Freelancer"
  ngayNop: string;
};

export type BangChungKetLuanDto = {
  bangChungId: number;
  ketLuanId: number;
  nguoiNopId: number;
  loaiBangChung: LoaiBangChung;
  noiDung: string | null;
  duongDanFile: string | null;
  ngayNop: string;
};

export type BangChungCreateDto = {
  loaiBangChung: LoaiBangChung;
  noiDung?: string;
  duongDanFile?: string;
};

export type DisputeDto = {
  tranhChapId: number;
  congViecId: number;
  nguoiGuiId: number;
  giamSatId: number;
  lyDo: string;
  moTa: string | null;
  trangThai: TrangThaiTranhChap;
  yeuCauHoanTien: string;
  ngayMo: string;
  ngayDong: string | null;
  bangChungs?: BangChungHoanTienDto[]; // Minh chứng từ Người thuê & Freelancer
  ketLuan: DisputeConclusionDto | null;
};

export type DisputeConclusionDto = {
  ketLuanId: number;
  giamSatId: number;
  ketQua: KetQuaTranhChap;
  lyDo: string;
  soTienHoan: string;
  soTienFreelancer: string;
  soTienGiamSat: string;
  soTienHeThong: string;
  benChiuPhi: BenChiuPhiKetLuan;
  ngayKetLuan: string;
  bangChungs?: BangChungKetLuanDto[];
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
  soTienFreelancer?: number;
  soTienGiamSat?: number;
  soTienHeThong?: number;
  benChiuPhi: BenChiuPhiKetLuan;
  bangChungArray?: BangChungCreateDto[]; // Tùy chọn (không bắt buộc)
};

export type DisputeMutationResponseDto = {
  message: string;
  dispute: DisputeDto;
};
