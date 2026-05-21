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
	"YeuCau",
	"YeuCauGiamSat",
	"YeuCauKyNang"
RESTART IDENTITY CASCADE;

INSERT INTO "LoaiDichVu" ("LoaiDichVuID", "TenLoai", "MoTa", "HinhAnh")
VALUES
	(1, 'Thiết kế UI/UX', 'Thiết kế giao diện web và mobile', 'uiux.png'),
	(2, 'Lập trình backend', 'Phát triển API, hệ thống nghiệp vụ', 'backend.png'),
	(3, 'Digital marketing', 'SEO, quảng cáo, social media', 'marketing.png'),
	(4, 'Thiết kế logo', 'Logo và brand identity', 'logo.png'),
	(5, 'Mobile app', 'Phát triển ứng dụng di động', 'mobile.png'),
	(6, 'Frontend web', 'Giao diện web hiện đại', 'frontend.png'),
	(7, 'DevOps', 'CI/CD và hạ tầng', 'devops.png'),
	(8, 'QA testing', 'Kiểm thử và báo cáo lỗi', 'qa.png'),
	(9, 'Data analytics', 'Phân tích dữ liệu', 'data.png'),
	(10, 'AI/ML', 'Mô hình học máy', 'ai.png')
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
	(27, 'user_27', '123123', 'user27@example.com', 'User 27', '0901000027', 'Nam', 'Vung Tau', 'DonViGiamSat', 'HoatDong', '2026-04-18 10:40:00', '2026-04-22 11:10:00'),
	(28, 'user_28', '123123', 'user28@example.com', 'User 28', '0901000028', 'Nu', 'Ha Noi', 'DonViGiamSat', 'HoatDong', '2026-04-18 10:45:00', '2026-04-22 11:15:00'),
	(29, 'user_29', '123123', 'user29@example.com', 'User 29', '0901000029', 'Nam', 'TP HCM', 'Admin', 'HoatDong', '2026-04-18 10:50:00', '2026-04-22 11:20:00'),
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
	(3, 22, 'Tech Audit Pro', 'Giam sat ky thuat chuyen nghiep', 'Quy trinh, audit, kiem thu', 'CERT-TECH', 480000.00, 4.35, 28, 'HoatDong', '2026-04-12 09:00:00'),
	(4, 23, 'QA Supervisors', 'Don vi dam bao chat luong', 'Bao cao, kiem thu, QA', 'QA-CERT', 520000.00, 4.40, 30, 'HoatDong', '2026-04-13 09:00:00'),
	(5, 24, 'Process Control', 'Kiem soat quy trinh', 'Quy trinh, ISO, audit', 'ISO-PROC', 500000.00, 4.20, 22, 'HoatDong', '2026-04-14 09:00:00'),
	(6, 25, 'Quality Assurance', 'Dam bao chat luong toan dien', 'Kiem thu, QA, bao cao', 'QA-PRO', 530000.00, 4.45, 32, 'HoatDong', '2026-04-15 09:00:00'),
	(7, 26, 'Audit & Report', 'Kiem toan va bao cao', 'Audit, bao cao, quy trinh', 'AUDIT-CERT', 470000.00, 4.15, 20, 'HoatDong', '2026-04-16 09:00:00'),
	(8, 27, 'Security Watch', 'Giam sat bao mat', 'Bao cao, quy trinh, bao mat', 'SEC-CERT', 460000.00, 4.25, 24, 'HoatDong', '2026-04-17 09:00:00'),
	(9, 28, 'ISO Compliance', 'Tuan thu tieu chuan ISO', 'ISO, bao mat, kiem thu', 'ISO-COMP', 540000.00, 4.50, 36, 'HoatDong', '2026-04-18 09:00:00')
ON CONFLICT ("GiamSatID") DO NOTHING;

INSERT INTO "YeuCau"
	("YeuCauID", "TaiKhoanID", "LoaiDichVuID", "GiamSatID", "TieuDe", "MoTa", "NganSachMin", "NganSachMax", "ThoiHan", "TrangThai", "SoLuongBaoGia", "YeuCauGiamSat", "NgayTao", "NgayCapNhat")
VALUES
	-- Backend (8 yêu cầu - nhiều nhất)
	(1, 1, 2, 5, 'Xây dựng API NestJS', 'Cần xây dựng hệ thống API RESTful quản lý đơn hàng và thanh toán. Yêu cầu tích hợp cổng thanh toán VNPay, Momo, xử lý đơn hàng realtime, quản lý trạng thái đơn hàng và gửi thông báo tự động cho khách hàng.', 25000000.00, 40000000.00, '2026-06-01', 'DangMo', 0, true, '2026-04-19 10:00:00', '2026-04-22 10:00:00'),
	(2, 2, 2, 21, 'API quản lý kho', 'Xây dựng API quản lý kho hàng và tồn kho với các tính năng: nhập/xuất kho, kiểm kê tự động, cảnh báo hàng sắp hết, báo cáo tồn kho theo thời gian thực. Cần tích hợp với hệ thống bán hàng hiện tại.', 20000000.00, 35000000.00, '2026-06-05', 'DangMo', 0, true, '2026-04-19 10:10:00', '2026-04-22 10:05:00'),
	(3, 7, 2, NULL, 'Backend hệ thống CRM', 'Phát triển backend cho hệ thống CRM quản lý khách hàng, lịch sử tương tác, phân loại khách hàng, tự động hóa email marketing và báo cáo phân tích hành vi khách hàng. Yêu cầu có API cho mobile app.', 30000000.00, 50000000.00, '2026-06-10', 'DangMo', 0, false, '2026-04-19 10:20:00', '2026-04-22 10:10:00'),
	(4, 8, 2, 22, 'API thanh toán', 'Tích hợp cổng thanh toán quốc tế (Stripe, PayPal) và nội địa (VNPay, ZaloPay). Xử lý giao dịch an toàn, hoàn tiền tự động, lưu lịch sử giao dịch và tạo báo cáo doanh thu theo ngày/tháng.', 18000000.00, 30000000.00, '2026-06-15', 'DangMo', 0, true, '2026-04-19 10:30:00', '2026-04-22 10:15:00'),
	(5, 9, 2, NULL, 'Microservices architecture', 'Xây dựng kiến trúc microservices cho hệ thống lớn với các service: User, Product, Order, Payment, Notification. Sử dụng RabbitMQ/Kafka cho message queue, Redis cho caching, và Docker/Kubernetes cho deployment.', 35000000.00, 60000000.00, '2026-06-20', 'DangMo', 0, false, '2026-04-19 10:40:00', '2026-04-22 10:20:00'),
	(6, 10, 2, 23, 'API quản lý người dùng', 'Backend quản lý người dùng với authentication JWT, phân quyền RBAC chi tiết, quản lý profile, đổi mật khẩu, xác thực 2FA, và tích hợp đăng nhập qua Google/Facebook. Cần có audit log đầy đủ.', 15000000.00, 28000000.00, '2026-06-25', 'DangMo', 0, true, '2026-04-19 10:50:00', '2026-04-22 10:25:00'),
	(7, 1, 2, NULL, 'Backend e-commerce', 'Hệ thống backend hoàn chỉnh cho sàn thương mại điện tử: quản lý sản phẩm, giỏ hàng, đơn hàng, thanh toán, đánh giá sản phẩm, quản lý khuyến mãi và tích hợp vận chuyển (GHN, GHTK). Cần có admin dashboard API.', 28000000.00, 45000000.00, '2026-07-01', 'DangMo', 0, false, '2026-04-19 11:00:00', '2026-04-22 10:30:00'),
	(8, 2, 2, NULL, 'API báo cáo thống kê', 'API tạo báo cáo và thống kê nghiệp vụ với các biểu đồ: doanh thu theo thời gian, top sản phẩm bán chạy, phân tích khách hàng, tỷ lệ chuyển đổi. Hỗ trợ export Excel/PDF và lọc dữ liệu linh hoạt.', 12000000.00, 22000000.00, '2026-07-05', 'DangMo', 0, false, '2026-04-19 11:10:00', '2026-04-22 10:35:00'),
	-- UI/UX (6 yêu cầu)
	(9, 1, 1, 24, 'Thiết kế landing page', 'Cần thiết kế landing page hiện đại cho chiến dịch ra mắt sản phẩm mới. Yêu cầu responsive, tối ưu conversion rate, có animation mượt mà, tích hợp form đăng ký và tương thích mọi thiết bị.', 5000000.00, 9000000.00, '2026-07-10', 'DangMo', 0, true, '2026-04-19 11:20:00', '2026-04-22 10:40:00'),
	(10, 7, 1, NULL, 'Thiết kế app mobile', 'Thiết kế giao diện app mobile iOS/Android theo chuẩn Material Design và Human Interface Guidelines. Cần có wireframe, mockup chi tiết, prototype tương tác và design system hoàn chỉnh với component library.', 8000000.00, 15000000.00, '2026-07-15', 'DangMo', 0, false, '2026-04-19 11:30:00', '2026-04-22 10:45:00'),
	(11, 8, 1, NULL, 'UI dashboard admin', 'Thiết kế giao diện quản trị hệ thống với các màn hình: dashboard tổng quan, quản lý người dùng, báo cáo thống kê, cài đặt hệ thống. Cần có dark mode, responsive và tối ưu cho nhiều loại dữ liệu.', 6000000.00, 12000000.00, '2026-07-20', 'DangMo', 0, false, '2026-04-19 11:40:00', '2026-04-22 10:50:00'),
	(12, 9, 1, 25, 'UX research và thiết kế', 'Nghiên cứu người dùng thông qua phỏng vấn, khảo sát, phân tích hành vi. Tạo user persona, user journey map, wireframe và thiết kế giao diện dựa trên insights thu thập được. Bao gồm usability testing.', 10000000.00, 18000000.00, '2026-07-25', 'DangMo', 0, true, '2026-04-19 11:50:00', '2026-04-22 10:55:00'),
	(13, 10, 1, NULL, 'Redesign website', 'Thiết kế lại toàn bộ website công ty với phong cách hiện đại, chuyên nghiệp. Bao gồm trang chủ, giới thiệu, dịch vụ, blog, liên hệ. Cần có animation, micro-interactions và tối ưu SEO.', 12000000.00, 20000000.00, '2026-08-01', 'DangMo', 0, false, '2026-04-19 12:00:00', '2026-04-22 11:00:00'),
	(14, 2, 1, NULL, 'UI kit và design system', 'Xây dựng UI kit và design system hoàn chỉnh với typography, color palette, spacing, components, icons. Tạo tài liệu hướng dẫn sử dụng và file Figma có tổ chức để team dev dễ implement.', 7000000.00, 13000000.00, '2026-08-05', 'DangMo', 0, false, '2026-04-19 12:10:00', '2026-04-22 11:05:00'),
	-- Frontend (5 yêu cầu)
	(15, 1, 6, 26, 'Giao diện frontend React', 'Phát triển giao diện hiện đại với React 18, TypeScript, TailwindCSS. Cần responsive, tối ưu performance, lazy loading, code splitting. Tích hợp API backend, xử lý state với Redux Toolkit và có unit tests.', 7000000.00, 12000000.00, '2026-08-10', 'DangMo', 0, true, '2026-04-19 12:20:00', '2026-04-22 11:10:00'),
	(16, 7, 6, NULL, 'Frontend dashboard', 'Phát triển dashboard quản trị với Vue.js 3, Composition API, Pinia. Hiển thị biểu đồ realtime (Chart.js), bảng dữ liệu phân trang, filter nâng cao, export Excel/PDF. Cần có dark mode và responsive.', 8000000.00, 14000000.00, '2026-08-15', 'DangMo', 0, false, '2026-04-19 12:30:00', '2026-04-22 11:15:00'),
	(17, 8, 6, 27, 'Landing page responsive', 'Xây dựng landing page responsive với HTML5, CSS3, JavaScript. Có animation mượt mà (GSAP), form validation, tích hợp Google Analytics, tối ưu SEO on-page và đạt 90+ điểm PageSpeed Insights.', 5000000.00, 9000000.00, '2026-08-20', 'DangMo', 0, true, '2026-04-19 12:40:00', '2026-04-22 11:20:00'),
	(18, 9, 6, NULL, 'Frontend e-commerce', 'Giao diện website bán hàng với React, Next.js. Trang chủ, danh mục sản phẩm, chi tiết sản phẩm, giỏ hàng, thanh toán, tài khoản người dùng. Tích hợp payment gateway, SEO-friendly, PWA support.', 10000000.00, 18000000.00, '2026-08-25', 'DangMo', 0, false, '2026-04-19 12:50:00', '2026-04-22 11:25:00'),
	(19, 10, 6, NULL, 'Web app Next.js', 'Phát triển web app với Next.js 14, App Router, Server Components. Có authentication, realtime updates (Socket.io), file upload, notification system. Deploy lên Vercel với CI/CD tự động.', 12000000.00, 20000000.00, '2026-09-01', 'DangMo', 0, false, '2026-04-19 13:00:00', '2026-04-22 11:30:00'),
	-- Mobile app (4 yêu cầu)
	(20, 1, 5, 28, 'App mobile bán hàng', 'Xây dựng app bán hàng iOS/Android với React Native. Tính năng: đăng nhập, duyệt sản phẩm, giỏ hàng, thanh toán, theo dõi đơn hàng, đánh giá sản phẩm, push notification. Tích hợp Firebase và payment gateway.', 30000000.00, 45000000.00, '2026-09-05', 'DangMo', 0, true, '2026-04-19 13:10:00', '2026-04-22 11:35:00'),
	(21, 2, 5, NULL, 'App quản lý công việc', 'Ứng dụng quản lý task và project với Flutter. Tạo/chỉnh sửa task, gán người thực hiện, deadline, priority, comment, file đính kèm. Có Kanban board, Gantt chart, báo cáo tiến độ và sync realtime.', 25000000.00, 40000000.00, '2026-09-10', 'DangMo', 0, false, '2026-04-19 13:20:00', '2026-04-22 11:40:00'),
	(22, 7, 5, NULL, 'App giao hàng', 'Ứng dụng cho shipper và khách hàng với React Native. Shipper: nhận đơn, định vị GPS, cập nhật trạng thái. Khách hàng: theo dõi đơn hàng realtime, đánh giá shipper. Tích hợp Google Maps và notification.', 28000000.00, 42000000.00, '2026-09-15', 'DangMo', 0, false, '2026-04-19 13:30:00', '2026-04-22 11:45:00'),
	(23, 8, 5, NULL, 'App đặt lịch', 'Ứng dụng đặt lịch hẹn và quản lý với Flutter. Khách hàng: xem lịch trống, đặt lịch, nhận nhắc nhở. Nhân viên: quản lý lịch làm việc, xác nhận/hủy lịch. Có calendar view, push notification và payment.', 20000000.00, 35000000.00, '2026-09-20', 'DangMo', 0, false, '2026-04-19 13:40:00', '2026-04-22 11:50:00'),
	-- Digital Marketing (3 yêu cầu)
	(24, 9, 3, NULL, 'SEO tổng thể website', 'Tối ưu SEO on-page và technical SEO cho website. Bao gồm: keyword research, tối ưu meta tags, heading structure, internal linking, sitemap, robots.txt, Core Web Vitals, mobile-friendly. Báo cáo hàng tuần.', 8000000.00, 15000000.00, '2026-09-25', 'DangMo', 0, false, '2026-04-19 13:50:00', '2026-04-22 11:55:00'),
	(25, 10, 3, NULL, 'Chiến dịch Google Ads', 'Thiết lập và quản lý chiến dịch Google Ads (Search, Display, Shopping). Nghiên cứu từ khóa, viết ad copy, tối ưu landing page, A/B testing, theo dõi conversion. Ngân sách quảng cáo 20 triệu/tháng trong 3 tháng.', 10000000.00, 18000000.00, '2026-10-01', 'DangMo', 0, false, '2026-04-19 14:00:00', '2026-04-22 12:00:00'),
	(26, 1, 3, NULL, 'Social media marketing', 'Quản lý và phát triển social media (Facebook, Instagram, TikTok). Lên content plan, thiết kế post, viết caption, chạy ads, tương tác với khách hàng, phân tích insights. Đăng 5-7 bài/tuần trong 3 tháng.', 6000000.00, 12000000.00, '2026-10-05', 'DangMo', 0, false, '2026-04-19 14:10:00', '2026-04-22 12:05:00'),

	-- DevOps (2 yêu cầu)
	(27, 2, 7, NULL, 'Xây dựng CI/CD', 'Thiết lập pipeline CI/CD với GitHub Actions hoặc GitLab CI. Auto build, test, deploy lên staging/production. Tích hợp Docker, automated testing, code quality check (SonarQube), notification khi deploy thành công/thất bại.', 8000000.00, 15000000.00, '2026-10-10', 'DangMo', 0, false, '2026-04-19 14:20:00', '2026-04-22 12:10:00'),
	(28, 7, 7, NULL, 'Setup infrastructure', 'Thiết lập hạ tầng trên AWS/GCP: EC2/Compute Engine, RDS/Cloud SQL, S3/Cloud Storage, Load Balancer, Auto Scaling, CloudWatch/Monitoring. Cấu hình security groups, backup tự động và disaster recovery plan.', 12000000.00, 22000000.00, '2026-10-15', 'DangMo', 0, false, '2026-04-19 14:30:00', '2026-04-22 12:15:00'),

	-- Logo (1 yêu cầu)
	(29, 8, 4, NULL, 'Thiết kế logo', 'Thiết kế bộ nhận diện thương hiệu hoàn chỉnh: logo chính, logo phụ, color palette, typography, business card, letterhead, envelope. Giao file vector (AI, SVG) và hướng dẫn sử dụng brand guideline chi tiết.', 3000000.00, 6000000.00, '2026-10-20', 'DangMo', 0, false, '2026-04-19 14:40:00', '2026-04-22 12:20:00'),

	-- QA Testing (1 yêu cầu)
	(30, 9, 8, NULL, 'Kiểm thử hệ thống', 'Test và báo cáo lỗi toàn diện cho web app. Bao gồm: functional testing, UI/UX testing, performance testing, security testing, compatibility testing (browsers, devices). Viết test cases, báo cáo bug chi tiết với screenshots/videos.', 4000000.00, 8000000.00, '2026-10-25', 'DangMo', 0, false, '2026-04-19 14:50:00', '2026-04-22 12:25:00')
ON CONFLICT ("YeuCauID") DO NOTHING;

INSERT INTO "BaoGia"
	("BaoGiaID", "YeuCauID", "TaiKhoanID", "GiaDeXuat", "ThoiGianThucHien", "NoiDung", "TrangThai", "NgayTao", "NgayCapNhat")
VALUES
	(1, 1, 13, 7000000.00, 7, 'Đề xuất giao diện hiện đại với Figma, responsive cho mobile/tablet/desktop. Bao gồm wireframe, mockup chi tiết, prototype tương tác và design system. Giao 2 lần: wireframe sau 3 ngày, mockup hoàn chỉnh sau 7 ngày.', 'DaGui', '2026-04-20 08:00:00', '2026-04-22 10:20:00'),
	(2, 1, 3, 7600000.00, 9, 'Đề xuất kết hợp design system với component library tái sử dụng. Thiết kế theo chuẩn Material Design, có dark mode, animation mượt mà. Bao gồm file Figma, assets và tài liệu hướng dẫn cho developer.', 'DaGui', '2026-04-20 08:10:00', '2026-04-22 10:25:00'),
	(3, 2, 13, 30000000.00, 30, 'Xây dựng API RESTful với NestJS, PostgreSQL, Redis caching. Bao gồm authentication JWT, authorization RBAC, API documentation (Swagger), unit tests, integration tests, deployment script và monitoring dashboard.', 'DaGui', '2026-04-20 08:20:00', '2026-04-22 10:30:00'),
	(4, 2, 4, 32000000.00, 35, 'API hoàn chỉnh với NestJS, Prisma ORM, Redis, RabbitMQ. Thêm monitoring với Grafana, logging với ELK stack, automated backup, CI/CD pipeline và tài liệu API chi tiết. Bảo hành 3 tháng.', 'DaGui', '2026-04-20 08:25:00', '2026-04-22 10:32:00'),
	(5, 2, 14, 28000000.00, 28, 'API cơ bản với NestJS, PostgreSQL. Bao gồm CRUD operations, authentication, validation, error handling và API docs. Giao source code, database schema và hướng dẫn deployment.', 'DaGui', '2026-04-20 08:27:00', '2026-04-22 10:33:00'),
	(6, 3, 13, 10000000.00, 21, 'SEO audit toàn diện và roadmap 3 tháng. Phân tích từ khóa, đối thủ, technical SEO, on-page SEO. Tối ưu meta tags, heading, internal linking, sitemap. Báo cáo hàng tuần với Google Analytics và Search Console.', 'DaGui', '2026-04-20 08:30:00', '2026-04-22 10:35:00'),
	(7, 3, 18, 9500000.00, 20, 'SEO audit và tối ưu technical SEO: Core Web Vitals, mobile-friendly, structured data, robots.txt, sitemap XML. Keyword research và tối ưu 20 trang quan trọng. Báo cáo chi tiết sau mỗi sprint.', 'DaGui', '2026-04-20 08:32:00', '2026-04-22 10:36:00'),
	(8, 4, 13, 4500000.00, 10, 'Thiết kế logo và nhận diện thương hiệu: 3 concept ban đầu, chỉnh sửa không giới hạn, giao file vector (AI, SVG, PDF), PNG với nhiều kích thước. Bao gồm color palette và typography guideline.', 'DaGui', '2026-04-20 08:40:00', '2026-04-22 10:40:00'),
	(9, 4, 3, 5000000.00, 12, 'Logo và brand identity hoàn chỉnh: logo chính, logo phụ, business card, letterhead, envelope, social media templates. Giao file nguồn và brand guideline 20+ trang với hướng dẫn sử dụng chi tiết.', 'DaGui', '2026-04-20 08:42:00', '2026-04-22 10:41:00'),
	(10, 4, 19, 4800000.00, 11, 'Logo design với 5 concept khác nhau, chỉnh sửa 3 lần, giao file AI, SVG, PNG. Bao gồm mockup trên business card, website, social media. Thời gian: concept 5 ngày, hoàn thiện 6 ngày.', 'DaGui', '2026-04-20 08:43:00', '2026-04-22 10:42:00'),
	(11, 5, 13, 32000000.00, 28, 'App mobile bán hàng với React Native, TypeScript. Tính năng: đăng nhập, danh mục sản phẩm, giỏ hàng, thanh toán, theo dõi đơn hàng, push notification. Tích hợp Firebase, payment gateway. Giao source code, APK/IPA và tài liệu.', 'DaGui', '2026-04-20 08:50:00', '2026-04-22 10:45:00'),
	(12, 5, 11, 35000000.00, 30, 'App mobile với AI recommendation engine, chatbot hỗ trợ khách hàng, AR preview sản phẩm. Sử dụng React Native, TensorFlow Lite, ARKit/ARCore. Bao gồm admin panel web và analytics dashboard.', 'DaGui', '2026-04-20 08:52:00', '2026-04-22 10:46:00'),
	(13, 6, 13, 9000000.00, 14, 'UI frontend hiện đại với React 18, TypeScript, TailwindCSS. Responsive, lazy loading, code splitting, SEO-friendly. Tích hợp API backend, state management với Redux Toolkit. Giao source code và deployment guide.', 'DaGui', '2026-04-20 09:00:00', '2026-04-22 10:50:00'),
	(14, 6, 3, 10000000.00, 15, 'UI frontend React với Next.js 14, Server Components, App Router. Tối ưu performance, SEO, accessibility. Có unit tests, E2E tests với Playwright. Deploy lên Vercel với CI/CD tự động.', 'DaGui', '2026-04-20 09:02:00', '2026-04-22 10:51:00'),
	(15, 7, 13, 12000000.00, 12, 'CI/CD pipeline với GitHub Actions: auto build, test, deploy. Tích hợp Docker, automated testing, code quality check (SonarQube), Slack notification. Setup staging và production environments với rollback tự động.', 'DaGui', '2026-04-20 09:10:00', '2026-04-22 10:55:00'),
	(16, 7, 4, 13000000.00, 14, 'CI/CD pipeline hoàn chỉnh với GitLab CI, Docker, Kubernetes. Thêm monitoring với Prometheus/Grafana, logging với ELK stack, security scanning, performance testing. Tài liệu vận hành chi tiết.', 'DaGui', '2026-04-20 09:12:00', '2026-04-22 10:56:00'),
	(17, 9, 13, 8000000.00, 12, 'Dashboard KPI với biểu đồ realtime (Chart.js), bảng dữ liệu phân trang, filter nâng cao, export Excel/PDF. Sử dụng React, TypeScript, Material-UI. Responsive và có dark mode. Tích hợp WebSocket cho realtime updates.', 'DaGui', '2026-04-20 09:30:00', '2026-04-22 11:05:00'),
	(18, 9, 11, 8500000.00, 13, 'Dashboard AI-powered với predictive analytics, anomaly detection, automated insights. Sử dụng React, D3.js, TensorFlow.js. Có voice commands, natural language queries và mobile app companion.', 'DaGui', '2026-04-20 09:32:00', '2026-04-22 11:06:00'),
	(19, 12, 13, 14000000.00, 15, 'Bảo mật toàn diện: penetration testing, vulnerability assessment, security audit. Kiểm tra OWASP Top 10, SQL injection, XSS, CSRF. Báo cáo chi tiết với severity levels, proof of concept và remediation recommendations.', 'DaGui', '2026-04-20 10:00:00', '2026-04-22 11:20:00'),
	(20, 12, 16, 15000000.00, 16, 'Pentest chuyên sâu với automated tools (Burp Suite, OWASP ZAP) và manual testing. Bao gồm network security, application security, API security. Giao báo cáo executive summary và technical report chi tiết.', 'DaGui', '2026-04-20 10:02:00', '2026-04-22 11:21:00'),
	(21, 13, 18, 6500000.00, 9, 'SEO technical: tối ưu Core Web Vitals, mobile-friendly, structured data, sitemap XML, robots.txt. Fix broken links, duplicate content, crawl errors. Báo cáo với Google Search Console và PageSpeed Insights.', 'DaGui', '2026-04-20 10:10:00', '2026-04-22 11:25:00'),
	(22, 13, 13, 6000000.00, 8, 'SEO technical tối ưu: page speed optimization, image compression, lazy loading, CDN setup, HTTPS migration. Tối ưu 15 trang quan trọng. Báo cáo trước/sau với metrics cụ thể.', 'DaGui', '2026-04-20 10:12:00', '2026-04-22 11:26:00'),
	(23, 13, 14, 7000000.00, 10, 'SEO + content marketing: keyword research, content plan 3 tháng, viết 12 bài blog SEO-friendly, tối ưu on-page SEO, internal linking strategy. Báo cáo traffic và ranking hàng tuần.', 'DaGui', '2026-04-20 10:13:00', '2026-04-22 11:27:00'),
	(24, 15, 13, 7000000.00, 10, 'Video marketing: kịch bản, quay phim, dựng video 30-60s cho social media. Bao gồm motion graphics, subtitles, background music. Giao 3 versions (Facebook, Instagram, TikTok) với aspect ratios khác nhau.', 'DaGui', '2026-04-20 10:30:00', '2026-04-22 11:35:00'),
	(25, 17, 13, 15000000.00, 20, 'Sàn thương mại điện tử với NestJS backend, React frontend. Tính năng: quản lý sản phẩm, đơn hàng, khách hàng, báo cáo doanh thu, tích hợp payment và shipping. Responsive, SEO-friendly, có admin panel.', 'DaGui', '2026-04-20 10:50:00', '2026-04-22 11:45:00'),
	(26, 17, 4, 16000000.00, 22, 'E-commerce fullstack với microservices: User service, Product service, Order service, Payment service. Sử dụng Docker, Kubernetes, RabbitMQ, Redis. Có monitoring, logging và automated backup.', 'DaGui', '2026-04-20 10:52:00', '2026-04-22 11:46:00'),
	(27, 19, 13, 9000000.00, 12, 'Branding hoàn chỉnh: logo, color palette, typography, brand voice, visual identity. Thiết kế business card, letterhead, presentation template, social media templates. Giao brand guideline 30+ trang.', 'DaGui', '2026-04-20 11:10:00', '2026-04-22 11:55:00'),
	(28, 19, 20, 9500000.00, 13, 'Branding + identity system: logo suite, brand patterns, iconography, photography style, illustration style. Thiết kế marketing materials, packaging mockups. Bao gồm brand strategy document.', 'DaGui', '2026-04-20 11:12:00', '2026-04-22 11:56:00'),
	(29, 23, 12, 9000000.00, 16, 'RPA automation với UiPath/Automation Anywhere: phân tích quy trình, thiết kế workflow, develop bots, testing, deployment. Tự động hóa 3-5 quy trình lặp đi lặp lại. Giao tài liệu và training cho team.', 'DaGui', '2026-04-20 11:50:00', '2026-04-22 12:15:00'),
	(30, 27, 20, 18000000.00, 25, 'Game design document hoàn chỉnh: concept, mechanics, level design, art direction, sound design. Prototype với Unity, playtest report. Giao GDD 50+ trang và prototype build.', 'DaGui', '2026-04-20 12:00:00', '2026-04-22 12:20:00')
ON CONFLICT ("BaoGiaID") DO NOTHING;

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
	(30, 31), (30, 33)
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

INSERT INTO "KhuyenMai"
	("KhuyenMaiID", "MaCode", "LoaiGiam", "GiaTriGiam", "GiaTriToiDa", "SoLuotDung", "GioiHanLuot", "TrangThai", "NgayBatDau", "NgayKetThuc")
VALUES
	(1, 'NEWUSER10', 'PhanTram', 10.00, 500000.00, 0, 100, 'HoatDong', '2026-04-01 00:00:00', '2026-12-31 23:59:59'),
	(2, 'SUMMER2026', 'PhanTram', 15.00, 1000000.00, 5, 200, 'HoatDong', '2026-06-01 00:00:00', '2026-08-31 23:59:59'),
	(3, 'FLASH50K', 'SoTienCo', 50000.00, 50000.00, 12, 50, 'HoatDong', '2026-04-15 00:00:00', '2026-05-15 23:59:59'),
	(4, 'VIP20', 'PhanTram', 20.00, 2000000.00, 3, 30, 'HoatDong', '2026-04-01 00:00:00', '2026-12-31 23:59:59'),
	(5, 'WEEKEND', 'PhanTram', 12.00, 800000.00, 8, 150, 'HoatDong', '2026-04-01 00:00:00', '2026-12-31 23:59:59'),
	(6, 'FIRST100K', 'SoTienCo', 100000.00, 100000.00, 25, 100, 'HoatDong', '2026-04-01 00:00:00', '2026-06-30 23:59:59'),
	(7, 'MEGA25', 'PhanTram', 25.00, 3000000.00, 2, 20, 'HoatDong', '2026-05-01 00:00:00', '2026-05-31 23:59:59'),
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
SELECT setval(pg_get_serial_sequence('"KhuyenMai"', 'KhuyenMaiID'), COALESCE(MAX("KhuyenMaiID"), 1), true) FROM "KhuyenMai";

COMMIT;
