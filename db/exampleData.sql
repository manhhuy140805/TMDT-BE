-- Sample seed data for PostgreSQL (Prisma schema)
-- Run after migration init.

BEGIN;

-- Xoa du lieu tat ca bang truoc khi insert du lieu mau.
TRUNCATE TABLE
	"BangChungTranhChap",
	"BaoCao",
	"BaoGia",
	"CongViec",
	"CuocHoiThoai",
	"DanhGia",
	"DonViGiamSat",
	"Freelancer",
	"KetLuanTranhChap",
	"KhuyenMai",
	"LoaiDichVu",
	"NguoiThue",
	"TaiKhoan",
	"ThanhToan",
	"ThongBao",
	"TienDo",
	"TinNhan",
	"TranhChap",
	"YeuCau",
	"YeuCauGiamSat"
RESTART IDENTITY CASCADE;

INSERT INTO "LoaiDichVu" ("LoaiDichVuID", "TenLoai", "MoTa", "HinhAnh")
VALUES
	(1, 'Thiet ke UI/UX', 'Thiet ke giao dien web va mobile', 'uiux.png'),
	(2, 'Lap trinh backend', 'Phat trien API, he thong nghiep vu', 'backend.png'),
	(3, 'Digital marketing', 'SEO, quang cao, social media', 'marketing.png')
ON CONFLICT ("LoaiDichVuID") DO NOTHING;

INSERT INTO "TaiKhoan"
	("TaiKhoanID", "TenDangNhap", "MatKhau", "Email", "HoTen", "SoDienThoai", "GioiTinh", "DiaChi", "VaiTro", "TrangThai", "NgayTao", "NgayCapNhat")
VALUES
	(1, 'thue_an', '123123', 'an@example.com', 'Nguyen Van An', '0901000001', 'Nam', 'Ha Noi', 'NguoiThue', 'HoatDong', '2026-04-18 08:00:00', '2026-04-22 09:00:00'),
	(2, 'thue_binh', '123123', 'binh@example.com', 'Tran Thi Binh', '0901000002', 'Nu', 'Da Nang', 'NguoiThue', 'HoatDong', '2026-04-18 08:10:00', '2026-04-22 09:05:00'),
	(3, 'free_cuong', '123123', 'cuong@example.com', 'Le Quang Cuong', '0901000003', 'Nam', 'TP HCM', 'Freelancer', 'HoatDong', '2026-04-18 08:20:00', '2026-04-22 09:10:00'),
	(4, 'free_duong', '123123', 'duong@example.com', 'Pham Minh Duong', '0901000004', 'Nam', 'Can Tho', 'Freelancer', 'HoatDong', '2026-04-18 08:30:00', '2026-04-22 09:15:00'),
	(5, 'gs_eagle', '123123', 'eagle@example.com', 'Eagle Supervision', '0901000005', 'Khac', 'Ha Noi', 'DonViGiamSat', 'HoatDong', '2026-04-18 08:40:00', '2026-04-22 09:20:00'),
	(6, 'admin_root', '123123', 'admin@example.com', 'System Admin', '0901000006', 'Khac', 'Ha Noi', 'Admin', 'HoatDong', '2026-04-18 08:50:00', '2026-04-22 09:25:00')
ON CONFLICT ("TaiKhoanID") DO NOTHING;

INSERT INTO "NguoiThue"
	("NguoiThueID", "TaiKhoanID", "CongTy", "MoTa", "DiemTinCay", "TongYeuCau", "TyLeHoanThanh")
VALUES
	(1, 1, 'An Tech Co', 'Can thue doi tac lam website', 4.60, 5, 80.00),
	(2, 2, 'Binh Trade', 'Can backend va SEO cho he thong ban hang', 4.40, 3, 66.67)
ON CONFLICT ("NguoiThueID") DO NOTHING;

INSERT INTO "Freelancer"
	("FreelancerID", "TaiKhoanID", "KinhNghiem", "ChuyenGia", "KyNang", "XepHang", "SoDu", "XacThucEmail", "XacThucSDT", "TongCongViec", "TyLeHoanThanh")
VALUES
	(1, 3, 5, 'Frontend Engineer', 'React, Next.js, UI/UX', 4.80, 12000000.00, true, true, 22, 90.00),
	(2, 4, 4, 'Backend Engineer', 'NestJS, PostgreSQL, Redis', 4.55, 8300000.00, true, true, 17, 85.00)
ON CONFLICT ("FreelancerID") DO NOTHING;

INSERT INTO "DonViGiamSat"
	("GiamSatID", "TaiKhoanID", "TenDonVi", "MoTa", "NangLuc", "ChungChi", "PhiGiamSat", "XepHang", "TongCongViecGS", "TrangThai", "NgayDangKy")
VALUES
	(1, 5, 'Eagle Supervisors', 'Don vi giam sat tien do va chat luong', 'Kiem thu, quy trinh, bao cao', 'ISO-9001', 500000.00, 4.70, 40, 'HoatDong', '2026-04-10 09:00:00')
ON CONFLICT ("GiamSatID") DO NOTHING;

INSERT INTO "YeuCau"
	("YeuCauID", "NguoiThueID", "LoaiDichVuID", "TieuDe", "MoTa", "NganSachMin", "NganSachMax", "ThoiHan", "TrangThai", "SoLuongBaoGia", "YeuCauGiamSat", "NgayTao", "NgayCapNhat")
VALUES
	(1, 1, 1, 'Thiet ke landing page', 'Can thiet ke landing page cho chien dich moi', 5000000.00, 9000000.00, '2026-05-10', 'DangMo', 2, true, '2026-04-19 10:00:00', '2026-04-22 10:00:00'),
	(2, 2, 2, 'Xay dung API NestJS', 'Can xay dung API quan ly don hang va thanh toan', 25000000.00, 40000000.00, '2026-06-01', 'DangMo', 1, false, '2026-04-19 10:10:00', '2026-04-22 10:05:00'),
	(3, 1, 3, 'SEO tong the website', 'Toi uu SEO on-page va technical SEO', 8000000.00, 15000000.00, '2026-06-15', 'MoDau', 1, false, '2026-04-19 10:20:00', '2026-04-22 10:10:00')
ON CONFLICT ("YeuCauID") DO NOTHING;

INSERT INTO "BaoGia"
	("BaoGiaID", "YeuCauID", "FreelancerID", "GiaDeXuat", "ThoiGianThucHien", "NoiDung", "TrangThai", "NgayTao", "NgayCapNhat")
VALUES
	(1, 1, 1, 7000000.00, 7, 'De xuat giao dien hien dai, responsive', 'DuocChon', '2026-04-20 08:00:00', '2026-04-22 10:20:00'),
	(2, 1, 2, 7600000.00, 9, 'De xuat ket hop design system', 'TuChoi', '2026-04-20 08:10:00', '2026-04-22 10:25:00'),
	(3, 2, 2, 30000000.00, 30, 'API + auth + docs + deployment', 'DuocChon', '2026-04-20 08:20:00', '2026-04-22 10:30:00'),
	(4, 3, 1, 10000000.00, 21, 'SEO audit va roadmap 3 thang', 'DaGui', '2026-04-20 08:30:00', '2026-04-22 10:35:00')
ON CONFLICT ("BaoGiaID") DO NOTHING;

INSERT INTO "CongViec"
	("CongViecID", "YeuCauID", "FreelancerID", "NguoiThueID", "GiaThoa", "ThoiGianThoa", "TrangThai", "NgayBatDau", "NgayKetThuc", "GiamSatID", "TrangThaiGiamSat", "PhiGiamSat", "NgayTao")
VALUES
	(1, 1, 1, 1, 7000000.00, 7, 'DangThucHien', '2026-04-20 09:00:00', NULL, 1, 'DangGiamSat', 500000.00, '2026-04-20 09:00:00'),
	(2, 2, 2, 2, 30000000.00, 30, 'MoiTao', NULL, NULL, NULL, 'KhongCo', 0.00, '2026-04-20 09:10:00')
ON CONFLICT ("CongViecID") DO NOTHING;

INSERT INTO "YeuCauGiamSat"
	("YCGiamSatID", "CongViecID", "NguoiThueID", "GiamSatID", "FreelancerID", "TrangThai", "LyDoTuChoi", "PhiGiamSatThoa", "NgayYeuCau", "NgayChapNhan", "NgayHoanThanh")
VALUES
	(1, 1, 1, 1, 1, 'DaChapNhan', NULL, 500000.00, '2026-04-20 09:05:00', '2026-04-20 10:00:00', NULL)
ON CONFLICT ("YCGiamSatID") DO NOTHING;

INSERT INTO "TienDo"
	("TienDoID", "CongViecID", "FreelancerID", "TieuDe", "MoTa", "PhanTram", "TepDinhKem", "XacNhanBoi", "TrangThaiXacNhan", "NgayTao")
VALUES
	(1, 1, 1, 'Hoan thanh wireframe', 'Da gui wireframe trang chu va trang san pham', 30, 'wireframe-v1.pdf', 1, 'DaXacNhan', '2026-04-21 09:00:00'),
	(2, 1, 1, 'Hoan thanh UI mockup', 'Da gui mockup desktop/mobile', 60, 'mockup-v1.fig', NULL, 'ChuaXacNhan', '2026-04-22 09:30:00')
ON CONFLICT ("TienDoID") DO NOTHING;

INSERT INTO "TranhChap"
	("TranhChapID", "CongViecID", "NguoiGuiID", "GiamSatID", "LyDo", "MoTa", "TrangThai", "YeuCauHoanTien", "NgayMo", "NgayDong")
VALUES
	(1, 1, 1, 1, 'Cham tien do', 'Nguoi thue cho rang tien do cham 2 ngay', 'DangXuLy', 2000000.00, '2026-04-23 09:00:00', NULL)
ON CONFLICT ("TranhChapID") DO NOTHING;

INSERT INTO "BangChungTranhChap"
	("BangChungID", "TranhChapID", "NguoiNopID", "GiamSatID", "LoaiBangChung", "NoiDung", "DuongDanFile", "NgayNop")
VALUES
	(1, 1, 1, 1, 'TinNhan', 'Ban chup tin nhan thong bao cham tien do', NULL, '2026-04-23 09:15:00'),
	(2, 1, 3, 1, 'File', 'File lich trinh cong viec freelancer da gui', 'schedule.xlsx', '2026-04-23 09:30:00')
ON CONFLICT ("BangChungID") DO NOTHING;

INSERT INTO "KetLuanTranhChap"
	("KetLuanID", "TranhChapID", "GiamSatID", "KetQua", "LyDo", "SoTienHoan", "BenChiuPhi", "NgayKetLuan")
VALUES
	(1, 1, 1, 'PhanChia', 'Hai ben deu co trach nhiem trong viec giao tiep va cap nhat tien do', 1000000.00, 'ChiaSe', '2026-04-24 10:00:00')
ON CONFLICT ("KetLuanID") DO NOTHING;

INSERT INTO "ThanhToan"
	("ThanhToanID", "CongViecID", "NguoiThueID", "SoTien", "LoaiTT", "PhuongThuc", "TrangThai", "GiamSatID", "PhiGiamSatTT", "GhiChu", "NgayTao")
VALUES
	(1, 1, 1, 3000000.00, 'DatCoc', 'ChuyenKhoan', 'ThanhCong', 1, 200000.00, 'Dot dat coc 1', '2026-04-20 11:00:00'),
	(2, 1, 1, 4000000.00, 'ThanhToanCuoi', 'ThanhToanQuaMang', 'ChoXuLy', 1, 300000.00, 'Thanh toan sau khi nghiem thu', '2026-04-24 10:30:00'),
	(3, 1, 1, 500000.00, 'PhiGiamSat', 'Vi', 'ThanhCong', 1, 500000.00, 'Phi giam sat cong viec', '2026-04-24 10:45:00')
ON CONFLICT ("ThanhToanID") DO NOTHING;

INSERT INTO "CuocHoiThoai"
	("CuocHoiThoaiID", "CongViecID", "ThanhVien1ID", "ThanhVien2ID", "GiamSatID", "TinNhanCuoi", "TrangThai", "NgayTao")
VALUES
	(1, 1, 1, 3, 1, '2026-04-24 09:20:00', 'DangMo', '2026-04-20 09:15:00'),
	(2, 2, 2, 4, NULL, NULL, 'DangMo', '2026-04-20 09:20:00')
ON CONFLICT ("CuocHoiThoaiID") DO NOTHING;

INSERT INTO "TinNhan"
	("TinNhanID", "CuocHoiThoaiID", "NguoiGuiID", "NoiDung", "LoaiTin", "DaDoc", "NgayTao")
VALUES
	(1, 1, 1, 'Ban co the gui ban cap nhat ngay hom nay khong?', 'VanBan', true, '2026-04-24 09:00:00'),
	(2, 1, 3, 'Toi da cap nhat mockup va dang cho xac nhan.', 'VanBan', true, '2026-04-24 09:05:00'),
	(3, 1, 1, 'Ok, toi se nhan xet trong 1 gio toi.', 'VanBan', false, '2026-04-24 09:20:00'),
	(4, 2, 2, 'Du an API se bat dau vao thu 2.', 'VanBan', false, '2026-04-24 09:30:00')
ON CONFLICT ("TinNhanID") DO NOTHING;

INSERT INTO "DanhGia"
	("DanhGiaID", "CongViecID", "NguoiDanhGiaID", "NguoiDuocDGID", "DiemSo", "BinhLuan", "LoaiDanhGia", "GiamSatID", "NgayTao")
VALUES
	(1, 1, 1, 3, 5, 'Lam viec nhanh, chu dong cap nhat', 'NguoiThue_DanhGia_Freelancer', 1, '2026-04-25 08:00:00'),
	(2, 1, 3, 1, 4, 'Yeu cau ro rang, phoi hop tot', 'Freelancer_DanhGia_NguoiThue', 1, '2026-04-25 08:10:00')
ON CONFLICT ("DanhGiaID") DO NOTHING;

INSERT INTO "ThongBao"
	("ThongBaoID", "TaiKhoanID", "TieuDe", "NoiDung", "LoaiThongBao", "DaDoc", "GiamSatID", "NgayTao")
VALUES
	(1, 3, 'Bao gia duoc chap nhan', 'Yeu cau #1 da chon bao gia cua ban', 'BaoGia', false, NULL, '2026-04-20 09:05:00'),
	(2, 1, 'Tien do moi', 'Freelancer vua cap nhat tien do 60%', 'CongViec', false, 1, '2026-04-22 09:40:00'),
	(3, 5, 'Tranh chap moi', 'Can xu ly tranh chap cong viec #1', 'TranhChap', false, 1, '2026-04-23 09:05:00')
ON CONFLICT ("ThongBaoID") DO NOTHING;

INSERT INTO "BaoCao"
	("BaoCaoID", "NguoiBaoCaoID", "NguoiBiCaoID", "LyDo", "MoTa", "TrangThai", "KetQua", "AdminXuLyID", "NgayTao", "NgayXuLy")
VALUES
	(1, 2, 4, 'Spam tin nhan', 'Gui nhieu tin nhan khong lien quan du an', 'DangXuLy', NULL, 6, '2026-04-21 14:00:00', NULL)
ON CONFLICT ("BaoCaoID") DO NOTHING;

INSERT INTO "KhuyenMai"
	("KhuyenMaiID", "MaCode", "LoaiGiam", "GiaTriGiam", "GiaTriToiDa", "SoLuotDung", "GioiHanLuot", "TrangThai", "NgayBatDau", "NgayKetThuc")
VALUES
	(1, 'NEWUSER10', 'PhanTram', 10.00, 500000.00, 0, 100, 'HoatDong', '2026-04-01 00:00:00', '2026-12-31 23:59:59')
ON CONFLICT ("KhuyenMaiID") DO NOTHING;

SELECT setval(pg_get_serial_sequence('"LoaiDichVu"', 'LoaiDichVuID'), COALESCE(MAX("LoaiDichVuID"), 1), true) FROM "LoaiDichVu";
SELECT setval(pg_get_serial_sequence('"TaiKhoan"', 'TaiKhoanID'), COALESCE(MAX("TaiKhoanID"), 1), true) FROM "TaiKhoan";
SELECT setval(pg_get_serial_sequence('"NguoiThue"', 'NguoiThueID'), COALESCE(MAX("NguoiThueID"), 1), true) FROM "NguoiThue";
SELECT setval(pg_get_serial_sequence('"Freelancer"', 'FreelancerID'), COALESCE(MAX("FreelancerID"), 1), true) FROM "Freelancer";
SELECT setval(pg_get_serial_sequence('"DonViGiamSat"', 'GiamSatID'), COALESCE(MAX("GiamSatID"), 1), true) FROM "DonViGiamSat";
SELECT setval(pg_get_serial_sequence('"YeuCau"', 'YeuCauID'), COALESCE(MAX("YeuCauID"), 1), true) FROM "YeuCau";
SELECT setval(pg_get_serial_sequence('"BaoGia"', 'BaoGiaID'), COALESCE(MAX("BaoGiaID"), 1), true) FROM "BaoGia";
SELECT setval(pg_get_serial_sequence('"CongViec"', 'CongViecID'), COALESCE(MAX("CongViecID"), 1), true) FROM "CongViec";
SELECT setval(pg_get_serial_sequence('"YeuCauGiamSat"', 'YCGiamSatID'), COALESCE(MAX("YCGiamSatID"), 1), true) FROM "YeuCauGiamSat";
SELECT setval(pg_get_serial_sequence('"TienDo"', 'TienDoID'), COALESCE(MAX("TienDoID"), 1), true) FROM "TienDo";
SELECT setval(pg_get_serial_sequence('"TranhChap"', 'TranhChapID'), COALESCE(MAX("TranhChapID"), 1), true) FROM "TranhChap";
SELECT setval(pg_get_serial_sequence('"BangChungTranhChap"', 'BangChungID'), COALESCE(MAX("BangChungID"), 1), true) FROM "BangChungTranhChap";
SELECT setval(pg_get_serial_sequence('"KetLuanTranhChap"', 'KetLuanID'), COALESCE(MAX("KetLuanID"), 1), true) FROM "KetLuanTranhChap";
SELECT setval(pg_get_serial_sequence('"ThanhToan"', 'ThanhToanID'), COALESCE(MAX("ThanhToanID"), 1), true) FROM "ThanhToan";
SELECT setval(pg_get_serial_sequence('"CuocHoiThoai"', 'CuocHoiThoaiID'), COALESCE(MAX("CuocHoiThoaiID"), 1), true) FROM "CuocHoiThoai";
SELECT setval(pg_get_serial_sequence('"TinNhan"', 'TinNhanID'), COALESCE(MAX("TinNhanID"), 1), true) FROM "TinNhan";
SELECT setval(pg_get_serial_sequence('"DanhGia"', 'DanhGiaID'), COALESCE(MAX("DanhGiaID"), 1), true) FROM "DanhGia";
SELECT setval(pg_get_serial_sequence('"ThongBao"', 'ThongBaoID'), COALESCE(MAX("ThongBaoID"), 1), true) FROM "ThongBao";
SELECT setval(pg_get_serial_sequence('"BaoCao"', 'BaoCaoID'), COALESCE(MAX("BaoCaoID"), 1), true) FROM "BaoCao";
SELECT setval(pg_get_serial_sequence('"KhuyenMai"', 'KhuyenMaiID'), COALESCE(MAX("KhuyenMaiID"), 1), true) FROM "KhuyenMai";

COMMIT;
