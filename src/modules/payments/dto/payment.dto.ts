import type {
  LoaiThanhToan,
  PhuongThucThanhToan,
  TrangThaiThanhToan,
} from '@prisma/client';

export type PaymentDto = {
  thanhToanId: number;
  congViecId: number;
  nguoiThueId: number;
  soTien: string;
  loaiTT: LoaiThanhToan;
  phuongThuc: PhuongThucThanhToan;
  trangThai: TrangThaiThanhToan;
  giamSatId: number | null;
  phiGiamSatTT: string;
  ghiChu: string | null;
  ngayTao: string;
};

export type PaymentsListResponseDto = {
  total: number;
  payments: PaymentDto[];
};

export type PaymentResponseDto = {
  payment: PaymentDto;
};

export type CreateDepositDto = {
  contractId: number;
  amount: number;
  paymentMethod: PhuongThucThanhToan;
  note?: string;
};

export type PaymentMutationResponseDto = {
  message: string;
  payment: PaymentDto;
};
