import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../../common/prisma/prisma.service';
import type {
  CreateDepositDto,
  PaymentDto,
  PaymentMutationResponseDto,
  PaymentResponseDto,
  PaymentsListResponseDto,
} from './dto';
import type { Prisma } from '@prisma/client';

const PAYMENT_SELECT = {
  ThanhToanID: true,
  CongViecID: true,
  TaiKhoanID: true,
  SoTien: true,
  LoaiTT: true,
  PhuongThuc: true,
  TrangThai: true,
  GhiChu: true,
  NgayTao: true,
} as const;

type PaymentEntity = Prisma.ThanhToanGetPayload<{
  select: typeof PAYMENT_SELECT;
}>;

@Injectable()
export class PaymentsService {
  constructor(private readonly prisma: PrismaService) {}

  async findById(id: number): Promise<PaymentResponseDto> {
    const payment = await this.prisma.thanhToan.findUnique({
      where: { ThanhToanID: id },
      select: PAYMENT_SELECT,
    });

    if (!payment) {
      throw new NotFoundException('Giao dich khong ton tai');
    }

    return { payment: this.toPaymentDto(payment) };
  }

  async findByContractId(contractId: number): Promise<PaymentsListResponseDto> {
    const payments = await this.prisma.thanhToan.findMany({
      where: { CongViecID: contractId },
      select: PAYMENT_SELECT,
      orderBy: { NgayTao: 'desc' },
    });

    return {
      total: payments.length,
      payments: payments.map((p) => this.toPaymentDto(p)),
    };
  }

  async deposit(payload: CreateDepositDto): Promise<PaymentMutationResponseDto> {
    const contract = await this.prisma.congViec.findUnique({
      where: { CongViecID: payload.contractId },
    });

    if (!contract) {
      throw new NotFoundException('Hop dong khong ton tai');
    }

    // In a real escrow, we would verify the payment with a gateway here
    const payment = await this.prisma.thanhToan.create({
      data: {
        CongViecID: payload.contractId,
        TaiKhoanID: contract.NguoiThueID,
        SoTien: payload.amount,
        LoaiTT: 'DatCoc',
        PhuongThuc: payload.paymentMethod,
        TrangThai: 'ThanhCong', // Assuming immediate success for this demo
        GhiChu: payload.note || 'Thanh toan dat coc',
      },
      select: PAYMENT_SELECT,
    });

    // Update contract status to DangThucHien if it was MoiTao
    if (contract.TrangThai === 'MoiTao') {
      await this.prisma.congViec.update({
        where: { CongViecID: payload.contractId },
        data: {
          TrangThai: 'DangThucHien',
          NgayBatDau: new Date(),
        },
      });
    }

    return {
      message: 'Dat coc thanh cong',
      payment: this.toPaymentDto(payment),
    };
  }

  async release(id: number): Promise<PaymentMutationResponseDto> {
    const depositPayment = await this.prisma.thanhToan.findUnique({
      where: { ThanhToanID: id },
      include: {
        CongViec: {
          include: {
            Freelancer: true,
          },
        },
      },
    });

    if (!depositPayment) {
      throw new NotFoundException('Giao dich dat coc khong ton tai');
    }

    if (depositPayment.LoaiTT !== 'DatCoc') {
      throw new BadRequestException('Chi co the giai ngan tu giao dich dat coc');
    }

    if (depositPayment.TrangThai !== 'ThanhCong') {
      throw new BadRequestException('Giao dich chua thanh cong, khong thể giai ngan');
    }

    const contract = depositPayment.CongViec;

    // 1. Calculate amounts
    // In this system, we'll assume the full GiaThoa is released
    const freelancerAmount = contract.GiaThoa;
    const supervisorAmount = contract.PhiGiamSat;

    // 2. Update Freelancer balance (FreelancerID is now TaiKhoanID)
    await this.prisma.freelancer.update({
      where: { TaiKhoanID: contract.FreelancerID },
      data: {
        SoDu: { increment: freelancerAmount },
      },
    });

    // 3. Create release record for Freelancer
    const releasePayment = await this.prisma.thanhToan.create({
      data: {
        CongViecID: contract.CongViecID,
        TaiKhoanID: contract.NguoiThueID,
        SoTien: freelancerAmount,
        LoaiTT: 'ThanhToanCuoi',
        PhuongThuc: 'Vi',
        TrangThai: 'ThanhCong',
        GhiChu: `Giai ngan cho freelancer: ${contract.FreelancerID}`,
      },
      select: PAYMENT_SELECT,
    });

    // 4. Handle Supervisor if any
    if (contract.GiamSatID && supervisorAmount.toNumber() > 0) {
      await this.prisma.thanhToan.create({
        data: {
          CongViecID: contract.CongViecID,
          TaiKhoanID: contract.NguoiThueID,
          SoTien: supervisorAmount,
          LoaiTT: 'PhiGiamSat',
          PhuongThuc: 'Vi',
          TrangThai: 'ThanhCong',
          GhiChu: `Thanh toan phi giam sat cho: ${contract.GiamSatID}`,
        },
      });
      
      // Note: If there was a DonViGiamSat balance, we'd update it here too.
    }

    // 5. Update contract status to HoanThanh
    await this.prisma.congViec.update({
      where: { CongViecID: contract.CongViecID },
      data: {
        TrangThai: 'HoanThanh',
        NgayKetThuc: new Date(),
      },
    });

    return {
      message: 'Giai ngan thanh cong',
      payment: this.toPaymentDto(releasePayment),
    };
  }

  async refund(id: number): Promise<PaymentMutationResponseDto> {
    const payment = await this.prisma.thanhToan.findUnique({
      where: { ThanhToanID: id },
    });

    if (!payment) {
      throw new NotFoundException('Giao dich khong ton tai');
    }

    if (payment.TrangThai === 'DaHoan') {
      throw new BadRequestException('Giao dich nay da duoc hoan tien');
    }

    // 1. Mark original payment as DaHoan
    await this.prisma.thanhToan.update({
      where: { ThanhToanID: id },
      data: { TrangThai: 'DaHoan' },
    });

    // 2. Create refund record
    const refundRecord = await this.prisma.thanhToan.create({
      data: {
        CongViecID: payment.CongViecID,
        TaiKhoanID: payment.TaiKhoanID,
        SoTien: payment.SoTien,
        LoaiTT: 'HoanTien',
        PhuongThuc: payment.PhuongThuc,
        TrangThai: 'ThanhCong',
        GhiChu: `Hoan tien cho giao dich: ${id}`,
      },
      select: PAYMENT_SELECT,
    });

    // 3. Update contract status to DaHuy if needed
    await this.prisma.congViec.update({
      where: { CongViecID: payment.CongViecID },
      data: {
        TrangThai: 'DaHuy',
        NgayKetThuc: new Date(),
      },
    });

    return {
      message: 'Hoan tien thanh cong',
      payment: this.toPaymentDto(refundRecord),
    };
  }

  private toPaymentDto(payment: PaymentEntity): PaymentDto {
    return {
      thanhToanId: payment.ThanhToanID,
      congViecId: payment.CongViecID,
      nguoiThueId: payment.TaiKhoanID,
      soTien: payment.SoTien.toString(),
      loaiTT: payment.LoaiTT,
      phuongThuc: payment.PhuongThuc,
      trangThai: payment.TrangThai,
      ghiChu: payment.GhiChu,
      ngayTao: payment.NgayTao.toISOString(),
    };
  }
}
