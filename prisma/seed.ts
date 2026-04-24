/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-argument */
/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */

import {
  PrismaClient,
  TrangThaiDonViGiamSat,
  TrangThaiTaiKhoan,
  VaiTroTaiKhoan,
} from '../src/generated/prisma';

const prisma = new PrismaClient();

async function upsertTaiKhoan() {
  const admin = await prisma.taiKhoan.upsert({
    where: { TenDangNhap: 'admin01' },
    update: {
      MatKhau: '$2b$10$xxx',
      Email: 'admin@fras.vn',
      HoTen: 'Quan Tri Vien',
      VaiTro: VaiTroTaiKhoan.Admin,
      TrangThai: TrangThaiTaiKhoan.HoatDong,
    },
    create: {
      TenDangNhap: 'admin01',
      MatKhau: '$2b$10$xxx',
      Email: 'admin@fras.vn',
      HoTen: 'Quan Tri Vien',
      VaiTro: VaiTroTaiKhoan.Admin,
      TrangThai: TrangThaiTaiKhoan.HoatDong,
    },
  });

  const client = await prisma.taiKhoan.upsert({
    where: { TenDangNhap: 'client01' },
    update: {
      MatKhau: '$2b$10$xxx',
      Email: 'client01@gmail.com',
      HoTen: 'Nguyen Van An',
      VaiTro: VaiTroTaiKhoan.NguoiThue,
      TrangThai: TrangThaiTaiKhoan.HoatDong,
    },
    create: {
      TenDangNhap: 'client01',
      MatKhau: '$2b$10$xxx',
      Email: 'client01@gmail.com',
      HoTen: 'Nguyen Van An',
      VaiTro: VaiTroTaiKhoan.NguoiThue,
      TrangThai: TrangThaiTaiKhoan.HoatDong,
    },
  });

  const freelancer = await prisma.taiKhoan.upsert({
    where: { TenDangNhap: 'freelancer01' },
    update: {
      MatKhau: '$2b$10$xxx',
      Email: 'free01@gmail.com',
      HoTen: 'Tran Thi Binh',
      VaiTro: VaiTroTaiKhoan.Freelancer,
      TrangThai: TrangThaiTaiKhoan.HoatDong,
    },
    create: {
      TenDangNhap: 'freelancer01',
      MatKhau: '$2b$10$xxx',
      Email: 'free01@gmail.com',
      HoTen: 'Tran Thi Binh',
      VaiTro: VaiTroTaiKhoan.Freelancer,
      TrangThai: TrangThaiTaiKhoan.HoatDong,
    },
  });

  const supervisor = await prisma.taiKhoan.upsert({
    where: { TenDangNhap: 'supervisor01' },
    update: {
      MatKhau: '$2b$10$xxx',
      Email: 'super01@company.vn',
      HoTen: 'Cong Ty Giam Sat ABC',
      VaiTro: VaiTroTaiKhoan.DonViGiamSat,
      TrangThai: TrangThaiTaiKhoan.HoatDong,
    },
    create: {
      TenDangNhap: 'supervisor01',
      MatKhau: '$2b$10$xxx',
      Email: 'super01@company.vn',
      HoTen: 'Cong Ty Giam Sat ABC',
      VaiTro: VaiTroTaiKhoan.DonViGiamSat,
      TrangThai: TrangThaiTaiKhoan.HoatDong,
    },
  });

  return { admin, client, freelancer, supervisor };
}

async function upsertProfiles(
  clientTaiKhoanId: number,
  freelancerTaiKhoanId: number,
  supervisorTaiKhoanId: number,
) {
  const existingNguoiThue = await prisma.nguoiThue.findFirst({
    where: { TaiKhoanID: clientTaiKhoanId },
    select: { NguoiThueID: true },
  });

  if (existingNguoiThue) {
    await prisma.nguoiThue.update({
      where: { NguoiThueID: existingNguoiThue.NguoiThueID },
      data: {
        CongTy: 'Startup ABC',
        MoTa: 'Can tuyen freelancer cho nhieu du an web',
      },
    });
  } else {
    await prisma.nguoiThue.create({
      data: {
        TaiKhoanID: clientTaiKhoanId,
        CongTy: 'Startup ABC',
        MoTa: 'Can tuyen freelancer cho nhieu du an web',
      },
    });
  }

  const existingFreelancer = await prisma.freelancer.findFirst({
    where: { TaiKhoanID: freelancerTaiKhoanId },
    select: { FreelancerID: true },
  });

  if (existingFreelancer) {
    await prisma.freelancer.update({
      where: { FreelancerID: existingFreelancer.FreelancerID },
      data: {
        KinhNghiem: 3,
        ChuyenGia: 'Lap trinh web',
        KyNang: '["React","NodeJS","MySQL"]',
      },
    });
  } else {
    await prisma.freelancer.create({
      data: {
        TaiKhoanID: freelancerTaiKhoanId,
        KinhNghiem: 3,
        ChuyenGia: 'Lap trinh web',
        KyNang: '["React","NodeJS","MySQL"]',
      },
    });
  }

  const existingSupervisor = await prisma.donViGiamSat.findFirst({
    where: { TaiKhoanID: supervisorTaiKhoanId },
    select: { GiamSatID: true },
  });

  if (existingSupervisor) {
    await prisma.donViGiamSat.update({
      where: { GiamSatID: existingSupervisor.GiamSatID },
      data: {
        TenDonVi: 'Cong Ty Giam Sat ABC',
        MoTa: 'Chuyen giam sat du an cong nghe',
        PhiGiamSat: 500000,
        TrangThai: TrangThaiDonViGiamSat.HoatDong,
      },
    });
  } else {
    await prisma.donViGiamSat.create({
      data: {
        TaiKhoanID: supervisorTaiKhoanId,
        TenDonVi: 'Cong Ty Giam Sat ABC',
        MoTa: 'Chuyen giam sat du an cong nghe',
        PhiGiamSat: 500000,
        TrangThai: TrangThaiDonViGiamSat.HoatDong,
      },
    });
  }
}

async function seedLoaiDichVu() {
  const rows = [
    { TenLoai: 'Lap trinh web', MoTa: 'Frontend, Backend, Fullstack' },
    { TenLoai: 'Thiet ke do hoa', MoTa: 'Logo, Banner, UI/UX' },
    { TenLoai: 'Marketing', MoTa: 'SEO, Social Media, Content' },
    { TenLoai: 'Phan tich du lieu', MoTa: 'Data Analysis, Machine Learning' },
    { TenLoai: 'Bien dich', MoTa: 'Dich thuat tai lieu da ngon ngu' },
  ];

  for (const row of rows) {
    const existing = await prisma.loaiDichVu.findFirst({
      where: { TenLoai: row.TenLoai },
      select: { LoaiDichVuID: true },
    });

    if (existing) {
      await prisma.loaiDichVu.update({
        where: { LoaiDichVuID: existing.LoaiDichVuID },
        data: row,
      });
    } else {
      await prisma.loaiDichVu.create({ data: row });
    }
  }
}

async function main() {
  await seedLoaiDichVu();
  const { client, freelancer, supervisor } = await upsertTaiKhoan();
  await upsertProfiles(
    client.TaiKhoanID,
    freelancer.TaiKhoanID,
    supervisor.TaiKhoanID,
  );
}

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (error) => {
    console.error(error);
    await prisma.$disconnect();
    process.exit(1);
  });
