import type { LoaiBangChung, TrangThaiYeuCauHoanTien } from '@prisma/client';

export type BangChungDto = {
  bangChungId: number;
  loaiBangChung: LoaiBangChung;
  noiDung: string | null;
  duongDanFile: string | null;
  nguoiNopId: number;
  ngayNop: string;
};

export type BangChungHoanTienDto = BangChungDto & {
  yeuCauHoanTienId: number;
  loaiNguoiNop: string; // "NguoiThue" | "Freelancer"
};

export type BangChungCreateDto = {
  loaiBangChung: LoaiBangChung;
  noiDung?: string;
  duongDanFile?: string;
};

export type RefundRequestDto = {
  refundRequestId: number;
  yeuCauHoanTienId: number;
  congViecId: number;
  nguoiThueId: number;
  freelancerId: number;
  lyDo: string;
  moTa: string | null;
  trangThai: TrangThaiYeuCauHoanTien;
  tongEscrow: string;
  phiHeThong: string;
  tienFreelancer: string;
  tienGiamSat: string;
  tienHoan: string;
  tranhChapId: number | null;
  ngayTao: string;
  ngayPhanHoi: string | null;
  bangChungs?: BangChungHoanTienDto[];
};

export type CreateRefundRequestDto = {
  congViecId: number;
  nguoiThueId: number;
  lyDo: string;
  moTa?: string;
  requestedRefundAmount?: number | string;
  tienHoan?: number | string;
  tienHoanYeuCau?: number | string;
  soTienYeuCau?: number | string;
  soTienHoanYeuCau?: number | string;
  yeuCauHoanTien?: number | string;
  soTienHoan?: number | string;
  refundAmount?: number | string;
  amount?: number | string;
  bangChungArray?: BangChungCreateDto[];
};

export type DecideRefundRequestDto = {
  freelancerId: number;
  requestedRefundAmount?: number | string;
  tienHoanYeuCau?: number | string;
  soTienYeuCau?: number | string;
  soTienHoanYeuCau?: number | string;
  yeuCauHoanTien?: number | string;
  soTienHoan?: number | string;
  refundAmount?: number | string;
  amount?: number | string;
  bangChungArray?: BangChungCreateDto[];
};

export type RefundRequestResponseDto = {
  refundRequest: RefundRequestDto;
};

export type RefundRequestListResponseDto = {
  total: number;
  refundRequests: RefundRequestDto[];
};

export type RefundSettlementDto = {
  tienHoanNguoiThue: string;
  tienFreelancer: string;
  tienGiamSat: string;
  phiHeThong: string;
};

export type RefundRequestMutationResponseDto = {
  message: string;
  refundRequest: RefundRequestDto;
  settlement?: RefundSettlementDto;
};
