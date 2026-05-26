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
};

export type DecideRefundRequestDto = {
  freelancerId: number;
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
