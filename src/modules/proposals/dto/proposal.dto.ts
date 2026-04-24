import type { TrangThaiBaoGia } from '@prisma/client';

export type ProposalDto = {
  baoGiaId: number;
  yeuCauId: number;
  freelancerId: number;
  giaDeXuat: string;
  thoiGianThucHien: number;
  noiDung: string | null;
  trangThai: TrangThaiBaoGia;
  ngayTao: string;
  ngayCapNhat: string;
};

export type ProposalWithDetailsDto = ProposalDto & {
  freelancer: {
    freelancerId: number;
    taiKhoanId: number;
    hoTen: string;
    email: string;
    kinhNghiem: number;
    kyNang: string | null;
    xepHang: string;
  };
  yeuCau: {
    yeuCauId: number;
    tieuDe: string;
    nguoiThueId: number;
  };
};

export type ProposalsListResponseDto = {
  total: number;
  proposals: ProposalWithDetailsDto[];
};

export type ProposalResponseDto = {
  proposal: ProposalWithDetailsDto;
};

export type CreateProposalDto = {
  yeuCauId: number;
  freelancerId: number;
  giaDeXuat: number;
  thoiGianThucHien: number;
  noiDung?: string;
};

export type UpdateProposalDto = {
  giaDeXuat?: number;
  thoiGianThucHien?: number;
  noiDung?: string;
  trangThai?: TrangThaiBaoGia;
};

export type ProposalMutationResponseDto = {
  message: string;
  proposal: ProposalWithDetailsDto;
};

export type ProposalDeleteResponseDto = {
  message: string;
  proposalId: number;
};
