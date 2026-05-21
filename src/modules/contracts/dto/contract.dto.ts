import type {
  TrangThaiCongViec,
  TrangThaiGiamSatCongViec,
} from '@prisma/client';

export type ContractDto = {
  congViecId: number;
  yeuCauId: number;
  freelancerId: number;
  nguoiThueId: number;
  giaThoa: string;
  thoiGianThoa: number;
  trangThai: TrangThaiCongViec;
  ngayBatDau: string | null;
  ngayKetThuc: string | null;
  giamSatId: number | null;
  trangThaiGiamSat: TrangThaiGiamSatCongViec;
  phiGiamSat: string;
  ngayTao: string;
};

export type ContractWithDetailsDto = ContractDto & {
  yeuCau: {
    yeuCauId: number;
    tieuDe: string;
    moTa: string;
  };
  freelancer: {
    freelancerId: number;
    taiKhoanId: number;
    hoTen: string;
    email: string;
  };
  nguoiThue: {
    nguoiThueId: number;
    taiKhoanId: number;
    hoTen: string;
    email: string;
  };
  giamSat: {
    giamSatId: number | null;
    tenDonVi: string;
  } | null;
};

export type ContractsListResponseDto = {
  total: number;
  contracts: ContractWithDetailsDto[];
};

export type ContractResponseDto = {
  contract: ContractWithDetailsDto;
};

export type CreateContractDto = {
  yeuCauId: number;
  freelancerId: number;
  nguoiThueId: number;
  giaThoa: number;
  thoiGianThoa: number;
};

export type UpdateContractStatusDto = {
  trangThai: TrangThaiCongViec;
};

export type ContractMutationResponseDto = {
  message: string;
  contract: ContractWithDetailsDto;
};

export type SelectSupervisorDto = {
  giamSatId: number;
  phiGiamSat: number;
};

export type SupervisorResponseDto = {
  message: string;
  yeuCauGiamSatId: number;
  trangThai: string;
};
