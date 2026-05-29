import type { TrangThaiYeuCauHoanTien } from '@prisma/client';

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
