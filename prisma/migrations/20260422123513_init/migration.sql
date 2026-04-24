-- CreateEnum
CREATE TYPE "GioiTinh" AS ENUM ('Nam', 'Nu', 'Khac');

-- CreateEnum
CREATE TYPE "VaiTroTaiKhoan" AS ENUM ('KhachVangLai', 'NguoiThue', 'Freelancer', 'DonViGiamSat', 'Admin');

-- CreateEnum
CREATE TYPE "TrangThaiTaiKhoan" AS ENUM ('HoatDong', 'BiKhoa', 'ChoDuyet', 'DaBi');

-- CreateEnum
CREATE TYPE "TrangThaiDonViGiamSat" AS ENUM ('HoatDong', 'TamNghi', 'BiKhoa', 'ChoDuyet');

-- CreateEnum
CREATE TYPE "TrangThaiYeuCau" AS ENUM ('MoDau', 'DangMo', 'DaDong', 'DaHuy', 'HoanThanh');

-- CreateEnum
CREATE TYPE "TrangThaiBaoGia" AS ENUM ('DaGui', 'DuocChon', 'TuChoi', 'HetHan');

-- CreateEnum
CREATE TYPE "TrangThaiCongViec" AS ENUM ('MoiTao', 'DangThucHien', 'HoanThanh', 'DaHuy', 'TranhChap');

-- CreateEnum
CREATE TYPE "TrangThaiGiamSatCongViec" AS ENUM ('KhongCo', 'ChoDuyet', 'DangGiamSat', 'HoanThanh', 'TuChoi');

-- CreateEnum
CREATE TYPE "TrangThaiYeuCauGiamSat" AS ENUM ('ChoDuyet', 'DaChapNhan', 'TuChoi', 'HoanThanh');

-- CreateEnum
CREATE TYPE "TrangThaiXacNhanTienDo" AS ENUM ('ChuaXacNhan', 'DaXacNhan', 'TuChoi');

-- CreateEnum
CREATE TYPE "TrangThaiTranhChap" AS ENUM ('MoiMo', 'DangXuLy', 'DaKetLuan', 'DaDong');

-- CreateEnum
CREATE TYPE "LoaiBangChung" AS ENUM ('TinNhan', 'File', 'HinhAnh', 'GhiChu', 'KhacP');

-- CreateEnum
CREATE TYPE "KetQuaTranhChap" AS ENUM ('TiepTuc', 'HoanTienNguoiThue', 'HuyHopDong', 'PhanChia');

-- CreateEnum
CREATE TYPE "BenChiuPhiKetLuan" AS ENUM ('NguoiThue', 'Freelancer', 'ChiaSe', 'HeThong');

-- CreateEnum
CREATE TYPE "LoaiThanhToan" AS ENUM ('DatCoc', 'ThanhToanCuoi', 'HoanTien', 'PhiGiamSat', 'PhiHeThong');

-- CreateEnum
CREATE TYPE "PhuongThucThanhToan" AS ENUM ('ChuyenKhoan', 'ThanhToanQuaMang', 'Vi', 'TienMat');

-- CreateEnum
CREATE TYPE "TrangThaiThanhToan" AS ENUM ('ChoXuLy', 'ThanhCong', 'ThatBai', 'DaHoan');

-- CreateEnum
CREATE TYPE "TrangThaiCuocHoiThoai" AS ENUM ('DangMo', 'DaDong');

-- CreateEnum
CREATE TYPE "LoaiTinNhan" AS ENUM ('VanBan', 'File', 'HinhAnh');

-- CreateEnum
CREATE TYPE "LoaiDanhGia" AS ENUM ('NguoiThue_DanhGia_Freelancer', 'Freelancer_DanhGia_NguoiThue', 'NguoiThue_DanhGia_GiamSat', 'Freelancer_DanhGia_GiamSat', 'GiamSat_DanhGia_Freelancer', 'GiamSat_DanhGia_NguoiThue');

-- CreateEnum
CREATE TYPE "LoaiThongBao" AS ENUM ('HeThong', 'YeuCau', 'BaoGia', 'CongViec', 'TranhChap', 'GiamSat', 'ThanhToan', 'DanhGia');

-- CreateEnum
CREATE TYPE "TrangThaiBaoCao" AS ENUM ('ChoXuLy', 'DangXuLy', 'DaXuLy', 'HuyBo');

-- CreateEnum
CREATE TYPE "LoaiGiamKhuyenMai" AS ENUM ('PhanTram', 'SoTienCo');

-- CreateEnum
CREATE TYPE "TrangThaiKhuyenMai" AS ENUM ('HoatDong', 'HetHan', 'ThuHoi');

-- CreateTable
CREATE TABLE "LoaiDichVu" (
    "LoaiDichVuID" SERIAL NOT NULL,
    "TenLoai" VARCHAR(100) NOT NULL,
    "MoTa" VARCHAR(255),
    "HinhAnh" VARCHAR(255),

    CONSTRAINT "LoaiDichVu_pkey" PRIMARY KEY ("LoaiDichVuID")
);

-- CreateTable
CREATE TABLE "TaiKhoan" (
    "TaiKhoanID" SERIAL NOT NULL,
    "TenDangNhap" VARCHAR(50) NOT NULL,
    "MatKhau" VARCHAR(255) NOT NULL,
    "Email" VARCHAR(100) NOT NULL,
    "HoTen" VARCHAR(100) NOT NULL,
    "SoDienThoai" VARCHAR(15),
    "GioiTinh" "GioiTinh",
    "DiaChi" VARCHAR(255),
    "VaiTro" "VaiTroTaiKhoan" NOT NULL DEFAULT 'KhachVangLai',
    "TrangThai" "TrangThaiTaiKhoan" NOT NULL DEFAULT 'HoatDong',
    "NgayTao" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "NgayCapNhat" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "TaiKhoan_pkey" PRIMARY KEY ("TaiKhoanID")
);

-- CreateTable
CREATE TABLE "NguoiThue" (
    "NguoiThueID" SERIAL NOT NULL,
    "TaiKhoanID" INTEGER NOT NULL,
    "CongTy" VARCHAR(150),
    "MoTa" TEXT,
    "DiemTinCay" DECIMAL(3,2) NOT NULL DEFAULT 0.00,
    "TongYeuCau" INTEGER NOT NULL DEFAULT 0,
    "TyLeHoanThanh" DECIMAL(5,2) NOT NULL DEFAULT 0.00,

    CONSTRAINT "NguoiThue_pkey" PRIMARY KEY ("NguoiThueID")
);

-- CreateTable
CREATE TABLE "Freelancer" (
    "FreelancerID" SERIAL NOT NULL,
    "TaiKhoanID" INTEGER NOT NULL,
    "KinhNghiem" INTEGER NOT NULL DEFAULT 0,
    "ChuyenGia" VARCHAR(150),
    "KyNang" TEXT,
    "XepHang" DECIMAL(3,2) NOT NULL DEFAULT 0.00,
    "SoDu" DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    "XacThucEmail" BOOLEAN NOT NULL DEFAULT false,
    "XacThucSDT" BOOLEAN NOT NULL DEFAULT false,
    "TongCongViec" INTEGER NOT NULL DEFAULT 0,
    "TyLeHoanThanh" DECIMAL(5,2) NOT NULL DEFAULT 0.00,

    CONSTRAINT "Freelancer_pkey" PRIMARY KEY ("FreelancerID")
);

-- CreateTable
CREATE TABLE "DonViGiamSat" (
    "GiamSatID" SERIAL NOT NULL,
    "TaiKhoanID" INTEGER NOT NULL,
    "TenDonVi" VARCHAR(150) NOT NULL,
    "MoTa" TEXT,
    "NangLuc" TEXT,
    "ChungChi" VARCHAR(255),
    "PhiGiamSat" DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    "XepHang" DECIMAL(3,2) NOT NULL DEFAULT 0.00,
    "TongCongViecGS" INTEGER NOT NULL DEFAULT 0,
    "TrangThai" "TrangThaiDonViGiamSat" NOT NULL DEFAULT 'ChoDuyet',
    "NgayDangKy" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "DonViGiamSat_pkey" PRIMARY KEY ("GiamSatID")
);

-- CreateTable
CREATE TABLE "YeuCau" (
    "YeuCauID" SERIAL NOT NULL,
    "NguoiThueID" INTEGER NOT NULL,
    "LoaiDichVuID" INTEGER NOT NULL,
    "TieuDe" VARCHAR(200) NOT NULL,
    "MoTa" TEXT NOT NULL,
    "NganSachMin" DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    "NganSachMax" DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    "ThoiHan" DATE NOT NULL,
    "TrangThai" "TrangThaiYeuCau" NOT NULL DEFAULT 'MoDau',
    "SoLuongBaoGia" INTEGER NOT NULL DEFAULT 0,
    "YeuCauGiamSat" BOOLEAN NOT NULL DEFAULT false,
    "NgayTao" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "NgayCapNhat" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "YeuCau_pkey" PRIMARY KEY ("YeuCauID")
);

-- CreateTable
CREATE TABLE "BaoGia" (
    "BaoGiaID" SERIAL NOT NULL,
    "YeuCauID" INTEGER NOT NULL,
    "FreelancerID" INTEGER NOT NULL,
    "GiaDeXuat" DECIMAL(15,2) NOT NULL,
    "ThoiGianThucHien" INTEGER NOT NULL,
    "NoiDung" TEXT,
    "TrangThai" "TrangThaiBaoGia" NOT NULL DEFAULT 'DaGui',
    "NgayTao" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "NgayCapNhat" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "BaoGia_pkey" PRIMARY KEY ("BaoGiaID")
);

-- CreateTable
CREATE TABLE "CongViec" (
    "CongViecID" SERIAL NOT NULL,
    "YeuCauID" INTEGER NOT NULL,
    "FreelancerID" INTEGER NOT NULL,
    "NguoiThueID" INTEGER NOT NULL,
    "GiaThoa" DECIMAL(15,2) NOT NULL,
    "ThoiGianThoa" INTEGER NOT NULL,
    "TrangThai" "TrangThaiCongViec" NOT NULL DEFAULT 'MoiTao',
    "NgayBatDau" TIMESTAMP(3),
    "NgayKetThuc" TIMESTAMP(3),
    "GiamSatID" INTEGER,
    "TrangThaiGiamSat" "TrangThaiGiamSatCongViec" NOT NULL DEFAULT 'KhongCo',
    "PhiGiamSat" DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    "NgayTao" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CongViec_pkey" PRIMARY KEY ("CongViecID")
);

-- CreateTable
CREATE TABLE "YeuCauGiamSat" (
    "YCGiamSatID" SERIAL NOT NULL,
    "CongViecID" INTEGER NOT NULL,
    "NguoiThueID" INTEGER NOT NULL,
    "GiamSatID" INTEGER NOT NULL,
    "FreelancerID" INTEGER NOT NULL,
    "TrangThai" "TrangThaiYeuCauGiamSat" NOT NULL DEFAULT 'ChoDuyet',
    "LyDoTuChoi" TEXT,
    "PhiGiamSatThoa" DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    "NgayYeuCau" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "NgayChapNhan" TIMESTAMP(3),
    "NgayHoanThanh" TIMESTAMP(3),

    CONSTRAINT "YeuCauGiamSat_pkey" PRIMARY KEY ("YCGiamSatID")
);

-- CreateTable
CREATE TABLE "TienDo" (
    "TienDoID" SERIAL NOT NULL,
    "CongViecID" INTEGER NOT NULL,
    "FreelancerID" INTEGER NOT NULL,
    "TieuDe" VARCHAR(200) NOT NULL,
    "MoTa" TEXT,
    "PhanTram" SMALLINT NOT NULL DEFAULT 0,
    "TepDinhKem" VARCHAR(500),
    "XacNhanBoi" INTEGER,
    "TrangThaiXacNhan" "TrangThaiXacNhanTienDo" NOT NULL DEFAULT 'ChuaXacNhan',
    "NgayTao" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "TienDo_pkey" PRIMARY KEY ("TienDoID")
);

-- CreateTable
CREATE TABLE "TranhChap" (
    "TranhChapID" SERIAL NOT NULL,
    "CongViecID" INTEGER NOT NULL,
    "NguoiGuiID" INTEGER NOT NULL,
    "GiamSatID" INTEGER,
    "LyDo" VARCHAR(255) NOT NULL,
    "MoTa" TEXT,
    "TrangThai" "TrangThaiTranhChap" NOT NULL DEFAULT 'MoiMo',
    "YeuCauHoanTien" DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    "NgayMo" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "NgayDong" TIMESTAMP(3),

    CONSTRAINT "TranhChap_pkey" PRIMARY KEY ("TranhChapID")
);

-- CreateTable
CREATE TABLE "BangChungTranhChap" (
    "BangChungID" SERIAL NOT NULL,
    "TranhChapID" INTEGER NOT NULL,
    "NguoiNopID" INTEGER NOT NULL,
    "GiamSatID" INTEGER,
    "LoaiBangChung" "LoaiBangChung" NOT NULL DEFAULT 'GhiChu',
    "NoiDung" TEXT,
    "DuongDanFile" VARCHAR(500),
    "NgayNop" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "BangChungTranhChap_pkey" PRIMARY KEY ("BangChungID")
);

-- CreateTable
CREATE TABLE "KetLuanTranhChap" (
    "KetLuanID" SERIAL NOT NULL,
    "TranhChapID" INTEGER NOT NULL,
    "GiamSatID" INTEGER NOT NULL,
    "KetQua" "KetQuaTranhChap" NOT NULL,
    "LyDo" TEXT NOT NULL,
    "SoTienHoan" DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    "BenChiuPhi" "BenChiuPhiKetLuan" NOT NULL DEFAULT 'ChiaSe',
    "NgayKetLuan" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "KetLuanTranhChap_pkey" PRIMARY KEY ("KetLuanID")
);

-- CreateTable
CREATE TABLE "ThanhToan" (
    "ThanhToanID" SERIAL NOT NULL,
    "CongViecID" INTEGER NOT NULL,
    "NguoiThueID" INTEGER NOT NULL,
    "SoTien" DECIMAL(15,2) NOT NULL,
    "LoaiTT" "LoaiThanhToan" NOT NULL,
    "PhuongThuc" "PhuongThucThanhToan" NOT NULL DEFAULT 'Vi',
    "TrangThai" "TrangThaiThanhToan" NOT NULL DEFAULT 'ChoXuLy',
    "GiamSatID" INTEGER,
    "PhiGiamSatTT" DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    "GhiChu" VARCHAR(255),
    "NgayTao" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ThanhToan_pkey" PRIMARY KEY ("ThanhToanID")
);

-- CreateTable
CREATE TABLE "CuocHoiThoai" (
    "CuocHoiThoaiID" SERIAL NOT NULL,
    "CongViecID" INTEGER,
    "ThanhVien1ID" INTEGER NOT NULL,
    "ThanhVien2ID" INTEGER NOT NULL,
    "GiamSatID" INTEGER,
    "TinNhanCuoi" TIMESTAMP(3),
    "TrangThai" "TrangThaiCuocHoiThoai" NOT NULL DEFAULT 'DangMo',
    "NgayTao" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CuocHoiThoai_pkey" PRIMARY KEY ("CuocHoiThoaiID")
);

-- CreateTable
CREATE TABLE "TinNhan" (
    "TinNhanID" SERIAL NOT NULL,
    "CuocHoiThoaiID" INTEGER NOT NULL,
    "NguoiGuiID" INTEGER NOT NULL,
    "NoiDung" TEXT NOT NULL,
    "LoaiTin" "LoaiTinNhan" NOT NULL DEFAULT 'VanBan',
    "DaDoc" BOOLEAN NOT NULL DEFAULT false,
    "NgayTao" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "TinNhan_pkey" PRIMARY KEY ("TinNhanID")
);

-- CreateTable
CREATE TABLE "DanhGia" (
    "DanhGiaID" SERIAL NOT NULL,
    "CongViecID" INTEGER NOT NULL,
    "NguoiDanhGiaID" INTEGER NOT NULL,
    "NguoiDuocDGID" INTEGER NOT NULL,
    "DiemSo" SMALLINT NOT NULL,
    "BinhLuan" TEXT,
    "LoaiDanhGia" "LoaiDanhGia" NOT NULL,
    "GiamSatID" INTEGER,
    "NgayTao" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "DanhGia_pkey" PRIMARY KEY ("DanhGiaID")
);

-- CreateTable
CREATE TABLE "ThongBao" (
    "ThongBaoID" SERIAL NOT NULL,
    "TaiKhoanID" INTEGER NOT NULL,
    "TieuDe" VARCHAR(200) NOT NULL,
    "NoiDung" TEXT,
    "LoaiThongBao" "LoaiThongBao" NOT NULL DEFAULT 'HeThong',
    "DaDoc" BOOLEAN NOT NULL DEFAULT false,
    "GiamSatID" INTEGER,
    "NgayTao" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ThongBao_pkey" PRIMARY KEY ("ThongBaoID")
);

-- CreateTable
CREATE TABLE "BaoCao" (
    "BaoCaoID" SERIAL NOT NULL,
    "NguoiBaoCaoID" INTEGER NOT NULL,
    "NguoiBiCaoID" INTEGER NOT NULL,
    "LyDo" VARCHAR(255) NOT NULL,
    "MoTa" TEXT,
    "TrangThai" "TrangThaiBaoCao" NOT NULL DEFAULT 'ChoXuLy',
    "KetQua" TEXT,
    "AdminXuLyID" INTEGER,
    "NgayTao" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "NgayXuLy" TIMESTAMP(3),

    CONSTRAINT "BaoCao_pkey" PRIMARY KEY ("BaoCaoID")
);

-- CreateTable
CREATE TABLE "KhuyenMai" (
    "KhuyenMaiID" SERIAL NOT NULL,
    "MaCode" VARCHAR(50) NOT NULL,
    "LoaiGiam" "LoaiGiamKhuyenMai" NOT NULL,
    "GiaTriGiam" DECIMAL(15,2) NOT NULL,
    "GiaTriToiDa" DECIMAL(15,2),
    "SoLuotDung" INTEGER NOT NULL DEFAULT 0,
    "GioiHanLuot" INTEGER,
    "TrangThai" "TrangThaiKhuyenMai" NOT NULL DEFAULT 'HoatDong',
    "NgayBatDau" TIMESTAMP(3) NOT NULL,
    "NgayKetThuc" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "KhuyenMai_pkey" PRIMARY KEY ("KhuyenMaiID")
);

-- CreateIndex
CREATE UNIQUE INDEX "uq_tendangnhap" ON "TaiKhoan"("TenDangNhap");

-- CreateIndex
CREATE UNIQUE INDEX "uq_email" ON "TaiKhoan"("Email");

-- CreateIndex
CREATE INDEX "NguoiThue_TaiKhoanID_idx" ON "NguoiThue"("TaiKhoanID");

-- CreateIndex
CREATE INDEX "Freelancer_TaiKhoanID_idx" ON "Freelancer"("TaiKhoanID");

-- CreateIndex
CREATE INDEX "DonViGiamSat_TaiKhoanID_idx" ON "DonViGiamSat"("TaiKhoanID");

-- CreateIndex
CREATE INDEX "idx_yeucau_nguoithue" ON "YeuCau"("NguoiThueID");

-- CreateIndex
CREATE INDEX "idx_yeucau_trangthai" ON "YeuCau"("TrangThai");

-- CreateIndex
CREATE INDEX "YeuCau_LoaiDichVuID_idx" ON "YeuCau"("LoaiDichVuID");

-- CreateIndex
CREATE INDEX "idx_baogia_yeucau" ON "BaoGia"("YeuCauID");

-- CreateIndex
CREATE INDEX "BaoGia_FreelancerID_idx" ON "BaoGia"("FreelancerID");

-- CreateIndex
CREATE INDEX "CongViec_YeuCauID_idx" ON "CongViec"("YeuCauID");

-- CreateIndex
CREATE INDEX "CongViec_FreelancerID_idx" ON "CongViec"("FreelancerID");

-- CreateIndex
CREATE INDEX "CongViec_NguoiThueID_idx" ON "CongViec"("NguoiThueID");

-- CreateIndex
CREATE INDEX "idx_congviec_trangthai" ON "CongViec"("TrangThai");

-- CreateIndex
CREATE INDEX "idx_congviec_giamsat" ON "CongViec"("GiamSatID");

-- CreateIndex
CREATE INDEX "YeuCauGiamSat_CongViecID_idx" ON "YeuCauGiamSat"("CongViecID");

-- CreateIndex
CREATE INDEX "YeuCauGiamSat_NguoiThueID_idx" ON "YeuCauGiamSat"("NguoiThueID");

-- CreateIndex
CREATE INDEX "YeuCauGiamSat_GiamSatID_idx" ON "YeuCauGiamSat"("GiamSatID");

-- CreateIndex
CREATE INDEX "YeuCauGiamSat_FreelancerID_idx" ON "YeuCauGiamSat"("FreelancerID");

-- CreateIndex
CREATE INDEX "idx_tiendo_congviec" ON "TienDo"("CongViecID");

-- CreateIndex
CREATE INDEX "TienDo_FreelancerID_idx" ON "TienDo"("FreelancerID");

-- CreateIndex
CREATE INDEX "TienDo_XacNhanBoi_idx" ON "TienDo"("XacNhanBoi");

-- CreateIndex
CREATE INDEX "idx_tranhchap_cv" ON "TranhChap"("CongViecID");

-- CreateIndex
CREATE INDEX "idx_tranhchap_gs" ON "TranhChap"("GiamSatID");

-- CreateIndex
CREATE INDEX "TranhChap_NguoiGuiID_idx" ON "TranhChap"("NguoiGuiID");

-- CreateIndex
CREATE INDEX "BangChungTranhChap_TranhChapID_idx" ON "BangChungTranhChap"("TranhChapID");

-- CreateIndex
CREATE INDEX "BangChungTranhChap_NguoiNopID_idx" ON "BangChungTranhChap"("NguoiNopID");

-- CreateIndex
CREATE INDEX "BangChungTranhChap_GiamSatID_idx" ON "BangChungTranhChap"("GiamSatID");

-- CreateIndex
CREATE UNIQUE INDEX "uq_tranhchap" ON "KetLuanTranhChap"("TranhChapID");

-- CreateIndex
CREATE INDEX "KetLuanTranhChap_GiamSatID_idx" ON "KetLuanTranhChap"("GiamSatID");

-- CreateIndex
CREATE INDEX "ThanhToan_CongViecID_idx" ON "ThanhToan"("CongViecID");

-- CreateIndex
CREATE INDEX "ThanhToan_NguoiThueID_idx" ON "ThanhToan"("NguoiThueID");

-- CreateIndex
CREATE INDEX "ThanhToan_GiamSatID_idx" ON "ThanhToan"("GiamSatID");

-- CreateIndex
CREATE INDEX "CuocHoiThoai_CongViecID_idx" ON "CuocHoiThoai"("CongViecID");

-- CreateIndex
CREATE INDEX "CuocHoiThoai_ThanhVien1ID_idx" ON "CuocHoiThoai"("ThanhVien1ID");

-- CreateIndex
CREATE INDEX "CuocHoiThoai_ThanhVien2ID_idx" ON "CuocHoiThoai"("ThanhVien2ID");

-- CreateIndex
CREATE INDEX "CuocHoiThoai_GiamSatID_idx" ON "CuocHoiThoai"("GiamSatID");

-- CreateIndex
CREATE INDEX "idx_tinhan_cuoc" ON "TinNhan"("CuocHoiThoaiID");

-- CreateIndex
CREATE INDEX "TinNhan_NguoiGuiID_idx" ON "TinNhan"("NguoiGuiID");

-- CreateIndex
CREATE INDEX "DanhGia_CongViecID_idx" ON "DanhGia"("CongViecID");

-- CreateIndex
CREATE INDEX "DanhGia_NguoiDanhGiaID_idx" ON "DanhGia"("NguoiDanhGiaID");

-- CreateIndex
CREATE INDEX "DanhGia_NguoiDuocDGID_idx" ON "DanhGia"("NguoiDuocDGID");

-- CreateIndex
CREATE INDEX "DanhGia_GiamSatID_idx" ON "DanhGia"("GiamSatID");

-- CreateIndex
CREATE INDEX "idx_danhgia_loai" ON "DanhGia"("LoaiDanhGia");

-- CreateIndex
CREATE INDEX "idx_thongbao_taikhoan" ON "ThongBao"("TaiKhoanID", "DaDoc");

-- CreateIndex
CREATE INDEX "ThongBao_GiamSatID_idx" ON "ThongBao"("GiamSatID");

-- CreateIndex
CREATE INDEX "BaoCao_NguoiBaoCaoID_idx" ON "BaoCao"("NguoiBaoCaoID");

-- CreateIndex
CREATE INDEX "BaoCao_NguoiBiCaoID_idx" ON "BaoCao"("NguoiBiCaoID");

-- CreateIndex
CREATE INDEX "BaoCao_AdminXuLyID_idx" ON "BaoCao"("AdminXuLyID");

-- CreateIndex
CREATE UNIQUE INDEX "uq_macode" ON "KhuyenMai"("MaCode");

-- AddForeignKey
ALTER TABLE "NguoiThue" ADD CONSTRAINT "NguoiThue_TaiKhoanID_fkey" FOREIGN KEY ("TaiKhoanID") REFERENCES "TaiKhoan"("TaiKhoanID") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Freelancer" ADD CONSTRAINT "Freelancer_TaiKhoanID_fkey" FOREIGN KEY ("TaiKhoanID") REFERENCES "TaiKhoan"("TaiKhoanID") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DonViGiamSat" ADD CONSTRAINT "DonViGiamSat_TaiKhoanID_fkey" FOREIGN KEY ("TaiKhoanID") REFERENCES "TaiKhoan"("TaiKhoanID") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "YeuCau" ADD CONSTRAINT "YeuCau_NguoiThueID_fkey" FOREIGN KEY ("NguoiThueID") REFERENCES "NguoiThue"("NguoiThueID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "YeuCau" ADD CONSTRAINT "YeuCau_LoaiDichVuID_fkey" FOREIGN KEY ("LoaiDichVuID") REFERENCES "LoaiDichVu"("LoaiDichVuID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BaoGia" ADD CONSTRAINT "BaoGia_YeuCauID_fkey" FOREIGN KEY ("YeuCauID") REFERENCES "YeuCau"("YeuCauID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BaoGia" ADD CONSTRAINT "BaoGia_FreelancerID_fkey" FOREIGN KEY ("FreelancerID") REFERENCES "Freelancer"("FreelancerID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CongViec" ADD CONSTRAINT "CongViec_YeuCauID_fkey" FOREIGN KEY ("YeuCauID") REFERENCES "YeuCau"("YeuCauID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CongViec" ADD CONSTRAINT "CongViec_FreelancerID_fkey" FOREIGN KEY ("FreelancerID") REFERENCES "Freelancer"("FreelancerID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CongViec" ADD CONSTRAINT "CongViec_NguoiThueID_fkey" FOREIGN KEY ("NguoiThueID") REFERENCES "NguoiThue"("NguoiThueID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CongViec" ADD CONSTRAINT "CongViec_GiamSatID_fkey" FOREIGN KEY ("GiamSatID") REFERENCES "DonViGiamSat"("GiamSatID") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "YeuCauGiamSat" ADD CONSTRAINT "YeuCauGiamSat_CongViecID_fkey" FOREIGN KEY ("CongViecID") REFERENCES "CongViec"("CongViecID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "YeuCauGiamSat" ADD CONSTRAINT "YeuCauGiamSat_NguoiThueID_fkey" FOREIGN KEY ("NguoiThueID") REFERENCES "NguoiThue"("NguoiThueID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "YeuCauGiamSat" ADD CONSTRAINT "YeuCauGiamSat_GiamSatID_fkey" FOREIGN KEY ("GiamSatID") REFERENCES "DonViGiamSat"("GiamSatID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "YeuCauGiamSat" ADD CONSTRAINT "YeuCauGiamSat_FreelancerID_fkey" FOREIGN KEY ("FreelancerID") REFERENCES "Freelancer"("FreelancerID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TienDo" ADD CONSTRAINT "TienDo_CongViecID_fkey" FOREIGN KEY ("CongViecID") REFERENCES "CongViec"("CongViecID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TienDo" ADD CONSTRAINT "TienDo_FreelancerID_fkey" FOREIGN KEY ("FreelancerID") REFERENCES "Freelancer"("FreelancerID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TienDo" ADD CONSTRAINT "TienDo_XacNhanBoi_fkey" FOREIGN KEY ("XacNhanBoi") REFERENCES "DonViGiamSat"("GiamSatID") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TranhChap" ADD CONSTRAINT "TranhChap_CongViecID_fkey" FOREIGN KEY ("CongViecID") REFERENCES "CongViec"("CongViecID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TranhChap" ADD CONSTRAINT "TranhChap_NguoiGuiID_fkey" FOREIGN KEY ("NguoiGuiID") REFERENCES "TaiKhoan"("TaiKhoanID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TranhChap" ADD CONSTRAINT "TranhChap_GiamSatID_fkey" FOREIGN KEY ("GiamSatID") REFERENCES "DonViGiamSat"("GiamSatID") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BangChungTranhChap" ADD CONSTRAINT "BangChungTranhChap_TranhChapID_fkey" FOREIGN KEY ("TranhChapID") REFERENCES "TranhChap"("TranhChapID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BangChungTranhChap" ADD CONSTRAINT "BangChungTranhChap_NguoiNopID_fkey" FOREIGN KEY ("NguoiNopID") REFERENCES "TaiKhoan"("TaiKhoanID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BangChungTranhChap" ADD CONSTRAINT "BangChungTranhChap_GiamSatID_fkey" FOREIGN KEY ("GiamSatID") REFERENCES "DonViGiamSat"("GiamSatID") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "KetLuanTranhChap" ADD CONSTRAINT "KetLuanTranhChap_TranhChapID_fkey" FOREIGN KEY ("TranhChapID") REFERENCES "TranhChap"("TranhChapID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "KetLuanTranhChap" ADD CONSTRAINT "KetLuanTranhChap_GiamSatID_fkey" FOREIGN KEY ("GiamSatID") REFERENCES "DonViGiamSat"("GiamSatID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ThanhToan" ADD CONSTRAINT "ThanhToan_CongViecID_fkey" FOREIGN KEY ("CongViecID") REFERENCES "CongViec"("CongViecID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ThanhToan" ADD CONSTRAINT "ThanhToan_NguoiThueID_fkey" FOREIGN KEY ("NguoiThueID") REFERENCES "NguoiThue"("NguoiThueID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ThanhToan" ADD CONSTRAINT "ThanhToan_GiamSatID_fkey" FOREIGN KEY ("GiamSatID") REFERENCES "DonViGiamSat"("GiamSatID") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CuocHoiThoai" ADD CONSTRAINT "CuocHoiThoai_CongViecID_fkey" FOREIGN KEY ("CongViecID") REFERENCES "CongViec"("CongViecID") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CuocHoiThoai" ADD CONSTRAINT "CuocHoiThoai_ThanhVien1ID_fkey" FOREIGN KEY ("ThanhVien1ID") REFERENCES "TaiKhoan"("TaiKhoanID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CuocHoiThoai" ADD CONSTRAINT "CuocHoiThoai_ThanhVien2ID_fkey" FOREIGN KEY ("ThanhVien2ID") REFERENCES "TaiKhoan"("TaiKhoanID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CuocHoiThoai" ADD CONSTRAINT "CuocHoiThoai_GiamSatID_fkey" FOREIGN KEY ("GiamSatID") REFERENCES "DonViGiamSat"("GiamSatID") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TinNhan" ADD CONSTRAINT "TinNhan_CuocHoiThoaiID_fkey" FOREIGN KEY ("CuocHoiThoaiID") REFERENCES "CuocHoiThoai"("CuocHoiThoaiID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TinNhan" ADD CONSTRAINT "TinNhan_NguoiGuiID_fkey" FOREIGN KEY ("NguoiGuiID") REFERENCES "TaiKhoan"("TaiKhoanID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DanhGia" ADD CONSTRAINT "DanhGia_CongViecID_fkey" FOREIGN KEY ("CongViecID") REFERENCES "CongViec"("CongViecID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DanhGia" ADD CONSTRAINT "DanhGia_NguoiDanhGiaID_fkey" FOREIGN KEY ("NguoiDanhGiaID") REFERENCES "TaiKhoan"("TaiKhoanID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DanhGia" ADD CONSTRAINT "DanhGia_NguoiDuocDGID_fkey" FOREIGN KEY ("NguoiDuocDGID") REFERENCES "TaiKhoan"("TaiKhoanID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DanhGia" ADD CONSTRAINT "DanhGia_GiamSatID_fkey" FOREIGN KEY ("GiamSatID") REFERENCES "DonViGiamSat"("GiamSatID") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ThongBao" ADD CONSTRAINT "ThongBao_TaiKhoanID_fkey" FOREIGN KEY ("TaiKhoanID") REFERENCES "TaiKhoan"("TaiKhoanID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ThongBao" ADD CONSTRAINT "ThongBao_GiamSatID_fkey" FOREIGN KEY ("GiamSatID") REFERENCES "DonViGiamSat"("GiamSatID") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BaoCao" ADD CONSTRAINT "BaoCao_NguoiBaoCaoID_fkey" FOREIGN KEY ("NguoiBaoCaoID") REFERENCES "TaiKhoan"("TaiKhoanID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BaoCao" ADD CONSTRAINT "BaoCao_NguoiBiCaoID_fkey" FOREIGN KEY ("NguoiBiCaoID") REFERENCES "TaiKhoan"("TaiKhoanID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BaoCao" ADD CONSTRAINT "BaoCao_AdminXuLyID_fkey" FOREIGN KEY ("AdminXuLyID") REFERENCES "TaiKhoan"("TaiKhoanID") ON DELETE SET NULL ON UPDATE CASCADE;
