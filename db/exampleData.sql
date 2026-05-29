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
	"FreelancerKyNang",
	"KetLuanTranhChap",
	"KhuyenMai",
	"KyNang",
	"LoaiDichVu",
	"NguoiThue",
	"TaiKhoan",
	"ThanhToan",
	"ThongBao",
	"TienDo",
	"TinNhan",
	"TranhChap",
	"YeuCauHoanTien",
	"YeuCau",
	"YeuCauGiamSat",
	"YeuCauKyNang"
RESTART IDENTITY CASCADE;

INSERT INTO "LoaiDichVu" ("LoaiDichVuID", "TenLoai", "MoTa", "HinhAnh")
VALUES
	(1, 'Thiết kế UI/UX', 'Thiết kế giao diện web và mobile', 'palette'),
	(2, 'Lập trình backend', 'Phát triển API, hệ thống nghiệp vụ', 'server-cog'),
	(3, 'Digital marketing', 'SEO, quảng cáo, social media', 'megaphone'),
	(4, 'Thiết kế logo', 'Logo và brand identity', 'pen-tool'),
	(5, 'Mobile app', 'Phát triển ứng dụng di động', 'smartphone'),
	(6, 'Frontend web', 'Giao diện web hiện đại', 'panels-top-left'),
	(7, 'DevOps', 'CI/CD và hạ tầng', 'cloud-cog'),
	(8, 'QA testing', 'Kiểm thử và báo cáo lỗi', 'shield-check'),
	(9, 'Data analytics', 'Phân tích dữ liệu', 'chart-column-increasing'),
	(10, 'AI/ML', 'Mô hình học máy', 'brain-circuit')
ON CONFLICT ("LoaiDichVuID") DO NOTHING;

INSERT INTO "TaiKhoan"
	("TaiKhoanID", "TenDangNhap", "MatKhau", "Email", "HoTen", "SoDienThoai", "GioiTinh", "DiaChi", "VaiTro", "TrangThai", "NgayTao", "NgayCapNhat")
VALUES
	(1, 'thue_an', '123123', 'manhhuy2@gmail.com', 'Nguyen Van An', '0901000001', 'Nam', 'Ha Noi', 'NguoiThue', 'HoatDong', '2026-04-18 08:00:00', '2026-04-22 09:00:00'),
	(2, 'thue_binh', '123123', 'binh@example.com', 'Tran Thi Binh', '0901000002', 'Nu', 'Da Nang', 'NguoiThue', 'HoatDong', '2026-04-18 08:10:00', '2026-04-22 09:05:00'),
	(3, 'free_cuong', '123123', 'cuong@example.com', 'Le Quang Cuong', '0901000003', 'Nam', 'TP HCM', 'Freelancer', 'HoatDong', '2026-04-18 08:20:00', '2026-04-22 09:10:00'),
	(4, 'free_duong', '123123', 'duong@example.com', 'Pham Minh Duong', '0901000004', 'Nam', 'Can Tho', 'Freelancer', 'HoatDong', '2026-04-18 08:30:00', '2026-04-22 09:15:00'),
	(5, 'gs_eagle', '123123', 'eagle@example.com', 'Eagle Supervision', '0901000005', 'Khac', 'Ha Noi', 'DonViGiamSat', 'HoatDong', '2026-04-18 08:40:00', '2026-04-22 09:20:00'),
	(6, 'admin_root', '123123', 'admin@example.com', 'System Admin', '0901000006', 'Khac', 'Ha Noi', 'Admin', 'HoatDong', '2026-04-18 08:50:00', '2026-04-22 09:25:00'),
	(7, 'user_07', '123123', 'user07@example.com', 'User 07', '0901000007', 'Nam', 'Ha Noi', 'NguoiThue', 'HoatDong', '2026-04-18 09:00:00', '2026-04-22 09:30:00'),
	(8, 'user_08', '123123', 'user08@example.com', 'User 08', '0901000008', 'Nu', 'Hai Phong', 'NguoiThue', 'HoatDong', '2026-04-18 09:05:00', '2026-04-22 09:35:00'),
	(9, 'user_09', '123123', 'user09@example.com', 'User 09', '0901000009', 'Nam', 'Da Nang', 'NguoiThue', 'HoatDong', '2026-04-18 09:10:00', '2026-04-22 09:40:00'),
	(10, 'user_10', '123123', 'user10@example.com', 'User 10', '0901000010', 'Nu', 'TP HCM', 'NguoiThue', 'HoatDong', '2026-04-18 09:15:00', '2026-04-22 09:45:00'),
	(11, 'user_11', '123123', 'user11@example.com', 'User 11', '0901000011', 'Nam', 'Can Tho', 'Freelancer', 'HoatDong', '2026-04-18 09:20:00', '2026-04-22 09:50:00'),
	(12, 'user_12', '123123', 'user12@example.com', 'User 12', '0901000012', 'Nu', 'Hue', 'Freelancer', 'HoatDong', '2026-04-18 09:25:00', '2026-04-22 09:55:00'),
	(13, 'user_13', '123123', 'dev1@freelancer.vn', 'User 13', '0901000013', 'Nam', 'Nha Trang', 'Freelancer', 'HoatDong', '2026-04-18 09:30:00', '2026-04-22 10:00:00'),
	(14, 'user_14', '123123', 'user14@example.com', 'User 14', '0901000014', 'Nu', 'Vung Tau', 'Freelancer', 'HoatDong', '2026-04-18 09:35:00', '2026-04-22 10:05:00'),
	(15, 'user_15', '123123', 'user15@example.com', 'User 15', '0901000015', 'Nam', 'Ha Noi', 'Freelancer', 'HoatDong', '2026-04-18 09:40:00', '2026-04-22 10:10:00'),
	(16, 'user_16', '123123', 'user16@example.com', 'User 16', '0901000016', 'Nu', 'TP HCM', 'Freelancer', 'HoatDong', '2026-04-18 09:45:00', '2026-04-22 10:15:00'),
	(17, 'user_17', '123123', 'user17@example.com', 'User 17', '0901000017', 'Nam', 'Da Nang', 'Freelancer', 'HoatDong', '2026-04-18 09:50:00', '2026-04-22 10:20:00'),
	(18, 'user_18', '123123', 'user18@example.com', 'User 18', '0901000018', 'Nu', 'Hai Phong', 'Freelancer', 'HoatDong', '2026-04-18 09:55:00', '2026-04-22 10:25:00'),
	(19, 'user_19', '123123', 'user19@example.com', 'User 19', '0901000019', 'Nam', 'Ha Noi', 'Freelancer', 'HoatDong', '2026-04-18 10:00:00', '2026-04-22 10:30:00'),
	(20, 'user_20', '123123', 'user20@example.com', 'User 20', '0901000020', 'Nu', 'TP HCM', 'Freelancer', 'HoatDong', '2026-04-18 10:05:00', '2026-04-22 10:35:00'),
	(21, 'user_21', '123123', 'iso@giamsat.vn', 'User 21', '0901000021', 'Nam', 'Ha Noi', 'DonViGiamSat', 'HoatDong', '2026-04-18 10:10:00', '2026-04-22 10:40:00'),
	(22, 'user_22', '123123', 'user22@example.com', 'User 22', '0901000022', 'Nu', 'Da Nang', 'DonViGiamSat', 'HoatDong', '2026-04-18 10:15:00', '2026-04-22 10:45:00'),
	(23, 'user_23', '123123', 'user23@example.com', 'User 23', '0901000023', 'Nam', 'TP HCM', 'DonViGiamSat', 'HoatDong', '2026-04-18 10:20:00', '2026-04-22 10:50:00'),
	(24, 'user_24', '123123', 'user24@example.com', 'User 24', '0901000024', 'Nu', 'Can Tho', 'DonViGiamSat', 'HoatDong', '2026-04-18 10:25:00', '2026-04-22 10:55:00'),
	(25, 'user_25', '123123', 'user25@example.com', 'User 25', '0901000025', 'Nam', 'Hue', 'DonViGiamSat', 'HoatDong', '2026-04-18 10:30:00', '2026-04-22 11:00:00'),
	(26, 'user_26', '123123', 'user26@example.com', 'User 26', '0901000026', 'Nu', 'Nha Trang', 'DonViGiamSat', 'HoatDong', '2026-04-18 10:35:00', '2026-04-22 11:05:00'),
	(27, 'user_27', '123123', 'user27@example.com', 'User 27', '0901000027', 'Nam', 'Vung Tau', 'DonViGiamSat', 'DaBi', '2026-04-18 10:40:00', '2026-04-22 11:10:00'),
	(28, 'user_28', '123123', 'user28@example.com', 'User 28', '0901000028', 'Nu', 'Ha Noi', 'DonViGiamSat', 'ChoDuyet', '2026-04-18 10:45:00', '2026-04-22 11:15:00'),
	(29, 'user_29', '123123', 'user29@example.com', 'User 29', '0901000029', 'Nam', 'TP HCM', 'Admin', 'BiKhoa', '2026-04-18 10:50:00', '2026-04-22 11:20:00'),
	(30, 'user_30', '123123', 'user30@example.com', 'User 30', '0901000030', 'Nu', 'Da Nang', 'Admin', 'HoatDong', '2026-04-18 10:55:00', '2026-04-22 11:25:00')
ON CONFLICT ("TaiKhoanID") DO NOTHING;

INSERT INTO "NguoiThue"
	("NguoiThueID", "TaiKhoanID", "CongTy", "MoTa", "DiemTinCay", "TongYeuCau", "TyLeHoanThanh")
VALUES
	(1, 1, 'An Tech Co', 'Cần thuê đối tác làm website', 4.60, 20, 85.00),
	(2, 2, 'Binh Trade', 'Cần backend và SEO cho hệ thống bán hàng', 4.40, 10, 70.00),
	(3, 7, 'Tech Solutions', 'Công ty giải pháp công nghệ', 4.50, 15, 80.00),
	(4, 8, 'Digital Marketing Co', 'Công ty marketing số', 4.25, 8, 75.00),
	(5, 9, 'E-commerce Plus', 'Sàn thương mại điện tử', 4.35, 12, 82.00),
	(6, 10, 'Startup Hub', 'Trung tâm khởi nghiệp', 4.15, 6, 66.00)
ON CONFLICT ("NguoiThueID") DO NOTHING;

INSERT INTO "Freelancer"
	("FreelancerID", "TaiKhoanID", "KinhNghiem", "ChuyenGia", "KyNang", "XepHang", "SoDu", "XacThucEmail", "XacThucSDT", "TongCongViec", "TyLeHoanThanh")
VALUES
	(1, 3, 5, 'Frontend Engineer', 'React, Next.js, UI/UX', 4.80, 12000000.00, true, true, 22, 90.00),
	(2, 4, 4, 'Backend Engineer', 'NestJS, PostgreSQL, Redis', 4.55, 8300000.00, true, true, 17, 85.00),
	(3, 11, 7, 'AI Engineer', 'Python, ML', 4.75, 15000000.00, true, true, 28, 94.00),
	(4, 12, 2, 'Content Writer', 'SEO, Copywriting', 4.00, 3000000.00, true, false, 6, 65.00),
	(5, 13, 4, 'Fullstack Engineer', 'NestJS, Prisma, React', 4.40, 7600000.00, true, true, 25, 88.00),
	(6, 14, 5, 'Frontend Engineer', 'Vue, React', 4.50, 8900000.00, true, true, 19, 89.00),
	(7, 15, 3, 'UX Researcher', 'Interview, Survey', 4.15, 4200000.00, true, false, 7, 68.00),
	(8, 16, 6, 'Security Engineer', 'Pentest, OWASP', 4.65, 11000000.00, true, true, 21, 90.00),
	(9, 17, 2, 'Video Editor', 'Premiere, After Effects', 4.05, 3400000.00, true, false, 5, 62.00),
	(10, 18, 4, 'SEO Specialist', 'Technical SEO', 4.30, 5400000.00, true, true, 13, 80.00),
	(11, 19, 3, 'Illustrator', 'Illustration, Icon', 4.12, 4000000.00, true, false, 9, 71.00),
	(12, 20, 5, 'Game Designer', 'Unity, C#', 4.55, 9600000.00, true, true, 18, 87.00)
ON CONFLICT ("FreelancerID") DO NOTHING;

INSERT INTO "DonViGiamSat"
	("GiamSatID", "TaiKhoanID", "TenDonVi", "MoTa", "NangLuc", "ChungChi", "PhiGiamSat", "XepHang", "TongCongViecGS", "TrangThai", "NgayDangKy")
VALUES
	(1, 5, 'Eagle Supervisors', 'Don vi giam sat tien do va chat luong', 'Kiem thu, quy trinh, bao cao', 'ISO-9001', 500000.00, 4.70, 40, 'HoatDong', '2026-04-10 09:00:00'),
	(2, 21, 'ISO Quality Control', 'Giam sat chat luong ISO', 'Kiem thu, bao cao, ISO', 'ISO-CERT', 450000.00, 4.50, 35, 'HoatDong', '2026-04-11 09:00:00'),
	(3, 22, 'Tech Audit Pro', 'Giam sat ky thuat chuyen nghiep', 'Quy trinh, audit, kiem thu', 'CERT-TECH', 480000.00, 4.35, 28, 'ChoDuyet', '2026-04-12 09:00:00'),
	(4, 23, 'QA Supervisors', 'Don vi dam bao chat luong', 'Bao cao, kiem thu, QA', 'QA-CERT', 520000.00, 4.40, 30, 'TamNghi', '2026-04-13 09:00:00'),
	(5, 24, 'Process Control', 'Kiem soat quy trinh', 'Quy trinh, ISO, audit', 'ISO-PROC', 500000.00, 4.20, 22, 'BiKhoa', '2026-04-14 09:00:00'),
	(6, 25, 'Quality Assurance', 'Dam bao chat luong toan dien', 'Kiem thu, QA, bao cao', 'QA-PRO', 530000.00, 4.45, 32, 'HoatDong', '2026-04-15 09:00:00'),
	(7, 26, 'Audit & Report', 'Kiem toan va bao cao', 'Audit, bao cao, quy trinh', 'AUDIT-CERT', 470000.00, 4.15, 20, 'HoatDong', '2026-04-16 09:00:00'),
	(8, 27, 'Security Watch', 'Giam sat bao mat', 'Bao cao, quy trinh, bao mat', 'SEC-CERT', 460000.00, 4.25, 24, 'HoatDong', '2026-04-17 09:00:00'),
	(9, 28, 'ISO Compliance', 'Tuan thu tieu chuan ISO', 'ISO, bao mat, kiem thu', 'ISO-COMP', 540000.00, 4.50, 36, 'HoatDong', '2026-04-18 09:00:00')
ON CONFLICT ("GiamSatID") DO NOTHING;

INSERT INTO "YeuCau"
	("YeuCauID", "TaiKhoanID", "LoaiDichVuID", "GiamSatID", "TieuDe", "MoTa", "NganSachMin", "NganSachMax", "ThoiHan", "TrangThai", "SoLuongBaoGia", "YeuCauGiamSat", "NgayTao", "NgayCapNhat")
VALUES
	-- Backend (8 yêu cầu - nhiều nhất)
	(1, 1, 2, 21, 'Xây dựng API NestJS', 'Cần xây dựng hệ thống API RESTful quản lý đơn hàng và thanh toán. Yêu cầu tích hợp cổng thanh toán VNPay, Momo, xử lý đơn hàng realtime, quản lý trạng thái đơn hàng và gửi thông báo tự động cho khách hàng.', 25000000.00, 40000000.00, '2026-06-01', 'DaChot', 0, true, '2026-04-19 10:00:00', '2026-05-02 10:00:00'),
	(2, 2, 2, 21, 'API quản lý kho', 'Xây dựng API quản lý kho hàng và tồn kho với các tính năng: nhập/xuất kho, kiểm kê tự động, cảnh báo hàng sắp hết, báo cáo tồn kho theo thời gian thực. Cần tích hợp với hệ thống bán hàng hiện tại.', 20000000.00, 35000000.00, '2026-06-05', 'DaChot', 0, true, '2026-04-19 10:10:00', '2026-05-03 10:05:00'),
	(3, 7, 2, 21, 'Backend hệ thống CRM', 'Phát triển backend cho hệ thống CRM quản lý khách hàng, lịch sử tương tác, phân loại khách hàng, tự động hóa email marketing và báo cáo phân tích hành vi khách hàng. Yêu cầu có API cho mobile app.', 30000000.00, 50000000.00, '2026-06-10', 'DangNhanHoSo', 0, true, '2026-04-19 10:20:00', '2026-04-22 10:10:00'),
	(4, 8, 2, 21, 'API thanh toán', 'Tích hợp cổng thanh toán quốc tế (Stripe, PayPal) và nội địa (VNPay, ZaloPay). Xử lý giao dịch an toàn, hoàn tiền tự động, lưu lịch sử giao dịch và tạo báo cáo doanh thu theo ngày/tháng.', 18000000.00, 30000000.00, '2026-06-15', 'DangNhanHoSo', 0, true, '2026-04-19 10:30:00', '2026-04-22 10:15:00'),
	(5, 9, 2, 21, 'Microservices architecture', 'Xây dựng kiến trúc microservices cho hệ thống lớn với các service: User, Product, Order, Payment, Notification. Sử dụng RabbitMQ/Kafka cho message queue, Redis cho caching, và Docker/Kubernetes cho deployment.', 35000000.00, 60000000.00, '2026-06-20', 'DangNhanHoSo', 0, true, '2026-04-19 10:40:00', '2026-04-22 10:20:00'),
	(6, 10, 2, 21, 'API quản lý người dùng', 'Backend quản lý người dùng với authentication JWT, phân quyền RBAC chi tiết, quản lý profile, đổi mật khẩu, xác thực 2FA, và tích hợp đăng nhập qua Google/Facebook. Cần có audit log đầy đủ.', 15000000.00, 28000000.00, '2026-06-25', 'DangNhanHoSo', 0, true, '2026-04-19 10:50:00', '2026-04-22 10:25:00'),
	(7, 1, 2, 21, 'Backend e-commerce', 'Hệ thống backend hoàn chỉnh cho sàn thương mại điện tử: quản lý sản phẩm, giỏ hàng, đơn hàng, thanh toán, đánh giá sản phẩm, quản lý khuyến mãi và tích hợp vận chuyển (GHN, GHTK). Cần có admin dashboard API.', 28000000.00, 45000000.00, '2026-07-01', 'DaChot', 0, true, '2026-04-19 11:00:00', '2026-05-08 10:30:00'),
	(8, 2, 2, 21, 'API báo cáo thống kê', 'API tạo báo cáo và thống kê nghiệp vụ với các biểu đồ: doanh thu theo thời gian, top sản phẩm bán chạy, phân tích khách hàng, tỷ lệ chuyển đổi. Hỗ trợ export Excel/PDF và lọc dữ liệu linh hoạt.', 12000000.00, 22000000.00, '2026-07-05', 'DangNhanHoSo', 0, true, '2026-04-19 11:10:00', '2026-04-22 10:35:00'),
	-- UI/UX (6 yêu cầu)
	(9, 1, 1, 21, 'Thiết kế landing page', 'Cần thiết kế landing page hiện đại cho chiến dịch ra mắt sản phẩm mới. Yêu cầu responsive, tối ưu conversion rate, có animation mượt mà, tích hợp form đăng ký và tương thích mọi thiết bị.', 5000000.00, 9000000.00, '2026-07-10', 'DaDong', 0, true, '2026-04-19 11:20:00', '2026-05-10 10:40:00'),
	(10, 7, 1, 21, 'Thiết kế app mobile', 'Thiết kế giao diện app mobile iOS/Android theo chuẩn Material Design và Human Interface Guidelines. Cần có wireframe, mockup chi tiết, prototype tương tác và design system hoàn chỉnh với component library.', 8000000.00, 15000000.00, '2026-07-15', 'DangNhanHoSo', 0, true, '2026-04-19 11:30:00', '2026-04-22 10:45:00'),
	(11, 8, 1, 21, 'UI dashboard admin', 'Thiết kế giao diện quản trị hệ thống với các màn hình: dashboard tổng quan, quản lý người dùng, báo cáo thống kê, cài đặt hệ thống. Cần có dark mode, responsive và tối ưu cho nhiều loại dữ liệu.', 6000000.00, 12000000.00, '2026-07-20', 'DangNhanHoSo', 0, true, '2026-04-19 11:40:00', '2026-04-22 10:50:00'),
	(12, 9, 1, 25, 'UX research và thiết kế', 'Nghiên cứu người dùng thông qua phỏng vấn, khảo sát, phân tích hành vi. Tạo user persona, user journey map, wireframe và thiết kế giao diện dựa trên insights thu thập được. Bao gồm usability testing.', 10000000.00, 18000000.00, '2026-07-25', 'DaHuy', 0, true, '2026-04-19 11:50:00', '2026-05-11 10:55:00'),
	(13, 10, 1, 21, 'Redesign website', 'Thiết kế lại toàn bộ website công ty với phong cách hiện đại, chuyên nghiệp. Bao gồm trang chủ, giới thiệu, dịch vụ, blog, liên hệ. Cần có animation, micro-interactions và tối ưu SEO.', 12000000.00, 20000000.00, '2026-08-01', 'DangNhanHoSo', 0, true, '2026-04-19 12:00:00', '2026-04-22 11:00:00'),
	(14, 2, 1, 21, 'UI kit và design system', 'Xây dựng UI kit và design system hoàn chỉnh với typography, color palette, spacing, components, icons. Tạo tài liệu hướng dẫn sử dụng và file Figma có tổ chức để team dev dễ implement.', 7000000.00, 13000000.00, '2026-08-05', 'DangNhanHoSo', 0, true, '2026-04-19 12:10:00', '2026-04-22 11:05:00'),
	-- Frontend (5 yêu cầu)
	(15, 1, 6, 21, 'Giao diện frontend React', 'Phát triển giao diện hiện đại với React 18, TypeScript, TailwindCSS. Cần responsive, tối ưu performance, lazy loading, code splitting. Tích hợp API backend, xử lý state với Redux Toolkit và có unit tests.', 7000000.00, 12000000.00, '2026-08-10', 'DaChot', 0, true, '2026-04-19 12:20:00', '2026-05-14 11:10:00'),
	(16, 7, 6, 21, 'Frontend dashboard', 'Phát triển dashboard quản trị với Vue.js 3, Composition API, Pinia. Hiển thị biểu đồ realtime (Chart.js), bảng dữ liệu phân trang, filter nâng cao, export Excel/PDF. Cần có dark mode và responsive.', 8000000.00, 14000000.00, '2026-08-15', 'DangNhanHoSo', 0, true, '2026-04-19 12:30:00', '2026-04-22 11:15:00'),
	(17, 8, 6, 21, 'Landing page responsive', 'Xây dựng landing page responsive với HTML5, CSS3, JavaScript. Có animation mượt mà (GSAP), form validation, tích hợp Google Analytics, tối ưu SEO on-page và đạt 90+ điểm PageSpeed Insights.', 5000000.00, 9000000.00, '2026-08-20', 'DangNhanHoSo', 0, true, '2026-04-19 12:40:00', '2026-04-22 11:20:00'),
	(18, 9, 6, 21, 'Frontend e-commerce', 'Giao diện website bán hàng với React, Next.js. Trang chủ, danh mục sản phẩm, chi tiết sản phẩm, giỏ hàng, thanh toán, tài khoản người dùng. Tích hợp payment gateway, SEO-friendly, PWA support.', 10000000.00, 18000000.00, '2026-08-25', 'DangNhanHoSo', 0, true, '2026-04-19 12:50:00', '2026-04-22 11:25:00'),
	(19, 10, 6, 21, 'Web app Next.js', 'Phát triển web app với Next.js 14, App Router, Server Components. Có authentication, realtime updates (Socket.io), file upload, notification system. Deploy lên Vercel với CI/CD tự động.', 12000000.00, 20000000.00, '2026-09-01', 'DangNhanHoSo', 0, true, '2026-04-19 13:00:00', '2026-04-22 11:30:00'),
	-- Mobile app (4 yêu cầu)
	(20, 1, 5, 21, 'App mobile bán hàng', 'Xây dựng app bán hàng iOS/Android với React Native. Tính năng: đăng nhập, duyệt sản phẩm, giỏ hàng, thanh toán, theo dõi đơn hàng, đánh giá sản phẩm, push notification. Tích hợp Firebase và payment gateway.', 30000000.00, 45000000.00, '2026-09-05', 'DaChot', 0, true, '2026-04-19 13:10:00', '2026-05-15 11:35:00'),
	(21, 2, 5, 21, 'App quản lý công việc', 'Ứng dụng quản lý task và project với Flutter. Tạo/chỉnh sửa task, gán người thực hiện, deadline, priority, comment, file đính kèm. Có Kanban board, Gantt chart, báo cáo tiến độ và sync realtime.', 25000000.00, 40000000.00, '2026-09-10', 'DangNhanHoSo', 0, true, '2026-04-19 13:20:00', '2026-04-22 11:40:00'),
	(22, 7, 5, 21, 'App giao hàng', 'Ứng dụng cho shipper và khách hàng với React Native. Shipper: nhận đơn, định vị GPS, cập nhật trạng thái. Khách hàng: theo dõi đơn hàng realtime, đánh giá shipper. Tích hợp Google Maps và notification.', 28000000.00, 42000000.00, '2026-09-15', 'DangNhanHoSo', 0, true, '2026-04-19 13:30:00', '2026-04-22 11:45:00'),
	(23, 8, 5, 21, 'App đặt lịch', 'Ứng dụng đặt lịch hẹn và quản lý với Flutter. Khách hàng: xem lịch trống, đặt lịch, nhận nhắc nhở. Nhân viên: quản lý lịch làm việc, xác nhận/hủy lịch. Có calendar view, push notification và payment.', 20000000.00, 35000000.00, '2026-09-20', 'DangNhanHoSo', 0, true, '2026-04-19 13:40:00', '2026-04-22 11:50:00'),
	-- Digital Marketing (3 yêu cầu)
	(24, 9, 3, 21, 'SEO tổng thể website', 'Tối ưu SEO on-page và technical SEO cho website. Bao gồm: keyword research, tối ưu meta tags, heading structure, internal linking, sitemap, robots.txt, Core Web Vitals, mobile-friendly. Báo cáo hàng tuần.', 8000000.00, 15000000.00, '2026-09-25', 'DangNhanHoSo', 0, true, '2026-04-19 13:50:00', '2026-04-22 11:55:00'),
	(25, 10, 3, 21, 'Chiến dịch Google Ads', 'Thiết lập và quản lý chiến dịch Google Ads (Search, Display, Shopping). Nghiên cứu từ khóa, viết ad copy, tối ưu landing page, A/B testing, theo dõi conversion. Ngân sách quảng cáo 20 triệu/tháng trong 3 tháng.', 10000000.00, 18000000.00, '2026-10-01', 'DangNhanHoSo', 0, true, '2026-04-19 14:00:00', '2026-04-22 12:00:00'),
	(26, 1, 3, 21, 'Social media marketing', 'Quản lý và phát triển social media (Facebook, Instagram, TikTok). Lên content plan, thiết kế post, viết caption, chạy ads, tương tác với khách hàng, phân tích insights. Đăng 5-7 bài/tuần trong 3 tháng.', 6000000.00, 12000000.00, '2026-10-05', 'DangNhanHoSo', 0, true, '2026-04-19 14:10:00', '2026-04-22 12:05:00'),

	-- DevOps (2 yêu cầu)
	(27, 2, 7, 21, 'Xây dựng CI/CD', 'Thiết lập pipeline CI/CD với GitHub Actions hoặc GitLab CI. Auto build, test, deploy lên staging/production. Tích hợp Docker, automated testing, code quality check (SonarQube), notification khi deploy thành công/thất bại.', 8000000.00, 15000000.00, '2026-10-10', 'DangNhanHoSo', 0, true, '2026-04-19 14:20:00', '2026-04-22 12:10:00'),
	(28, 7, 7, 21, 'Setup infrastructure', 'Thiết lập hạ tầng trên AWS/GCP: EC2/Compute Engine, RDS/Cloud SQL, S3/Cloud Storage, Load Balancer, Auto Scaling, CloudWatch/Monitoring. Cấu hình security groups, backup tự động và disaster recovery plan.', 12000000.00, 22000000.00, '2026-10-15', 'DangNhanHoSo', 0, true, '2026-04-19 14:30:00', '2026-04-22 12:15:00'),

	-- Logo (1 yêu cầu)
	(29, 8, 4, 21, 'Thiết kế logo', 'Thiết kế bộ nhận diện thương hiệu hoàn chỉnh: logo chính, logo phụ, color palette, typography, business card, letterhead, envelope. Giao file vector (AI, SVG) và hướng dẫn sử dụng brand guideline chi tiết.', 3000000.00, 6000000.00, '2026-10-20', 'DangNhanHoSo', 0, true, '2026-04-19 14:40:00', '2026-04-22 12:20:00'),

	-- QA Testing (1 yêu cầu)
	(30, 9, 8, 21, 'Kiểm thử hệ thống', 'Test và báo cáo lỗi toàn diện cho web app. Bao gồm: functional testing, UI/UX testing, performance testing, security testing, compatibility testing (browsers, devices). Viết test cases, báo cáo bug chi tiết với screenshots/videos.', 4000000.00, 8000000.00, '2026-10-25', 'DangNhanHoSo', 0, true, '2026-04-19 14:50:00', '2026-04-22 12:25:00'),
	-- Yeu cau da huy cua user 1 de demo day du vong doi tuyen freelancer
	(31, 1, 4, 21, 'Logo cho san pham thu nghiem', 'Yeu cau thiet ke logo da huy do thay doi ke hoach ra mat san pham.', 3000000.00, 5000000.00, '2026-07-15', 'DaHuy', 0, true, '2026-04-20 09:00:00', '2026-05-16 09:00:00'),
	-- Du an ban giao 100% de nguoi thue test khieu nai ket qua
	(32, 1, 8, 21, 'Kiem thu nghiem thu cong thanh toan', 'Kiem thu hoan chinh cong thanh toan va bao cao loi; ket qua da ban giao nhung khach hang co the khong chap nhan chat luong.', 10000000.00, 14000000.00, '2026-05-24', 'DaChot', 0, true, '2026-04-25 09:00:00', '2026-05-24 17:00:00'),
	-- Du an da co khieu nai dang cho don vi giam sat ket luan
	(33, 1, 6, 21, 'Trang quan tri bao cao doanh thu', 'Phat trien trang dashboard bao cao doanh thu voi bo loc va chuc nang xuat du lieu; da giao san pham nhung bi khieu nai ve ket qua.', 14000000.00, 18000000.00, '2026-05-22', 'DaChot', 0, true, '2026-04-24 09:00:00', '2026-05-25 10:00:00')
ON CONFLICT ("YeuCauID") DO NOTHING;

-- Supervisor request-phase demo data.
-- ISO Quality Control (TaiKhoanID 21) receives only a small representative
-- inbox before a contract exists: one pending, one rejected and one accepted.
UPDATE "YeuCau"
SET
	"GiamSatID" = CASE
		WHEN "YeuCauID" IN (1, 2, 7, 8, 10, 15, 20, 30, 32, 33) THEN 21
		WHEN "YeuCauID" IN (3, 4, 5, 6, 9, 12, 13, 17, 19, 23, 27, 31) THEN 25
		ELSE 26
	END,
	"TrangThaiGiamSat" = CASE
		-- Existing/proceeding contracts were approved before work began.
		WHEN "YeuCauID" IN (1, 2, 7, 15, 20, 32, 33) THEN 'DaChapNhan'::"TrangThaiYeuCauGiamSat"
		-- Three request-phase examples assigned to supervisor 21.
		WHEN "YeuCauID" = 8 THEN 'ChoDuyet'::"TrangThaiYeuCauGiamSat"
		WHEN "YeuCauID" = 10 THEN 'TuChoi'::"TrangThaiYeuCauGiamSat"
		WHEN "YeuCauID" = 30 THEN 'DaChapNhan'::"TrangThaiYeuCauGiamSat"
		WHEN "YeuCauID" IN (12, 31) THEN 'TuChoi'::"TrangThaiYeuCauGiamSat"
		WHEN "YeuCauID" IN (3, 4, 5, 6, 9, 13, 17, 19, 23, 27) THEN 'DaChapNhan'::"TrangThaiYeuCauGiamSat"
		ELSE 'ChoDuyet'::"TrangThaiYeuCauGiamSat"
	END,
	"LyDoTuChoiGiamSat" = CASE
		WHEN "YeuCauID" = 10 THEN 'Khong du nguon luc vao thoi diem nay.'
		WHEN "YeuCauID" IN (12, 31) THEN 'Yeu cau da huy truoc khi nhan giam sat.'
		ELSE NULL
	END,
	"NgayGiamSatChapNhan" = CASE
		WHEN "YeuCauID" IN (1, 2, 7, 15, 20, 30, 32, 33) THEN "NgayTao" + INTERVAL '1 day'
		WHEN "YeuCauID" IN (3, 4, 5, 6, 9, 13, 17, 19, 23, 27) THEN "NgayTao" + INTERVAL '1 day'
		ELSE NULL
	END;

INSERT INTO "BaoGia"
	("BaoGiaID", "YeuCauID", "TaiKhoanID", "GiaDeXuat", "ThoiGianThucHien", "NoiDung", "TrangThai", "NgayTao", "NgayCapNhat")
VALUES
	(1, 1, 13, 32000000.00, 30, 'Xây dựng REST API NestJS, PostgreSQL, Redis và tài liệu Swagger cho hệ thống của người thuê 1.', 'DuocChon', '2026-04-20 08:00:00', '2026-05-02 10:20:00'),
	(2, 1, 3, 34000000.00, 28, 'Phương án API tối ưu hiệu năng và triển khai Docker, gửi bởi freelancer 3.', 'TuChoi', '2026-04-20 08:10:00', '2026-05-02 10:25:00'),
	(3, 2, 13, 30000000.00, 30, 'Xây dựng API RESTful với NestJS, PostgreSQL, Redis caching. Bao gồm authentication JWT, authorization RBAC, API documentation (Swagger), unit tests, integration tests, deployment script và monitoring dashboard.', 'DuocChon', '2026-04-20 08:20:00', '2026-05-03 10:30:00'),
	(4, 2, 4, 32000000.00, 35, 'API hoàn chỉnh với NestJS, Prisma ORM, Redis, RabbitMQ. Thêm monitoring với Grafana, logging với ELK stack, automated backup, CI/CD pipeline và tài liệu API chi tiết. Bảo hành 3 tháng.', 'TuChoi', '2026-04-20 08:25:00', '2026-05-03 10:32:00'),
	(5, 2, 14, 28000000.00, 28, 'API cơ bản với NestJS, PostgreSQL. Bao gồm CRUD operations, authentication, validation, error handling và API docs. Giao source code, database schema và hướng dẫn deployment.', 'TuChoi', '2026-04-20 08:27:00', '2026-05-03 10:33:00'),
	(6, 3, 13, 10000000.00, 21, 'SEO audit toàn diện và roadmap 3 tháng. Phân tích từ khóa, đối thủ, technical SEO, on-page SEO. Tối ưu meta tags, heading, internal linking, sitemap. Báo cáo hàng tuần với Google Analytics và Search Console.', 'DaGui', '2026-04-20 08:30:00', '2026-04-22 10:35:00'),
	(7, 3, 18, 9500000.00, 20, 'SEO audit và tối ưu technical SEO: Core Web Vitals, mobile-friendly, structured data, robots.txt, sitemap XML. Keyword research và tối ưu 20 trang quan trọng. Báo cáo chi tiết sau mỗi sprint.', 'DaGui', '2026-04-20 08:32:00', '2026-04-22 10:36:00'),
	(8, 4, 13, 4500000.00, 10, 'Thiết kế logo và nhận diện thương hiệu: 3 concept ban đầu, chỉnh sửa không giới hạn, giao file vector (AI, SVG, PDF), PNG với nhiều kích thước. Bao gồm color palette và typography guideline.', 'DaGui', '2026-04-20 08:40:00', '2026-04-22 10:40:00'),
	(9, 4, 3, 5000000.00, 12, 'Logo và brand identity hoàn chỉnh: logo chính, logo phụ, business card, letterhead, envelope, social media templates. Giao file nguồn và brand guideline 20+ trang với hướng dẫn sử dụng chi tiết.', 'DaGui', '2026-04-20 08:42:00', '2026-04-22 10:41:00'),
	(10, 4, 19, 4800000.00, 11, 'Logo design với 5 concept khác nhau, chỉnh sửa 3 lần, giao file AI, SVG, PNG. Bao gồm mockup trên business card, website, social media. Thời gian: concept 5 ngày, hoàn thiện 6 ngày.', 'DaGui', '2026-04-20 08:43:00', '2026-04-22 10:42:00'),
	(11, 5, 13, 32000000.00, 28, 'App mobile bán hàng với React Native, TypeScript. Tính năng: đăng nhập, danh mục sản phẩm, giỏ hàng, thanh toán, theo dõi đơn hàng, push notification. Tích hợp Firebase, payment gateway. Giao source code, APK/IPA và tài liệu.', 'DaGui', '2026-04-20 08:50:00', '2026-04-22 10:45:00'),
	(12, 5, 11, 35000000.00, 30, 'App mobile với AI recommendation engine, chatbot hỗ trợ khách hàng, AR preview sản phẩm. Sử dụng React Native, TensorFlow Lite, ARKit/ARCore. Bao gồm admin panel web và analytics dashboard.', 'DaGui', '2026-04-20 08:52:00', '2026-04-22 10:46:00'),
	(13, 6, 13, 9000000.00, 14, 'UI frontend hiện đại với React 18, TypeScript, TailwindCSS. Responsive, lazy loading, code splitting, SEO-friendly. Tích hợp API backend, state management với Redux Toolkit. Giao source code và deployment guide.', 'DaGui', '2026-04-20 09:00:00', '2026-04-22 10:50:00'),
	(14, 6, 3, 10000000.00, 15, 'UI frontend React với Next.js 14, Server Components, App Router. Tối ưu performance, SEO, accessibility. Có unit tests, E2E tests với Playwright. Deploy lên Vercel với CI/CD tự động.', 'DaGui', '2026-04-20 09:02:00', '2026-04-22 10:51:00'),
	(15, 7, 13, 36000000.00, 45, 'Phát triển backend e-commerce hoàn chỉnh, bao gồm API quản trị, payment và shipping.', 'DuocChon', '2026-04-20 09:10:00', '2026-05-08 10:55:00'),
	(16, 7, 4, 39000000.00, 50, 'Giải pháp e-commerce sử dụng microservices và Kubernetes.', 'TuChoi', '2026-04-20 09:12:00', '2026-05-08 10:56:00'),
	(17, 9, 13, 8000000.00, 12, 'Dashboard KPI với biểu đồ realtime (Chart.js), bảng dữ liệu phân trang, filter nâng cao, export Excel/PDF. Sử dụng React, TypeScript, Material-UI. Responsive và có dark mode. Tích hợp WebSocket cho realtime updates.', 'DaGui', '2026-04-20 09:30:00', '2026-04-22 11:05:00'),
	(18, 9, 11, 8500000.00, 13, 'Dashboard AI-powered với predictive analytics, anomaly detection, automated insights. Sử dụng React, D3.js, TensorFlow.js. Có voice commands, natural language queries và mobile app companion.', 'DaGui', '2026-04-20 09:32:00', '2026-04-22 11:06:00'),
	(19, 12, 13, 14000000.00, 15, 'Bảo mật toàn diện: penetration testing, vulnerability assessment, security audit. Kiểm tra OWASP Top 10, SQL injection, XSS, CSRF. Báo cáo chi tiết với severity levels, proof of concept và remediation recommendations.', 'HetHan', '2026-04-20 10:00:00', '2026-05-11 11:20:00'),
	(20, 12, 16, 15000000.00, 16, 'Pentest chuyên sâu với automated tools (Burp Suite, OWASP ZAP) và manual testing. Bao gồm network security, application security, API security. Giao báo cáo executive summary và technical report chi tiết.', 'TuChoi', '2026-04-20 10:02:00', '2026-05-11 11:21:00'),
	(21, 13, 18, 6500000.00, 9, 'SEO technical: tối ưu Core Web Vitals, mobile-friendly, structured data, sitemap XML, robots.txt. Fix broken links, duplicate content, crawl errors. Báo cáo với Google Search Console và PageSpeed Insights.', 'DaGui', '2026-04-20 10:10:00', '2026-04-22 11:25:00'),
	(22, 13, 13, 6000000.00, 8, 'SEO technical tối ưu: page speed optimization, image compression, lazy loading, CDN setup, HTTPS migration. Tối ưu 15 trang quan trọng. Báo cáo trước/sau với metrics cụ thể.', 'DaGui', '2026-04-20 10:12:00', '2026-04-22 11:26:00'),
	(23, 13, 14, 7000000.00, 10, 'SEO + content marketing: keyword research, content plan 3 tháng, viết 12 bài blog SEO-friendly, tối ưu on-page SEO, internal linking strategy. Báo cáo traffic và ranking hàng tuần.', 'DaGui', '2026-04-20 10:13:00', '2026-04-22 11:27:00'),
	(24, 15, 13, 9500000.00, 18, 'Phát triển frontend React, TypeScript và TailwindCSS cho yêu cầu của người thuê 1.', 'DuocChon', '2026-04-20 10:30:00', '2026-05-14 11:35:00'),
	(25, 17, 13, 15000000.00, 20, 'Sàn thương mại điện tử với NestJS backend, React frontend. Tính năng: quản lý sản phẩm, đơn hàng, khách hàng, báo cáo doanh thu, tích hợp payment và shipping. Responsive, SEO-friendly, có admin panel.', 'DaGui', '2026-04-20 10:50:00', '2026-04-22 11:45:00'),
	(26, 17, 4, 16000000.00, 22, 'E-commerce fullstack với microservices: User service, Product service, Order service, Payment service. Sử dụng Docker, Kubernetes, RabbitMQ, Redis. Có monitoring, logging và automated backup.', 'DaGui', '2026-04-20 10:52:00', '2026-04-22 11:46:00'),
	(27, 19, 13, 9000000.00, 12, 'Branding hoàn chỉnh: logo, color palette, typography, brand voice, visual identity. Thiết kế business card, letterhead, presentation template, social media templates. Giao brand guideline 30+ trang.', 'DaGui', '2026-04-20 11:10:00', '2026-04-22 11:55:00'),
	(28, 19, 20, 9500000.00, 13, 'Branding + identity system: logo suite, brand patterns, iconography, photography style, illustration style. Thiết kế marketing materials, packaging mockups. Bao gồm brand strategy document.', 'DaGui', '2026-04-20 11:12:00', '2026-04-22 11:56:00'),
	(29, 23, 12, 9000000.00, 16, 'RPA automation với UiPath/Automation Anywhere: phân tích quy trình, thiết kế workflow, develop bots, testing, deployment. Tự động hóa 3-5 quy trình lặp đi lặp lại. Giao tài liệu và training cho team.', 'DaGui', '2026-04-20 11:50:00', '2026-04-22 12:15:00'),
	(30, 27, 20, 18000000.00, 25, 'Game design document hoàn chỉnh: concept, mechanics, level design, art direction, sound design. Prototype với Unity, playtest report. Giao GDD 50+ trang và prototype build.', 'DaGui', '2026-04-20 12:00:00', '2026-04-22 12:20:00'),
	(31, 20, 3, 38000000.00, 55, 'React Native app bán hàng với Firebase, push notification và thanh toán online.', 'DuocChon', '2026-04-24 09:00:00', '2026-05-15 09:00:00'),
	(32, 20, 13, 40000000.00, 50, 'Mobile app bán hàng đa nền tảng, kèm dashboard theo dõi đơn hàng.', 'TuChoi', '2026-04-24 09:10:00', '2026-05-15 09:10:00'),
	(33, 32, 13, 12000000.00, 20, 'Kiem thu cong thanh toan, tong hop test case va bao cao nghiem thu day du.', 'DuocChon', '2026-04-26 09:00:00', '2026-05-24 17:00:00'),
	(34, 33, 13, 16000000.00, 24, 'Trien khai dashboard doanh thu, bo loc nang cao va xuat bao cao Excel/PDF.', 'DuocChon', '2026-04-25 09:00:00', '2026-05-22 17:00:00')
ON CONFLICT ("BaoGiaID") DO NOTHING;

-- ============================================================
-- CONG VIEC: du an 3 da nop tien do 100%, dang cho xac nhan ban giao
-- ============================================================
INSERT INTO "CongViec"
	("CongViecID", "YeuCauID", "FreelancerID", "NguoiThueID", "GiamSatID", "GiaThoa", "ThoiGianThoa", "TrangThai", "NgayBatDau", "NgayKetThuc", "TrangThaiGiamSat", "PhiGiamSat", "FreelancerXacNhan", "GiamSatXacNhan", "NguoiThueXacNhan", "DaThanhToanEscrow", "NgayTao")
VALUES
	(1, 1, 13, 1, 21, 32000000.00, 30, 'DangThucHien', '2026-05-02 09:00:00', NULL, 'DangGiamSat', 450000.00, false, false, false, true, '2026-05-02 08:30:00'),
	(2, 7, 13, 1, 21, 36000000.00, 45, 'HoanThanh', '2026-04-10 09:00:00', '2026-05-08 17:00:00', 'HoanThanh', 450000.00, true, true, true, true, '2026-04-09 08:30:00'),
	(3, 15, 13, 1, 21, 9500000.00, 18, 'DangThucHien', '2026-05-14 09:00:00', NULL, 'DangGiamSat', 450000.00, false, false, false, true, '2026-05-14 08:30:00'),
	(4, 20, 3, 1, 21, 38000000.00, 55, 'DaHuy', NULL, NULL, 'HoanThanh', 450000.00, false, false, false, false, '2026-05-15 08:30:00'),
	(5, 2, 13, 2, 21, 30000000.00, 30, 'DangThucHien', '2026-05-03 09:00:00', NULL, 'DangGiamSat', 450000.00, false, false, false, true, '2026-05-03 08:30:00'),
	-- Da co tranh chap MoiMo: don vi giam sat 21 co the test tiep nhan xu ly.
	(6, 32, 13, 1, 21, 12000000.00, 20, 'HoanThanh', '2026-05-04 09:00:00', '2026-05-24 17:00:00', 'HoanThanh', 450000.00, true, true, true, true, '2026-05-04 08:30:00'),
	-- Da co tranh chap da ket luan hoan tien: dung de FE hien thi breakdown sau phan xu.
	(7, 33, 13, 1, 21, 16000000.00, 24, 'HoanThanh', '2026-05-01 09:00:00', '2026-05-22 17:00:00', 'HoanThanh', 450000.00, true, true, true, true, '2026-05-01 08:30:00')
ON CONFLICT ("CongViecID") DO NOTHING;

-- ============================================================
-- Cap nhat SoLuongBaoGia trong YeuCau dua tren BaoGia thuc te
-- ============================================================
UPDATE "YeuCau" yc
SET "SoLuongBaoGia" = (
	SELECT COUNT(*) FROM "BaoGia" bg WHERE bg."YeuCauID" = yc."YeuCauID"
);

-- ============================================================
-- KY NANG: Danh muc ky nang chung
-- ============================================================
INSERT INTO "KyNang" ("KyNangID", "TenKyNang", "MoTa")
VALUES
	-- Backend
	(1,  'NestJS',          'Framework Node.js cho backend'),
	(2,  'PostgreSQL',      'Hệ quản trị cơ sở dữ liệu quan hệ'),
	(3,  'Redis',           'In-memory cache và message broker'),
	(4,  'REST API',        'Thiết kế và phát triển RESTful API'),
	(5,  'GraphQL',         'Query language cho API'),
	(6,  'Docker',          'Container hóa ứng dụng'),
	(7,  'Kubernetes',      'Orchestration container'),
	(8,  'RabbitMQ',        'Message queue broker'),
	(9,  'Microservices',   'Kiến trúc microservices'),
	(10, 'JWT',             'JSON Web Token authentication'),
	-- Frontend
	(11, 'React',           'Thư viện UI JavaScript'),
	(12, 'Next.js',         'Framework React với SSR/SSG'),
	(13, 'Vue.js',          'Framework JavaScript progressive'),
	(14, 'TypeScript',      'JavaScript có kiểu tĩnh'),
	(15, 'TailwindCSS',     'Utility-first CSS framework'),
	-- Mobile
	(16, 'React Native',    'Framework mobile cross-platform'),
	(17, 'Flutter',         'Framework mobile của Google'),
	(18, 'Firebase',        'Backend-as-a-Service của Google'),
	-- UI/UX
	(19, 'Figma',           'Công cụ thiết kế giao diện'),
	(20, 'UI/UX Design',    'Thiết kế trải nghiệm người dùng'),
	(21, 'Wireframing',     'Phác thảo bố cục giao diện'),
	(22, 'Prototyping',     'Tạo prototype tương tác'),
	-- Marketing
	(23, 'SEO',             'Tối ưu hóa công cụ tìm kiếm'),
	(24, 'Google Ads',      'Quảng cáo trên Google'),
	(25, 'Social Media',    'Quản lý mạng xã hội'),
	(26, 'Content Writing', 'Viết nội dung marketing'),
	-- DevOps
	(27, 'CI/CD',           'Tích hợp và triển khai liên tục'),
	(28, 'GitHub Actions',  'Tự động hóa workflow trên GitHub'),
	(29, 'AWS',             'Amazon Web Services'),
	(30, 'Linux',           'Hệ điều hành Linux/Unix'),
	-- QA & Security
	(31, 'Testing',         'Kiểm thử phần mềm'),
	(32, 'Pentest',         'Kiểm thử bảo mật xâm nhập'),
	(33, 'OWASP',           'Tiêu chuẩn bảo mật web'),
	-- Design
	(34, 'Logo Design',     'Thiết kế logo và nhận diện thương hiệu'),
	(35, 'Brand Identity',  'Xây dựng bộ nhận diện thương hiệu'),
	-- AI/Data
	(36, 'Python',          'Ngôn ngữ lập trình Python'),
	(37, 'Machine Learning','Học máy và AI'),
	(38, 'Data Analytics',  'Phân tích dữ liệu')
ON CONFLICT ("KyNangID") DO NOTHING;

-- ============================================================
-- YEU CAU KY NANG: Ky nang yeu cau cho tung YeuCau
-- ============================================================
INSERT INTO "YeuCauKyNang" ("YeuCauID", "KyNangID")
VALUES
	-- YeuCau 1: Xây dựng API NestJS → NestJS, PostgreSQL, Redis, REST API, JWT
	(1, 1), (1, 2), (1, 3), (1, 4), (1, 10),
	-- YeuCau 2: API quản lý kho → NestJS, PostgreSQL, REST API, Docker
	(2, 1), (2, 2), (2, 4), (2, 6),
	-- YeuCau 3: Backend hệ thống CRM → NestJS, PostgreSQL, REST API, Redis, JWT
	(3, 1), (3, 2), (3, 3), (3, 4), (3, 10),
	-- YeuCau 4: API thanh toán → NestJS, PostgreSQL, REST API, JWT, Docker
	(4, 1), (4, 2), (4, 4), (4, 10), (4, 6),
	-- YeuCau 5: Microservices → NestJS, Docker, Kubernetes, RabbitMQ, Microservices, Redis
	(5, 1), (5, 6), (5, 7), (5, 8), (5, 9), (5, 3),
	-- YeuCau 6: API quản lý người dùng → NestJS, PostgreSQL, JWT, REST API
	(6, 1), (6, 2), (6, 4), (6, 10),
	-- YeuCau 7: Backend e-commerce → NestJS, PostgreSQL, Redis, REST API, Docker
	(7, 1), (7, 2), (7, 3), (7, 4), (7, 6),
	-- YeuCau 8: API báo cáo thống kê → NestJS, PostgreSQL, REST API
	(8, 1), (8, 2), (8, 4),
	-- YeuCau 9: Thiết kế landing page → Figma, UI/UX Design, Wireframing, Prototyping
	(9, 19), (9, 20), (9, 21), (9, 22),
	-- YeuCau 10: Thiết kế app mobile → Figma, UI/UX Design, Wireframing, Prototyping
	(10, 19), (10, 20), (10, 21), (10, 22),
	-- YeuCau 11: UI dashboard admin → Figma, UI/UX Design, Wireframing
	(11, 19), (11, 20), (11, 21),
	-- YeuCau 12: UX research và thiết kế → UI/UX Design, Wireframing, Prototyping, Figma
	(12, 19), (12, 20), (12, 21), (12, 22),
	-- YeuCau 13: Redesign website → Figma, UI/UX Design, Prototyping
	(13, 19), (13, 20), (13, 22),
	-- YeuCau 14: UI kit và design system → Figma, UI/UX Design
	(14, 19), (14, 20),
	-- YeuCau 15: Giao diện frontend React → React, TypeScript, TailwindCSS, Next.js
	(15, 11), (15, 14), (15, 15), (15, 12),
	-- YeuCau 16: Frontend dashboard → Vue.js, TypeScript
	(16, 13), (16, 14),
	-- YeuCau 17: Landing page responsive → React, TypeScript, TailwindCSS
	(17, 11), (17, 14), (17, 15),
	-- YeuCau 18: Frontend e-commerce → React, Next.js, TypeScript
	(18, 11), (18, 12), (18, 14),
	-- YeuCau 19: Web app Next.js → Next.js, React, TypeScript
	(19, 12), (19, 11), (19, 14),
	-- YeuCau 20: App mobile bán hàng → React Native, Firebase, TypeScript
	(20, 16), (20, 18), (20, 14),
	-- YeuCau 21: App quản lý công việc → Flutter, Firebase
	(21, 17), (21, 18),
	-- YeuCau 22: App giao hàng → React Native, Firebase
	(22, 16), (22, 18),
	-- YeuCau 23: App đặt lịch → Flutter, Firebase
	(23, 17), (23, 18),
	-- YeuCau 24: SEO tổng thể website → SEO
	(24, 23),
	-- YeuCau 25: Chiến dịch Google Ads → Google Ads, SEO
	(25, 24), (25, 23),
	-- YeuCau 26: Social media marketing → Social Media, Content Writing
	(26, 25), (26, 26),
	-- YeuCau 27: Xây dựng CI/CD → CI/CD, GitHub Actions, Docker
	(27, 27), (27, 28), (27, 6),
	-- YeuCau 28: Setup infrastructure → AWS, Docker, Kubernetes, Linux
	(28, 29), (28, 6), (28, 7), (28, 30),
	-- YeuCau 29: Thiết kế logo → Logo Design, Brand Identity, Figma
	(29, 34), (29, 35), (29, 19),
	-- YeuCau 30: Kiểm thử hệ thống → Testing, OWASP
	(30, 31), (30, 33),
	-- YeuCau 32: Nghiem thu cong thanh toan → Testing, OWASP
	(32, 31), (32, 33),
	-- YeuCau 33: Dashboard bao cao → React, TypeScript
	(33, 11), (33, 14)
ON CONFLICT DO NOTHING;

-- ============================================================
-- FREELANCER KY NANG: Ky nang cua tung Freelancer (chuan hoa)
-- ============================================================
INSERT INTO "FreelancerKyNang" ("TaiKhoanID", "KyNangID")
VALUES
	-- TaiKhoanID=3 (free_cuong): Frontend Engineer - React, Next.js, UI/UX, Figma, TypeScript, TailwindCSS
	(3, 11), (3, 12), (3, 20), (3, 19), (3, 14), (3, 15),
	-- TaiKhoanID=4 (free_duong): Backend Engineer - NestJS, PostgreSQL, Redis, Docker, JWT, REST API
	(4, 1), (4, 2), (4, 3), (4, 6), (4, 10), (4, 4),
	-- TaiKhoanID=11: AI Engineer - Python, Machine Learning, Data Analytics
	(11, 36), (11, 37), (11, 38),
	-- TaiKhoanID=12: Content Writer - SEO, Content Writing, Social Media
	(12, 23), (12, 26), (12, 25),
	-- TaiKhoanID=13: Fullstack Engineer - NestJS, PostgreSQL, React, TypeScript, Docker
	(13, 1), (13, 2), (13, 11), (13, 14), (13, 6),
	-- TaiKhoanID=14: Frontend Engineer - Vue.js, React, TypeScript, TailwindCSS
	(14, 13), (14, 11), (14, 14), (14, 15),
	-- TaiKhoanID=15: UX Researcher - UI/UX Design, Wireframing, Prototyping, Figma
	(15, 20), (15, 21), (15, 22), (15, 19),
	-- TaiKhoanID=16: Security Engineer - Pentest, OWASP, Testing, Linux
	(16, 32), (16, 33), (16, 31), (16, 30),
	-- TaiKhoanID=17: Video Editor - Content Writing, Social Media
	(17, 26), (17, 25),
	-- TaiKhoanID=18: SEO Specialist - SEO, Content Writing, Google Ads
	(18, 23), (18, 26), (18, 24),
	-- TaiKhoanID=19: Illustrator - Logo Design, Brand Identity, Figma
	(19, 34), (19, 35), (19, 19),
	-- TaiKhoanID=20: Game Designer - TypeScript, Docker, CI/CD
	(20, 14), (20, 6), (20, 27)
ON CONFLICT DO NOTHING;

-- ============================================================
-- YEU CAU GIAM SAT: Du 4 trang thai cho cac cong viec demo
-- ============================================================
INSERT INTO "YeuCauGiamSat"
	("YCGiamSatID", "CongViecID", "NguoiThueID", "GiamSatID", "FreelancerID", "TrangThai", "LyDoTuChoi", "PhiGiamSatThoa", "NgayYeuCau", "NgayChapNhan", "NgayHoanThanh")
VALUES
	(1, 1, 1, 21, 13, 'DaChapNhan', NULL, 450000.00, '2026-05-02 08:45:00', '2026-05-02 10:00:00', NULL),
	(2, 2, 1, 21, 13, 'HoanThanh', NULL, 450000.00, '2026-04-09 08:45:00', '2026-04-09 10:00:00', '2026-05-08 17:00:00'),
	(3, 4, 1, 21, 3, 'HoanThanh', NULL, 450000.00, '2026-05-15 08:45:00', '2026-05-15 09:00:00', '2026-05-15 10:00:00'),
	(4, 5, 2, 21, 13, 'DaChapNhan', NULL, 450000.00, '2026-05-03 08:45:00', '2026-05-03 09:00:00', NULL),
	(5, 3, 1, 21, 13, 'DaChapNhan', NULL, 450000.00, '2026-05-14 08:45:00', '2026-05-14 10:00:00', NULL),
	(6, 6, 1, 21, 13, 'HoanThanh', NULL, 450000.00, '2026-05-04 08:45:00', '2026-05-04 10:00:00', '2026-05-24 17:00:00'),
	(7, 7, 1, 21, 13, 'HoanThanh', NULL, 450000.00, '2026-05-01 08:45:00', '2026-05-01 10:00:00', '2026-05-22 17:00:00')
ON CONFLICT ("YCGiamSatID") DO NOTHING;

-- ============================================================
-- TIEN DO: Chua xac nhan, da xac nhan va tu choi
-- ============================================================
INSERT INTO "TienDo"
	("TienDoID", "CongViecID", "TaiKhoanID", "TieuDe", "MoTa", "PhanTram", "TepDinhKem", "XacNhanBoi", "TrangThaiXacNhan", "NgayTao")
VALUES
	(1, 1, 13, 'Hoan thanh thiet ke database', 'Da tao schema va cac migration ban dau.', 30, 'uploads/progress/database-design.pdf', NULL, 'ChuaXacNhan', '2026-05-06 09:00:00'),
	(2, 1, 13, 'API xac thuc va phan quyen', 'Da hoan thanh JWT va RBAC, duoc giam sat 21 xac nhan.', 55, 'uploads/progress/auth-api.pdf', 21, 'DaXacNhan', '2026-05-12 09:00:00'),
	(3, 3, 13, 'Ban giao giao dien hoan chinh', 'Freelancer da nop ban giao giao dien dat moc 100%, dang cho don vi giam sat xac nhan chat luong.', 100, 'uploads/progress/frontend-final.zip', NULL, 'ChuaXacNhan', '2026-05-18 09:00:00'),
	(4, 6, 13, 'Ban giao ban kiem thu nghiem thu', 'Da nop ket qua kiem thu cong thanh toan o muc 100%; nguoi thue co the khieu nai neu ket qua khong dat mong doi.', 100, 'uploads/progress/payment-acceptance-final.pdf', 21, 'DaXacNhan', '2026-05-24 16:00:00'),
	(5, 7, 13, 'Ban giao dashboard doanh thu', 'San pham dashboard da hoan thanh 100% va sau do phat sinh khieu nai ve du lieu xuat bao cao.', 100, 'uploads/progress/revenue-dashboard-final.zip', 21, 'DaXacNhan', '2026-05-22 16:00:00')
ON CONFLICT ("TienDoID") DO NOTHING;

-- ============================================================
-- THANH TOAN: Du loai thanh toan, phuong thuc va trang thai
-- ============================================================
INSERT INTO "ThanhToan"
	("ThanhToanID", "CongViecID", "TaiKhoanID", "SoTien", "LoaiTT", "PhuongThuc", "TrangThai", "GhiChu", "NgayTao")
VALUES
	(1, 1, 1, 32450000.00, 'DatCoc', 'Vi', 'ThanhCong', 'Escrow cho cong viec API dang thuc hien.', '2026-05-02 08:35:00'),
	(2, 2, 1, 36450000.00, 'DatCoc', 'ChuyenKhoan', 'ThanhCong', 'Escrow du an backend e-commerce.', '2026-04-09 08:35:00'),
	(6, 3, 1, 9950000.00, 'DatCoc', 'Vi', 'ThanhCong', 'Escrow dang duoc giu trong khi cho xac nhan ban giao 100 phan tram.', '2026-05-14 08:35:00'),
	(8, 4, 1, 38450000.00, 'DatCoc', 'ThanhToanQuaMang', 'ThatBai', 'Giao dich khong thanh cong truoc khi huy cong viec.', '2026-05-15 08:35:00'),
	(9, 5, 2, 30450000.00, 'DatCoc', 'Vi', 'ChoXuLy', 'Cho nguoi thue xac nhan nap escrow.', '2026-05-03 08:35:00'),
	(10, 6, 1, 12450000.00, 'DatCoc', 'Vi', 'ThanhCong', 'Escrow cho du an kiem thu nghiem thu cong thanh toan.', '2026-05-04 08:35:00'),
	(11, 6, 1, 11400000.00, 'ThanhToanCuoi', 'Vi', 'ThanhCong', 'Giai ngan cho freelancer sau khi ban giao ket qua 100%.', '2026-05-24 17:10:00'),
	(12, 6, 1, 600000.00, 'PhiHeThong', 'Vi', 'ThanhCong', 'Phi he thong 5 phan tram cho cong viec 6.', '2026-05-24 17:11:00'),
	(13, 6, 1, 450000.00, 'PhiGiamSat', 'Vi', 'ThanhCong', 'Phi giam sat cho cong viec 6.', '2026-05-24 17:12:00'),
	(14, 7, 1, 16450000.00, 'DatCoc', 'Vi', 'DaHoan', 'Escrow da duoc phan bo theo ket luan tranh chap #3.', '2026-05-01 08:35:00'),
	(15, 7, 1, 5000000.00, 'HoanTien', 'Vi', 'ThanhCong', 'Hoan tien cho nguoi thue theo ket luan tranh chap #3.', '2026-05-25 10:10:00'),
	(16, 7, 1, 10022500.00, 'ThanhToanCuoi', 'Vi', 'ThanhCong', 'Freelancer nhan phan con lai sau khi tru phi he thong theo tranh chap #3.', '2026-05-25 10:11:00'),
	(17, 7, 1, 450000.00, 'PhiGiamSat', 'Vi', 'ThanhCong', 'Don vi giam sat nhan 100 phan tram phi giam sat theo tranh chap #3.', '2026-05-25 10:12:00'),
	(18, 7, 1, 527500.00, 'PhiHeThong', 'Vi', 'ThanhCong', 'Phi he thong 5 phan tram tren phan freelancer gross theo tranh chap #3.', '2026-05-25 10:13:00')
ON CONFLICT ("ThanhToanID") DO NOTHING;

-- ============================================================
-- TRANH CHAP: khach hang chi khieu nai ket qua sau khi cong viec da hoan thanh
-- ============================================================
INSERT INTO "TranhChap"
	("TranhChapID", "CongViecID", "NguoiGuiID", "GiamSatID", "LyDo", "MoTa", "TrangThai", "YeuCauHoanTien", "NgayMo", "NgayDong")
VALUES
	(2, 2, 1, 21, 'Ket qua API thieu bao cao da cam ket', 'Du an da hoan thanh nhung cac endpoint bao cao quan trong chua dung dac ta.', 'DangXuLy', 3000000.00, '2026-05-19 08:00:00', NULL),
	(3, 7, 1, 21, 'Dashboard xuat sai tong doanh thu', 'Nguoi thue khong hai long vi bao cao Excel va so lieu tong hop khong khop voi tieu chi nghiem thu.', 'DaKetLuan', 5000000.00, '2026-05-23 08:00:00', '2026-05-25 10:00:00'),
	(4, 6, 1, 21, 'Ket qua kiem thu cong thanh toan chua day du', 'Nguoi thue can don vi giam sat xem lai bao cao test case va cac bang chung nghiem thu.', 'MoiMo', 2000000.00, '2026-05-26 08:00:00', NULL)
ON CONFLICT ("TranhChapID") DO NOTHING;

-- Ket luan tranh chap #3 theo nghiep vu moi:
-- totalContractAmount = 16,000,000; supervisorFee = 450,000; refundToEmployer = 5,000,000
-- freelancerGross = 10,550,000; systemFee = 527,500; freelancerNet = 10,022,500.
INSERT INTO "KetLuanTranhChap"
	("KetLuanID", "TranhChapID", "GiamSatID", "KetQua", "LyDo", "SoTienHoan", "SoTienFreelancer", "SoTienGiamSat", "SoTienHeThong", "BenChiuPhi", "NgayKetLuan")
VALUES
	(1, 3, 21, 'HoanTienNguoiThue', 'Dashboard co sai lech so lieu xuat bao cao; hoan mot phan cho nguoi thue, giam sat nhan du phi, freelancer nhan phan con lai sau phi he thong.', 5000000.00, 10022500.00, 450000.00, 527500.00, 'ChiaSe', '2026-05-25 10:00:00')
ON CONFLICT ("KetLuanID") DO NOTHING;

UPDATE "CongViec"
SET
	"TrangThai" = 'DaHuy',
	"TrangThaiGiamSat" = 'HoanThanh',
	"NgayKetThuc" = '2026-05-25 10:00:00'
WHERE "CongViecID" = 7;

INSERT INTO "BangChungTranhChap"
	("BangChungID", "TranhChapID", "NguoiNopID", "LoaiBangChung", "NoiDung", "DuongDanFile", "NgayNop")
VALUES
	(5, 2, 1, 'KhacP', 'Danh sach endpoint bao cao chua dung dac ta.', 'uploads/evidence/report-api-checklist.xlsx', '2026-05-20 09:00:00'),
	(6, 3, 1, 'File', 'File Excel xuat tu dashboard cho thay so lieu tong doanh thu khong khop.', 'uploads/evidence/revenue-export-mismatch.xlsx', '2026-05-23 09:00:00'),
	(7, 3, 13, 'TinNhan', 'Freelancer gui giai trinh ve cach tinh doanh thu trong dashboard.', NULL, '2026-05-24 09:00:00'),
	(8, 4, 1, 'File', 'Nguoi thue nop bang chung cac test case thanh toan chua duoc bao phu.', 'uploads/evidence/payment-test-missing-cases.xlsx', '2026-05-26 09:00:00')
ON CONFLICT ("BangChungID") DO NOTHING;

-- ============================================================
-- CHAT: Du trang thai hoi thoai va loai tin nhan
-- ============================================================
INSERT INTO "CuocHoiThoai"
	("CuocHoiThoaiID", "CongViecID", "ThanhVien1ID", "ThanhVien2ID", "TinNhanCuoi", "TrangThai", "NgayTao")
VALUES
	(1, 1, 1, 13, '2026-05-20 10:10:00', 'DangMo', '2026-05-02 10:00:00'),
	(2, 2, 1, 13, '2026-05-08 18:00:00', 'DaDong', '2026-04-10 10:00:00'),
	(3, 3, 1, 21, '2026-05-22 11:00:00', 'DangMo', '2026-05-18 10:00:00'),
	(4, 7, 1, 21, '2026-05-24 10:00:00', 'DangMo', '2026-05-23 10:00:00')
ON CONFLICT ("CuocHoiThoaiID") DO NOTHING;

INSERT INTO "TinNhan"
	("TinNhanID", "CuocHoiThoaiID", "NguoiGuiID", "NoiDung", "LoaiTin", "DaDoc", "NgayTao")
VALUES
	(1, 1, 1, 'Minh gui lai yeu cau API va deadline sprint dau.', 'VanBan', true, '2026-05-02 10:01:00'),
	(2, 1, 13, 'Tai lieu API ban nhap.', 'File', true, '2026-05-12 10:00:00'),
	(3, 1, 13, 'Anh chup man hinh dashboard monitoring.', 'HinhAnh', false, '2026-05-20 10:05:00'),
	(4, 2, 1, 'Cam on ban da hoan thanh du an.', 'VanBan', true, '2026-05-08 18:00:00'),
	(5, 3, 21, 'Don vi giam sat dang kiem tra ban giao 100 phan tram truoc khi xac nhan.', 'VanBan', false, '2026-05-22 11:00:00'),
	(6, 1, 21, 'Toi da xac nhan moc API va se theo doi sprint tiep theo.', 'VanBan', false, '2026-05-20 10:10:00'),
	(7, 4, 1, 'Bao cao doanh thu xuat ra khong dung voi du lieu nghiem thu.', 'VanBan', true, '2026-05-23 10:01:00'),
	(8, 4, 21, 'Don vi giam sat da tiep nhan va dang xem xet bang chung.', 'VanBan', false, '2026-05-24 10:00:00')
ON CONFLICT ("TinNhanID") DO NOTHING;

-- ============================================================
-- DANH GIA: Du loai danh gia giua nguoi thue 1, freelancer 13 va giam sat 21
-- ============================================================
INSERT INTO "DanhGia"
	("DanhGiaID", "CongViecID", "NguoiDanhGiaID", "NguoiDuocDGID", "DiemSo", "BinhLuan", "LoaiDanhGia", "NgayTao")
VALUES
	(1, 2, 1, 13, 5, 'Ban giao dung cam ket va giao tiep ro rang.', 'NguoiThue_DanhGia_Freelancer', '2026-05-09 09:00:00'),
	(2, 2, 13, 1, 5, 'Nguoi thue phan hoi nhanh va yeu cau minh bach.', 'Freelancer_DanhGia_NguoiThue', '2026-05-09 09:05:00'),
	(3, 2, 1, 21, 5, 'Giam sat ho tro xac nhan chat luong kip thoi.', 'NguoiThue_DanhGia_GiamSat', '2026-05-09 09:10:00'),
	(4, 2, 13, 21, 4, 'Quy trinh giam sat ro rang va cong bang.', 'Freelancer_DanhGia_GiamSat', '2026-05-09 09:15:00'),
	(5, 2, 21, 13, 5, 'Freelancer nop du bang chung va san pham dat yeu cau.', 'GiamSat_DanhGia_Freelancer', '2026-05-09 09:20:00'),
	(6, 2, 21, 1, 5, 'Nguoi thue hop tac tot trong nghiem thu.', 'GiamSat_DanhGia_NguoiThue', '2026-05-09 09:25:00')
ON CONFLICT ("DanhGiaID") DO NOTHING;

-- ============================================================
-- THONG BAO: Du cac loai thong bao cho nhom user demo
-- ============================================================
INSERT INTO "ThongBao"
	("ThongBaoID", "TaiKhoanID", "TieuDe", "NoiDung", "LoaiThongBao", "DaDoc", "NgayTao")
VALUES
	(1, 1, 'Thong bao he thong', 'He thong da cap nhat chinh sach escrow.', 'HeThong', true, '2026-05-01 08:00:00'),
	(2, 13, 'Yeu cau phu hop', 'Co yeu cau backend moi tu nguoi thue 1.', 'YeuCau', false, '2026-04-19 10:00:00'),
	(3, 1, 'Bao gia moi', 'Freelancer 13 da gui bao gia cho yeu cau API.', 'BaoGia', true, '2026-04-20 08:01:00'),
	(4, 13, 'Cong viec duoc tao', 'Bao gia cua ban da duoc chot thanh cong viec.', 'CongViec', true, '2026-05-02 08:31:00'),
	(5, 21, 'Ban giao can xac nhan', 'Cong viec frontend da nop tien do 100 phan tram va dang cho xac nhan.', 'GiamSat', false, '2026-05-18 08:01:00'),
	(6, 21, 'Moi giam sat', 'Ban duoc moi giam sat cong viec API.', 'GiamSat', true, '2026-05-02 08:46:00'),
	(7, 1, 'Thanh toan escrow', 'Khoan dat coc da duoc giu an toan.', 'ThanhToan', true, '2026-05-02 08:36:00'),
	(8, 13, 'Danh gia moi', 'Nguoi thue 1 da danh gia cong viec hoan thanh.', 'DanhGia', false, '2026-05-09 09:01:00'),
	(9, 1, 'Ban giao san sang danh gia', 'Cong viec kiem thu cong thanh toan da ban giao 100 phan tram de nghiem thu.', 'CongViec', false, '2026-05-24 17:01:00'),
	(10, 21, 'Tranh chap dashboard da ket luan', 'Tranh chap cong viec 7 da ket luan hoan tien mot phan va phan bo escrow theo breakdown moi.', 'TranhChap', false, '2026-05-25 10:01:00'),
	(11, 21, 'Tranh chap moi can tiep nhan', 'Tranh chap cong viec 6 dang o trang thai MoiMo de don vi giam sat bat dau xu ly.', 'TranhChap', false, '2026-05-26 08:01:00')
ON CONFLICT ("ThongBaoID") DO NOTHING;

-- ============================================================
-- BAO CAO: Du 4 trang thai xu ly
-- ============================================================
INSERT INTO "BaoCao"
	("BaoCaoID", "NguoiBaoCaoID", "NguoiBiCaoID", "LyDo", "MoTa", "TrangThai", "KetQua", "AdminXuLyID", "NgayTao", "NgayXuLy")
VALUES
	(1, 1, 13, 'Cham phan hoi', 'Can admin kiem tra thoi gian phan hoi trong du an.', 'ChoXuLy', NULL, NULL, '2026-05-18 10:00:00', NULL),
	(2, 13, 1, 'Yeu cau thay doi pham vi', 'Admin dang thu thap noi dung trao doi.', 'DangXuLy', NULL, 6, '2026-05-19 10:00:00', NULL),
	(3, 1, 13, 'Bao cao da giai quyet', 'Hai ben da thong nhat cach tiep tuc.', 'DaXuLy', 'Khong ghi nhan vi pham; theo doi trong sprint tiep theo.', 6, '2026-05-20 10:00:00', '2026-05-21 10:00:00'),
	(4, 13, 21, 'Bao cao nham', 'Nguoi gui xac nhan gui nham noi dung.', 'HuyBo', 'Bao cao duoc huy theo yeu cau nguoi gui.', 6, '2026-05-21 10:00:00', '2026-05-21 12:00:00')
ON CONFLICT ("BaoCaoID") DO NOTHING;

INSERT INTO "KhuyenMai"
	("KhuyenMaiID", "MaCode", "LoaiGiam", "GiaTriGiam", "GiaTriToiDa", "SoLuotDung", "GioiHanLuot", "TrangThai", "NgayBatDau", "NgayKetThuc")
VALUES
	(1, 'NEWUSER10', 'PhanTram', 10.00, 500000.00, 0, 100, 'HoatDong', '2026-04-01 00:00:00', '2026-12-31 23:59:59'),
	(2, 'SUMMER2026', 'PhanTram', 15.00, 1000000.00, 5, 200, 'HoatDong', '2026-06-01 00:00:00', '2026-08-31 23:59:59'),
	(3, 'FLASH50K', 'SoTienCo', 50000.00, 50000.00, 12, 50, 'HoatDong', '2026-04-15 00:00:00', '2026-05-15 23:59:59'),
	(4, 'VIP20', 'PhanTram', 20.00, 2000000.00, 3, 30, 'HoatDong', '2026-04-01 00:00:00', '2026-12-31 23:59:59'),
	(5, 'WEEKEND', 'PhanTram', 12.00, 800000.00, 8, 150, 'HoatDong', '2026-04-01 00:00:00', '2026-12-31 23:59:59'),
	(6, 'FIRST100K', 'SoTienCo', 100000.00, 100000.00, 25, 100, 'HoatDong', '2026-04-01 00:00:00', '2026-06-30 23:59:59'),
	(7, 'MEGA25', 'PhanTram', 25.00, 3000000.00, 2, 20, 'ThuHoi', '2026-05-01 00:00:00', '2026-05-31 23:59:59'),
	(8, 'SAVE200K', 'SoTienCo', 200000.00, 200000.00, 10, 50, 'HoatDong', '2026-04-10 00:00:00', '2026-07-10 23:59:59'),
	(9, 'SPRING15', 'PhanTram', 15.00, 1500000.00, 7, 100, 'HetHan', '2026-03-01 00:00:00', '2026-03-31 23:59:59'),
	(10, 'LOYAL30', 'PhanTram', 30.00, 5000000.00, 1, 10, 'HoatDong', '2026-04-01 00:00:00', '2026-12-31 23:59:59'),
	(11, 'QUICK50K', 'SoTienCo', 50000.00, 50000.00, 18, 200, 'HoatDong', '2026-04-01 00:00:00', '2026-06-30 23:59:59'),
	(12, 'SUPER18', 'PhanTram', 18.00, 1200000.00, 6, 80, 'HoatDong', '2026-04-20 00:00:00', '2026-08-20 23:59:59'),
	(13, 'BONUS150K', 'SoTienCo', 150000.00, 150000.00, 9, 60, 'HoatDong', '2026-05-01 00:00:00', '2026-07-31 23:59:59'),
	(14, 'HAPPY22', 'PhanTram', 22.00, 2500000.00, 4, 40, 'HoatDong', '2026-04-01 00:00:00', '2026-12-31 23:59:59'),
	(15, 'DEAL100K', 'SoTienCo', 100000.00, 100000.00, 15, 120, 'HoatDong', '2026-04-15 00:00:00', '2026-09-15 23:59:59'),
	(16, 'PROMO8', 'PhanTram', 8.00, 400000.00, 20, 250, 'HoatDong', '2026-04-01 00:00:00', '2026-12-31 23:59:59'),
	(17, 'SAVE300K', 'SoTienCo', 300000.00, 300000.00, 3, 25, 'HoatDong', '2026-06-01 00:00:00', '2026-08-31 23:59:59'),
	(18, 'GOLD35', 'PhanTram', 35.00, 7000000.00, 0, 5, 'HoatDong', '2026-04-01 00:00:00', '2026-12-31 23:59:59'),
	(19, 'FLASH80K', 'SoTienCo', 80000.00, 80000.00, 22, 150, 'HoatDong', '2026-04-10 00:00:00', '2026-10-10 23:59:59'),
	(20, 'SALE12', 'PhanTram', 12.00, 900000.00, 11, 180, 'HoatDong', '2026-04-01 00:00:00', '2026-12-31 23:59:59'),
	(21, 'WINTER20', 'PhanTram', 20.00, 1800000.00, 0, 70, 'HoatDong', '2026-12-01 00:00:00', '2027-02-28 23:59:59'),
	(22, 'GIFT120K', 'SoTienCo', 120000.00, 120000.00, 14, 90, 'HoatDong', '2026-04-01 00:00:00', '2026-11-30 23:59:59'),
	(23, 'BEST28', 'PhanTram', 28.00, 4000000.00, 2, 15, 'HoatDong', '2026-05-15 00:00:00', '2026-07-15 23:59:59'),
	(24, 'SAVE250K', 'SoTienCo', 250000.00, 250000.00, 8, 45, 'HoatDong', '2026-04-20 00:00:00', '2026-08-20 23:59:59'),
	(25, 'SMART16', 'PhanTram', 16.00, 1100000.00, 13, 110, 'HoatDong', '2026-04-01 00:00:00', '2026-12-31 23:59:59'),
	(26, 'BONUS70K', 'SoTienCo', 70000.00, 70000.00, 19, 160, 'HoatDong', '2026-04-05 00:00:00', '2026-09-05 23:59:59'),
	(27, 'ULTRA40', 'PhanTram', 40.00, 10000000.00, 0, 3, 'HoatDong', '2026-04-01 00:00:00', '2026-12-31 23:59:59'),
	(28, 'QUICK90K', 'SoTienCo', 90000.00, 90000.00, 16, 130, 'HoatDong', '2026-04-10 00:00:00', '2026-10-10 23:59:59'),
	(29, 'DEAL14', 'PhanTram', 14.00, 1000000.00, 9, 140, 'HoatDong', '2026-04-01 00:00:00', '2026-12-31 23:59:59'),
	(30, 'SAVE180K', 'SoTienCo', 180000.00, 180000.00, 7, 75, 'HoatDong', '2026-05-01 00:00:00', '2026-11-30 23:59:59')
ON CONFLICT ("KhuyenMaiID") DO NOTHING;


SELECT setval(pg_get_serial_sequence('"LoaiDichVu"', 'LoaiDichVuID'), COALESCE(MAX("LoaiDichVuID"), 1), true) FROM "LoaiDichVu";
SELECT setval(pg_get_serial_sequence('"TaiKhoan"', 'TaiKhoanID'), COALESCE(MAX("TaiKhoanID"), 1), true) FROM "TaiKhoan";
SELECT setval(pg_get_serial_sequence('"NguoiThue"', 'NguoiThueID'), COALESCE(MAX("NguoiThueID"), 1), true) FROM "NguoiThue";
SELECT setval(pg_get_serial_sequence('"Freelancer"', 'FreelancerID'), COALESCE(MAX("FreelancerID"), 1), true) FROM "Freelancer";
SELECT setval(pg_get_serial_sequence('"DonViGiamSat"', 'GiamSatID'), COALESCE(MAX("GiamSatID"), 1), true) FROM "DonViGiamSat";
SELECT setval(pg_get_serial_sequence('"KyNang"', 'KyNangID'), COALESCE(MAX("KyNangID"), 1), true) FROM "KyNang";
SELECT setval(pg_get_serial_sequence('"YeuCau"', 'YeuCauID'), COALESCE(MAX("YeuCauID"), 1), true) FROM "YeuCau";
SELECT setval(pg_get_serial_sequence('"BaoGia"', 'BaoGiaID'), COALESCE(MAX("BaoGiaID"), 1), true) FROM "BaoGia";
SELECT setval(pg_get_serial_sequence('"CongViec"', 'CongViecID'), COALESCE(MAX("CongViecID"), 1), true) FROM "CongViec";
SELECT setval(pg_get_serial_sequence('"YeuCauGiamSat"', 'YCGiamSatID'), COALESCE(MAX("YCGiamSatID"), 1), true) FROM "YeuCauGiamSat";
SELECT setval(pg_get_serial_sequence('"TienDo"', 'TienDoID'), COALESCE(MAX("TienDoID"), 1), true) FROM "TienDo";
SELECT setval(pg_get_serial_sequence('"ThanhToan"', 'ThanhToanID'), COALESCE(MAX("ThanhToanID"), 1), true) FROM "ThanhToan";
SELECT setval(pg_get_serial_sequence('"TranhChap"', 'TranhChapID'), COALESCE(MAX("TranhChapID"), 1), true) FROM "TranhChap";
SELECT setval(pg_get_serial_sequence('"YeuCauHoanTien"', 'YeuCauHoanTienID'), COALESCE(MAX("YeuCauHoanTienID"), 1), true) FROM "YeuCauHoanTien";
SELECT setval(pg_get_serial_sequence('"BangChungTranhChap"', 'BangChungID'), COALESCE(MAX("BangChungID"), 1), true) FROM "BangChungTranhChap";
SELECT setval(pg_get_serial_sequence('"KetLuanTranhChap"', 'KetLuanID'), COALESCE(MAX("KetLuanID"), 1), true) FROM "KetLuanTranhChap";
SELECT setval(pg_get_serial_sequence('"CuocHoiThoai"', 'CuocHoiThoaiID'), COALESCE(MAX("CuocHoiThoaiID"), 1), true) FROM "CuocHoiThoai";
SELECT setval(pg_get_serial_sequence('"TinNhan"', 'TinNhanID'), COALESCE(MAX("TinNhanID"), 1), true) FROM "TinNhan";
SELECT setval(pg_get_serial_sequence('"DanhGia"', 'DanhGiaID'), COALESCE(MAX("DanhGiaID"), 1), true) FROM "DanhGia";
SELECT setval(pg_get_serial_sequence('"ThongBao"', 'ThongBaoID'), COALESCE(MAX("ThongBaoID"), 1), true) FROM "ThongBao";
SELECT setval(pg_get_serial_sequence('"BaoCao"', 'BaoCaoID'), COALESCE(MAX("BaoCaoID"), 1), true) FROM "BaoCao";
SELECT setval(pg_get_serial_sequence('"KhuyenMai"', 'KhuyenMaiID'), COALESCE(MAX("KhuyenMaiID"), 1), true) FROM "KhuyenMai";

COMMIT;
