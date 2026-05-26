export type AcceptProposalDto = {
  baoGiaId: number;
  nguoiThueId: number;
  phiGiamSat?: number;
};

export type AcceptProposalResponseDto = {
  message: string;
  congViecId: number;
  escrow: {
    giaThoa: string;
    phiGiamSat: string;
    tongThanhToan: string;
    thanhToanId: number;
  };
};

export type ConfirmCompletionDto = {
  congViecId: number;
  /** Who is confirming: 'Freelancer' | 'GiamSat' | 'NguoiThue' */
  role: 'Freelancer' | 'GiamSat' | 'NguoiThue';
  userId: number;
};

export type ConfirmCompletionResponseDto = {
  message: string;
  congViecId: number;
  freelancerXacNhan: boolean;
  giamSatXacNhan: boolean;
  nguoiThueXacNhan: boolean;
  /** true if all parties confirmed and payment released */
  released: boolean;
  disbursement?: {
    freelancerNhan: string;
    giamSatNhan: string;
    phiHeThong: string;
  };
};
