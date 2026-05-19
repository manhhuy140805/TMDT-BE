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
	-- Liên kết 1-1 với TaiKhoan có VaiTro = 'NguoiThue' (TaiKhoanID: 1,2,7,8,9,10)
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
	-- Lien ket 1-1 voi TaiKhoan co VaiTro = 'Freelancer' (TaiKhoanID: 3,4,11,12,13,14,15,16,17,18,19,20)
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
	-- Lien ket 1-1 voi TaiKhoan co VaiTro = 'DonViGiamSat' (TaiKhoanID: 5,21,22,23,24,25,26,27,28)
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
	("YeuCauID", "NguoiThueID", "LoaiDichVuID", "TieuDe", "MoTa", "NganSachMin", "NganSachMax", "ThoiHan", "TrangThai", "SoLuongBaoGia", "YeuCauGiamSat", "NgayTao", "NgayCapNhat")
VALUES
	-- Phân bố không đều: Backend (8), UI/UX (6), Frontend (5), Mobile (4), Marketing (3), DevOps (2), Logo (1), QA (1), Data (0), AI (0)
	-- Backend (8 yêu cầu - nhiều nhất)
	(1, 1, 2, 'Xây dựng API NestJS', 'Cần xây dựng hệ thống API RESTful quản lý đơn hàng và thanh toán. Yêu cầu tích hợp cổng thanh toán VNPay, Momo, xử lý đơn hàng realtime, quản lý trạng thái đơn hàng và gửi thông báo tự động cho khách hàng.', 25000000.00, 40000000.00, '2026-06-01', 'DangMo', 3, true, '2026-04-19 10:00:00', '2026-04-22 10:00:00'),
	(2, 2, 2, 'API quản lý kho', 'Xây dựng API quản lý kho hàng và tồn kho với các tính năng: nhập/xuất kho, kiểm kê tự động, cảnh báo hàng sắp hết, báo cáo tồn kho theo thời gian thực. Cần tích hợp với hệ thống bán hàng hiện tại.', 20000000.00, 35000000.00, '2026-06-05', 'MoDau', 2, true, '2026-04-19 10:10:00', '2026-04-22 10:05:00'),
	(3, 3, 2, 'Backend hệ thống CRM', 'Phát triển backend cho hệ thống CRM quản lý khách hàng, lịch sử tương tác, phân loại khách hàng, tự động hóa email marketing và báo cáo phân tích hành vi khách hàng. Yêu cầu có API cho mobile app.', 30000000.00, 50000000.00, '2026-06-10', 'DangMo', 3, true, '2026-04-19 10:20:00', '2026-04-22 10:10:00'),
	(4, 4, 2, 'API thanh toán', 'Tích hợp cổng thanh toán quốc tế (Stripe, PayPal) và nội địa (VNPay, ZaloPay). Xử lý giao dịch an toàn, hoàn tiền tự động, lưu lịch sử giao dịch và tạo báo cáo doanh thu theo ngày/tháng.', 18000000.00, 30000000.00, '2026-06-15', 'MoDau', 2, false, '2026-04-19 10:30:00', '2026-04-22 10:15:00'),
	(5, 5, 2, 'Microservices architecture', 'Xây dựng kiến trúc microservices cho hệ thống lớn với các service: User, Product, Order, Payment, Notification. Sử dụng RabbitMQ/Kafka cho message queue, Redis cho caching, và Docker/Kubernetes cho deployment.', 35000000.00, 60000000.00, '2026-06-20', 'DangMo', 2, true, '2026-04-19 10:40:00', '2026-04-22 10:20:00'),
	(6, 6, 2, 'API quản lý người dùng', 'Backend quản lý người dùng với authentication JWT, phân quyền RBAC chi tiết, quản lý profile, đổi mật khẩu, xác thực 2FA, và tích hợp đăng nhập qua Google/Facebook. Cần có audit log đầy đủ.', 15000000.00, 28000000.00, '2026-06-25', 'MoDau', 3, true, '2026-04-19 10:50:00', '2026-04-22 10:25:00'),
	(7, 1, 2, 'Backend e-commerce', 'Hệ thống backend hoàn chỉnh cho sàn thương mại điện tử: quản lý sản phẩm, giỏ hàng, đơn hàng, thanh toán, đánh giá sản phẩm, quản lý khuyến mãi và tích hợp vận chuyển (GHN, GHTK). Cần có admin dashboard API.', 28000000.00, 45000000.00, '2026-07-01', 'DangMo', 2, true, '2026-04-19 11:00:00', '2026-04-22 10:30:00'),
	(8, 2, 2, 'API báo cáo thống kê', 'API tạo báo cáo và thống kê nghiệp vụ với các biểu đồ: doanh thu theo thời gian, top sản phẩm bán chạy, phân tích khách hàng, tỷ lệ chuyển đổi. Hỗ trợ export Excel/PDF và lọc dữ liệu linh hoạt.', 12000000.00, 22000000.00, '2026-07-05', 'MoDau', 1, false, '2026-04-19 11:10:00', '2026-04-22 10:35:00'),
	
	-- UI/UX (6 yêu cầu)
	(9, 1, 1, 'Thiết kế landing page', 'Cần thiết kế landing page hiện đại cho chiến dịch ra mắt sản phẩm mới. Yêu cầu responsive, tối ưu conversion rate, có animation mượt mà, tích hợp form đăng ký và tương thích mọi thiết bị.', 5000000.00, 9000000.00, '2026-07-10', 'DangMo', 2, true, '2026-04-19 11:20:00', '2026-04-22 10:40:00'),
	(10, 3, 1, 'Thiết kế app mobile', 'Thiết kế giao diện app mobile iOS/Android theo chuẩn Material Design và Human Interface Guidelines. Cần có wireframe, mockup chi tiết, prototype tương tác và design system hoàn chỉnh với component library.', 8000000.00, 15000000.00, '2026-07-15', 'MoDau', 3, true, '2026-04-19 11:30:00', '2026-04-22 10:45:00'),
	(11, 4, 1, 'UI dashboard admin', 'Thiết kế giao diện quản trị hệ thống với các màn hình: dashboard tổng quan, quản lý người dùng, báo cáo thống kê, cài đặt hệ thống. Cần có dark mode, responsive và tối ưu cho nhiều loại dữ liệu.', 6000000.00, 12000000.00, '2026-07-20', 'DangMo', 2, false, '2026-04-19 11:40:00', '2026-04-22 10:50:00'),
	(12, 5, 1, 'UX research và thiết kế', 'Nghiên cứu người dùng thông qua phỏng vấn, khảo sát, phân tích hành vi. Tạo user persona, user journey map, wireframe và thiết kế giao diện dựa trên insights thu thập được. Bao gồm usability testing.', 10000000.00, 18000000.00, '2026-07-25', 'MoDau', 2, true, '2026-04-19 11:50:00', '2026-04-22 10:55:00'),
	(13, 6, 1, 'Redesign website', 'Thiết kế lại toàn bộ website công ty với phong cách hiện đại, chuyên nghiệp. Bao gồm trang chủ, giới thiệu, dịch vụ, blog, liên hệ. Cần có animation, micro-interactions và tối ưu SEO.', 12000000.00, 20000000.00, '2026-08-01', 'DangMo', 3, true, '2026-04-19 12:00:00', '2026-04-22 11:00:00'),
	(14, 2, 1, 'UI kit và design system', 'Xây dựng UI kit và design system hoàn chỉnh với typography, color palette, spacing, components, icons. Tạo tài liệu hướng dẫn sử dụng và file Figma có tổ chức để team dev dễ implement.', 7000000.00, 13000000.00, '2026-08-05', 'MoDau', 2, false, '2026-04-19 12:10:00', '2026-04-22 11:05:00'),
	
	-- Frontend (5 yêu cầu)
	(15, 1, 6, 'Giao diện frontend React', 'Phát triển giao diện hiện đại với React 18, TypeScript, TailwindCSS. Cần responsive, tối ưu performance, lazy loading, code splitting. Tích hợp API backend, xử lý state với Redux Toolkit và có unit tests.', 7000000.00, 12000000.00, '2026-08-10', 'DangMo', 2, true, '2026-04-19 12:20:00', '2026-04-22 11:10:00'),
	(16, 3, 6, 'Frontend dashboard', 'Phát triển dashboard quản trị với Vue.js 3, Composition API, Pinia. Hiển thị biểu đồ realtime (Chart.js), bảng dữ liệu phân trang, filter nâng cao, export Excel/PDF. Cần có dark mode và responsive.', 8000000.00, 14000000.00, '2026-08-15', 'MoDau', 2, false, '2026-04-19 12:30:00', '2026-04-22 11:15:00'),
	(17, 4, 6, 'Landing page responsive', 'Xây dựng landing page responsive với HTML5, CSS3, JavaScript. Có animation mượt mà (GSAP), form validation, tích hợp Google Analytics, tối ưu SEO on-page và đạt 90+ điểm PageSpeed Insights.', 5000000.00, 9000000.00, '2026-08-20', 'DangMo', 3, true, '2026-04-19 12:40:00', '2026-04-22 11:20:00'),
	(18, 5, 6, 'Frontend e-commerce', 'Giao diện website bán hàng với React, Next.js. Trang chủ, danh mục sản phẩm, chi tiết sản phẩm, giỏ hàng, thanh toán, tài khoản người dùng. Tích hợp payment gateway, SEO-friendly, PWA support.', 10000000.00, 18000000.00, '2026-08-25', 'MoDau', 2, true, '2026-04-19 12:50:00', '2026-04-22 11:25:00'),
	(19, 6, 6, 'Web app Next.js', 'Phát triển web app với Next.js 14, App Router, Server Components. Có authentication, realtime updates (Socket.io), file upload, notification system. Deploy lên Vercel với CI/CD tự động.', 12000000.00, 20000000.00, '2026-09-01', 'DangMo', 2, false, '2026-04-19 13:00:00', '2026-04-22 11:30:00'),
	
	-- Mobile app (4 yêu cầu)
	(20, 1, 5, 'App mobile bán hàng', 'Xây dựng app bán hàng iOS/Android với React Native. Tính năng: đăng nhập, duyệt sản phẩm, giỏ hàng, thanh toán, theo dõi đơn hàng, đánh giá sản phẩm, push notification. Tích hợp Firebase và payment gateway.', 30000000.00, 45000000.00, '2026-09-05', 'DangMo', 2, true, '2026-04-19 13:10:00', '2026-04-22 11:35:00'),
	(21, 2, 5, 'App quản lý công việc', 'Ứng dụng quản lý task và project với Flutter. Tạo/chỉnh sửa task, gán người thực hiện, deadline, priority, comment, file đính kèm. Có Kanban board, Gantt chart, báo cáo tiến độ và sync realtime.', 25000000.00, 40000000.00, '2026-09-10', 'MoDau', 3, true, '2026-04-19 13:20:00', '2026-04-22 11:40:00'),
	(22, 3, 5, 'App giao hàng', 'Ứng dụng cho shipper và khách hàng với React Native. Shipper: nhận đơn, định vị GPS, cập nhật trạng thái. Khách hàng: theo dõi đơn hàng realtime, đánh giá shipper. Tích hợp Google Maps và notification.', 28000000.00, 42000000.00, '2026-09-15', 'DangMo', 2, true, '2026-04-19 13:30:00', '2026-04-22 11:45:00'),
	(23, 4, 5, 'App đặt lịch', 'Ứng dụng đặt lịch hẹn và quản lý với Flutter. Khách hàng: xem lịch trống, đặt lịch, nhận nhắc nhở. Nhân viên: quản lý lịch làm việc, xác nhận/hủy lịch. Có calendar view, push notification và payment.', 20000000.00, 35000000.00, '2026-09-20', 'MoDau', 2, false, '2026-04-19 13:40:00', '2026-04-22 11:50:00'),
	
	-- Digital Marketing (3 yêu cầu)
	(24, 5, 3, 'SEO tổng thể website', 'Tối ưu SEO on-page và technical SEO cho website. Bao gồm: keyword research, tối ưu meta tags, heading structure, internal linking, sitemap, robots.txt, Core Web Vitals, mobile-friendly. Báo cáo hàng tuần.', 8000000.00, 15000000.00, '2026-09-25', 'DangMo', 2, true, '2026-04-19 13:50:00', '2026-04-22 11:55:00'),
	(25, 6, 3, 'Chiến dịch Google Ads', 'Thiết lập và quản lý chiến dịch Google Ads (Search, Display, Shopping). Nghiên cứu từ khóa, viết ad copy, tối ưu landing page, A/B testing, theo dõi conversion. Ngân sách quảng cáo 20 triệu/tháng trong 3 tháng.', 10000000.00, 18000000.00, '2026-10-01', 'MoDau', 2, false, '2026-04-19 14:00:00', '2026-04-22 12:00:00'),
	(26, 1, 3, 'Social media marketing', 'Quản lý và phát triển social media (Facebook, Instagram, TikTok). Lên content plan, thiết kế post, viết caption, chạy ads, tương tác với khách hàng, phân tích insights. Đăng 5-7 bài/tuần trong 3 tháng.', 6000000.00, 12000000.00, '2026-10-05', 'DangMo', 3, true, '2026-04-19 14:10:00', '2026-04-22 12:05:00'),
	
	-- DevOps (2 yêu cầu)
	(27, 2, 7, 'Xây dựng CI/CD', 'Thiết lập pipeline CI/CD với GitHub Actions hoặc GitLab CI. Auto build, test, deploy lên staging/production. Tích hợp Docker, automated testing, code quality check (SonarQube), notification khi deploy thành công/thất bại.', 8000000.00, 15000000.00, '2026-10-10', 'MoDau', 2, true, '2026-04-19 14:20:00', '2026-04-22 12:10:00'),
	(28, 3, 7, 'Setup infrastructure', 'Thiết lập hạ tầng trên AWS/GCP: EC2/Compute Engine, RDS/Cloud SQL, S3/Cloud Storage, Load Balancer, Auto Scaling, CloudWatch/Monitoring. Cấu hình security groups, backup tự động và disaster recovery plan.', 12000000.00, 22000000.00, '2026-10-15', 'DangMo', 2, true, '2026-04-19 14:30:00', '2026-04-22 12:15:00'),
	
	-- Logo (1 yêu cầu)
	(29, 4, 4, 'Thiết kế logo', 'Thiết kế bộ nhận diện thương hiệu hoàn chỉnh: logo chính, logo phụ, color palette, typography, business card, letterhead, envelope. Giao file vector (AI, SVG) và hướng dẫn sử dụng brand guideline chi tiết.', 3000000.00, 6000000.00, '2026-10-20', 'MoDau', 3, false, '2026-04-19 14:40:00', '2026-04-22 12:20:00'),
	
	-- QA Testing (1 yêu cầu)
	(30, 5, 8, 'Kiểm thử hệ thống', 'Test và báo cáo lỗi toàn diện cho web app. Bao gồm: functional testing, UI/UX testing, performance testing, security testing, compatibility testing (browsers, devices). Viết test cases, báo cáo bug chi tiết với screenshots/videos.', 4000000.00, 8000000.00, '2026-10-25', 'DangMo', 1, true, '2026-04-19 14:50:00', '2026-04-22 12:25:00')
ON CONFLICT ("YeuCauID") DO NOTHING;

INSERT INTO "BaoGia"
	("BaoGiaID", "YeuCauID", "FreelancerID", "GiaDeXuat", "ThoiGianThucHien", "NoiDung", "TrangThai", "NgayTao", "NgayCapNhat")
VALUES
	-- 20 rows từ Freelancer 5 (TaiKhoanID=13, user_13 - Freelancer chính)
	(1, 1, 5, 7000000.00, 7, 'Đề xuất giao diện hiện đại với Figma, responsive cho mobile/tablet/desktop. Bao gồm wireframe, mockup chi tiết, prototype tương tác và design system. Giao 2 lần: wireframe sau 3 ngày, mockup hoàn chỉnh sau 7 ngày.', 'DaGui', '2026-04-20 08:00:00', '2026-04-22 10:20:00'),
	(2, 1, 1, 7600000.00, 9, 'Đề xuất kết hợp design system với component library tái sử dụng. Thiết kế theo chuẩn Material Design, có dark mode, animation mượt mà. Bao gồm file Figma, assets và tài liệu hướng dẫn cho developer.', 'DaGui', '2026-04-20 08:10:00', '2026-04-22 10:25:00'),
	(3, 2, 5, 30000000.00, 30, 'Xây dựng API RESTful với NestJS, PostgreSQL, Redis caching. Bao gồm authentication JWT, authorization RBAC, API documentation (Swagger), unit tests, integration tests, deployment script và monitoring dashboard.', 'DaGui', '2026-04-20 08:20:00', '2026-04-22 10:30:00'),
	(4, 2, 2, 32000000.00, 35, 'API hoàn chỉnh với NestJS, Prisma ORM, Redis, RabbitMQ. Thêm monitoring với Grafana, logging với ELK stack, automated backup, CI/CD pipeline và tài liệu API chi tiết. Bảo hành 3 tháng.', 'DaGui', '2026-04-20 08:25:00', '2026-04-22 10:32:00'),
	(5, 2, 6, 28000000.00, 28, 'API cơ bản với NestJS, PostgreSQL. Bao gồm CRUD operations, authentication, validation, error handling và API docs. Giao source code, database schema và hướng dẫn deployment.', 'DaGui', '2026-04-20 08:27:00', '2026-04-22 10:33:00'),
	(6, 3, 5, 10000000.00, 21, 'SEO audit toàn diện và roadmap 3 tháng. Phân tích từ khóa, đối thủ, technical SEO, on-page SEO. Tối ưu meta tags, heading, internal linking, sitemap. Báo cáo hàng tuần với Google Analytics và Search Console.', 'DaGui', '2026-04-20 08:30:00', '2026-04-22 10:35:00'),
	(7, 3, 10, 9500000.00, 20, 'SEO audit và tối ưu technical SEO: Core Web Vitals, mobile-friendly, structured data, robots.txt, sitemap XML. Keyword research và tối ưu 20 trang quan trọng. Báo cáo chi tiết sau mỗi sprint.', 'DaGui', '2026-04-20 08:32:00', '2026-04-22 10:36:00'),
	(8, 4, 5, 4500000.00, 10, 'Thiết kế logo và nhận diện thương hiệu: 3 concept ban đầu, chỉnh sửa không giới hạn, giao file vector (AI, SVG, PDF), PNG với nhiều kích thước. Bao gồm color palette và typography guideline.', 'DaGui', '2026-04-20 08:40:00', '2026-04-22 10:40:00'),
	(9, 4, 1, 5000000.00, 12, 'Logo và brand identity hoàn chỉnh: logo chính, logo phụ, business card, letterhead, envelope, social media templates. Giao file nguồn và brand guideline 20+ trang với hướng dẫn sử dụng chi tiết.', 'DaGui', '2026-04-20 08:42:00', '2026-04-22 10:41:00'),
	(10, 4, 11, 4800000.00, 11, 'Logo design với 5 concept khác nhau, chỉnh sửa 3 lần, giao file AI, SVG, PNG. Bao gồm mockup trên business card, website, social media. Thời gian: concept 5 ngày, hoàn thiện 6 ngày.', 'DaGui', '2026-04-20 08:43:00', '2026-04-22 10:42:00'),
	(11, 5, 5, 32000000.00, 28, 'App mobile bán hàng với React Native, TypeScript. Tính năng: đăng nhập, danh mục sản phẩm, giỏ hàng, thanh toán, theo dõi đơn hàng, push notification. Tích hợp Firebase, payment gateway. Giao source code, APK/IPA và tài liệu.', 'DaGui', '2026-04-20 08:50:00', '2026-04-22 10:45:00'),
	(12, 5, 3, 35000000.00, 30, 'App mobile với AI recommendation engine, chatbot hỗ trợ khách hàng, AR preview sản phẩm. Sử dụng React Native, TensorFlow Lite, ARKit/ARCore. Bao gồm admin panel web và analytics dashboard.', 'DaGui', '2026-04-20 08:52:00', '2026-04-22 10:46:00'),
	(13, 6, 5, 9000000.00, 14, 'UI frontend hiện đại với React 18, TypeScript, TailwindCSS. Responsive, lazy loading, code splitting, SEO-friendly. Tích hợp API backend, state management với Redux Toolkit. Giao source code và deployment guide.', 'DaGui', '2026-04-20 09:00:00', '2026-04-22 10:50:00'),
	(14, 6, 1, 10000000.00, 15, 'UI frontend React với Next.js 14, Server Components, App Router. Tối ưu performance, SEO, accessibility. Có unit tests, E2E tests với Playwright. Deploy lên Vercel với CI/CD tự động.', 'DaGui', '2026-04-20 09:02:00', '2026-04-22 10:51:00'),
	(15, 7, 5, 12000000.00, 12, 'CI/CD pipeline với GitHub Actions: auto build, test, deploy. Tích hợp Docker, automated testing, code quality check (SonarQube), Slack notification. Setup staging và production environments với rollback tự động.', 'DaGui', '2026-04-20 09:10:00', '2026-04-22 10:55:00'),
	(16, 7, 2, 13000000.00, 14, 'CI/CD pipeline hoàn chỉnh với GitLab CI, Docker, Kubernetes. Thêm monitoring với Prometheus/Grafana, logging với ELK stack, security scanning, performance testing. Tài liệu vận hành chi tiết.', 'DaGui', '2026-04-20 09:12:00', '2026-04-22 10:56:00'),
	(17, 9, 5, 8000000.00, 12, 'Dashboard KPI với biểu đồ realtime (Chart.js), bảng dữ liệu phân trang, filter nâng cao, export Excel/PDF. Sử dụng React, TypeScript, Material-UI. Responsive và có dark mode. Tích hợp WebSocket cho realtime updates.', 'DaGui', '2026-04-20 09:30:00', '2026-04-22 11:05:00'),
	(18, 9, 3, 8500000.00, 13, 'Dashboard AI-powered với predictive analytics, anomaly detection, automated insights. Sử dụng React, D3.js, TensorFlow.js. Có voice commands, natural language queries và mobile app companion.', 'DaGui', '2026-04-20 09:32:00', '2026-04-22 11:06:00'),
	(19, 12, 5, 14000000.00, 15, 'Bảo mật toàn diện: penetration testing, vulnerability assessment, security audit. Kiểm tra OWASP Top 10, SQL injection, XSS, CSRF. Báo cáo chi tiết với severity levels, proof of concept và remediation recommendations.', 'DaGui', '2026-04-20 10:00:00', '2026-04-22 11:20:00'),
	(20, 12, 8, 15000000.00, 16, 'Pentest chuyên sâu với automated tools (Burp Suite, OWASP ZAP) và manual testing. Bao gồm network security, application security, API security. Giao báo cáo executive summary và technical report chi tiết.', 'DaGui', '2026-04-20 10:02:00', '2026-04-22 11:21:00'),
	-- 10 rows từ các freelancer khác (FreelancerID 1-12)
	(21, 13, 10, 6500000.00, 9, 'SEO technical: tối ưu Core Web Vitals, mobile-friendly, structured data, sitemap XML, robots.txt. Fix broken links, duplicate content, crawl errors. Báo cáo với Google Search Console và PageSpeed Insights.', 'DaGui', '2026-04-20 10:10:00', '2026-04-22 11:25:00'),
	(22, 13, 5, 6000000.00, 8, 'SEO technical tối ưu: page speed optimization, image compression, lazy loading, CDN setup, HTTPS migration. Tối ưu 15 trang quan trọng. Báo cáo trước/sau với metrics cụ thể.', 'DaGui', '2026-04-20 10:12:00', '2026-04-22 11:26:00'),
	(23, 13, 6, 7000000.00, 10, 'SEO + content marketing: keyword research, content plan 3 tháng, viết 12 bài blog SEO-friendly, tối ưu on-page SEO, internal linking strategy. Báo cáo traffic và ranking hàng tuần.', 'DaGui', '2026-04-20 10:13:00', '2026-04-22 11:27:00'),
	(24, 15, 5, 7000000.00, 10, 'Video marketing: kịch bản, quay phim, dựng video 30-60s cho social media. Bao gồm motion graphics, subtitles, background music. Giao 3 versions (Facebook, Instagram, TikTok) với aspect ratios khác nhau.', 'DaGui', '2026-04-20 10:30:00', '2026-04-22 11:35:00'),
	(25, 17, 5, 15000000.00, 20, 'Sàn thương mại điện tử với NestJS backend, React frontend. Tính năng: quản lý sản phẩm, đơn hàng, khách hàng, báo cáo doanh thu, tích hợp payment và shipping. Responsive, SEO-friendly, có admin panel.', 'DaGui', '2026-04-20 10:50:00', '2026-04-22 11:45:00'),
	(26, 17, 2, 16000000.00, 22, 'E-commerce fullstack với microservices: User service, Product service, Order service, Payment service. Sử dụng Docker, Kubernetes, RabbitMQ, Redis. Có monitoring, logging và automated backup.', 'DaGui', '2026-04-20 10:52:00', '2026-04-22 11:46:00'),
	(27, 19, 5, 9000000.00, 12, 'Branding hoàn chỉnh: logo, color palette, typography, brand voice, visual identity. Thiết kế business card, letterhead, presentation template, social media templates. Giao brand guideline 30+ trang.', 'DaGui', '2026-04-20 11:10:00', '2026-04-22 11:55:00'),
	(28, 19, 12, 9500000.00, 13, 'Branding + identity system: logo suite, brand patterns, iconography, photography style, illustration style. Thiết kế marketing materials, packaging mockups. Bao gồm brand strategy document.', 'DaGui', '2026-04-20 11:12:00', '2026-04-22 11:56:00'),
	(29, 23, 4, 9000000.00, 16, 'RPA automation với UiPath/Automation Anywhere: phân tích quy trình, thiết kế workflow, develop bots, testing, deployment. Tự động hóa 3-5 quy trình lặp đi lặp lại. Giao tài liệu và training cho team.', 'DaGui', '2026-04-20 11:50:00', '2026-04-22 12:15:00'),
	(30, 27, 12, 18000000.00, 25, 'Game design document hoàn chỉnh: game concept, mechanics, level design, character design, UI/UX, monetization strategy. Bao gồm prototype playable, art assets và technical specification cho developers.', 'DaGui', '2026-04-20 12:30:00', '2026-04-22 12:35:00')
ON CONFLICT ("BaoGiaID") DO NOTHING;

INSERT INTO "CongViec"
	("CongViecID", "YeuCauID", "FreelancerID", "NguoiThueID", "GiaThoa", "ThoiGianThoa", "TrangThai", "NgayBatDau", "NgayKetThuc", "GiamSatID", "TrangThaiGiamSat", "PhiGiamSat", "NgayTao")
VALUES
	(1, 1, 1, 1, 7000000.00, 7, 'DangThucHien', '2026-04-20 09:00:00', NULL, 1, 'DangGiamSat', 500000.00, '2026-04-20 09:00:00'),
	(2, 2, 2, 2, 30000000.00, 30, 'MoiTao', NULL, NULL, NULL, 'KhongCo', 0.00, '2026-04-20 09:10:00'),
	(3, 3, 3, 3, 9000000.00, 21, 'MoiTao', NULL, NULL, 2, 'ChoDuyet', 300000.00, '2026-04-20 09:20:00'),
	(4, 4, 4, 4, 4500000.00, 10, 'DangThucHien', '2026-04-21 09:00:00', NULL, 3, 'DangGiamSat', 250000.00, '2026-04-20 09:30:00'),
	(5, 5, 5, 5, 32000000.00, 28, 'MoiTao', NULL, NULL, NULL, 'KhongCo', 0.00, '2026-04-20 09:40:00'),
	(6, 6, 6, 6, 9000000.00, 14, 'DangThucHien', '2026-04-22 09:00:00', NULL, 4, 'DangGiamSat', 200000.00, '2026-04-20 09:50:00'),
	(7, 7, 7, 1, 12000000.00, 12, 'MoiTao', NULL, NULL, NULL, 'KhongCo', 0.00, '2026-04-20 10:00:00'),
	(8, 8, 8, 2, 5500000.00, 8, 'DangThucHien', '2026-04-23 09:00:00', NULL, 5, 'DangGiamSat', 180000.00, '2026-04-20 10:10:00'),
	(9, 9, 9, 3, 8000000.00, 12, 'MoiTao', NULL, NULL, NULL, 'KhongCo', 0.00, '2026-04-20 10:20:00'),
	(10, 10, 10, 4, 18000000.00, 20, 'DangThucHien', '2026-04-24 09:00:00', NULL, 6, 'DangGiamSat', 350000.00, '2026-04-20 10:30:00'),
	(11, 11, 11, 5, 5000000.00, 6, 'MoiTao', NULL, NULL, NULL, 'KhongCo', 0.00, '2026-04-20 10:40:00'),
	(12, 12, 12, 6, 14000000.00, 15, 'DangThucHien', '2026-04-25 09:00:00', NULL, 7, 'DangGiamSat', 320000.00, '2026-04-20 10:50:00'),
	(13, 13, 1, 1, 6500000.00, 9, 'MoiTao', NULL, NULL, NULL, 'KhongCo', 0.00, '2026-04-20 11:00:00'),
	(14, 14, 2, 2, 3500000.00, 7, 'DangThucHien', '2026-04-26 09:00:00', NULL, 8, 'DangGiamSat', 150000.00, '2026-04-20 11:10:00'),
	(15, 15, 3, 3, 7000000.00, 10, 'MoiTao', NULL, NULL, NULL, 'KhongCo', 0.00, '2026-04-20 11:20:00'),
	(16, 16, 4, 4, 4200000.00, 8, 'DangThucHien', '2026-04-27 09:00:00', NULL, 9, 'DangGiamSat', 200000.00, '2026-04-20 11:30:00'),
	(17, 17, 5, 5, 15000000.00, 20, 'MoiTao', NULL, NULL, NULL, 'KhongCo', 0.00, '2026-04-20 11:40:00'),
	(18, 18, 6, 6, 4500000.00, 7, 'DangThucHien', '2026-04-28 09:00:00', NULL, 1, 'DangGiamSat', 180000.00, '2026-04-20 11:50:00'),
	(19, 19, 7, 1, 9000000.00, 12, 'MoiTao', NULL, NULL, NULL, 'KhongCo', 0.00, '2026-04-20 12:00:00'),
	(20, 20, 8, 2, 3200000.00, 6, 'DangThucHien', '2026-04-29 09:00:00', NULL, 2, 'DangGiamSat', 120000.00, '2026-04-20 12:10:00'),
	(21, 21, 9, 3, 2500000.00, 5, 'MoiTao', NULL, NULL, NULL, 'KhongCo', 0.00, '2026-04-20 12:20:00'),
	(22, 22, 10, 4, 8000000.00, 14, 'DangThucHien', '2026-04-30 09:00:00', NULL, 3, 'DangGiamSat', 260000.00, '2026-04-20 12:30:00'),
	(23, 23, 11, 5, 9000000.00, 16, 'MoiTao', NULL, NULL, NULL, 'KhongCo', 0.00, '2026-04-20 12:40:00'),
	(24, 24, 12, 6, 11000000.00, 18, 'DangThucHien', '2026-05-01 09:00:00', NULL, 4, 'DangGiamSat', 300000.00, '2026-04-20 12:50:00'),
	(25, 25, 1, 1, 12000000.00, 20, 'MoiTao', NULL, NULL, NULL, 'KhongCo', 0.00, '2026-04-20 13:00:00'),
	(26, 26, 2, 2, 14000000.00, 22, 'DangThucHien', '2026-05-02 09:00:00', NULL, 5, 'DangGiamSat', 320000.00, '2026-04-20 13:10:00'),
	(27, 27, 3, 3, 18000000.00, 25, 'MoiTao', NULL, NULL, NULL, 'KhongCo', 0.00, '2026-04-20 13:20:00'),
	(28, 28, 4, 4, 10000000.00, 15, 'DangThucHien', '2026-05-03 09:00:00', NULL, 6, 'DangGiamSat', 240000.00, '2026-04-20 13:30:00'),
	(29, 29, 5, 5, 9000000.00, 12, 'MoiTao', NULL, NULL, NULL, 'KhongCo', 0.00, '2026-04-20 13:40:00'),
	(30, 30, 6, 6, 7000000.00, 10, 'DangThucHien', '2026-05-04 09:00:00', NULL, 7, 'DangGiamSat', 200000.00, '2026-04-20 13:50:00')
ON CONFLICT ("CongViecID") DO NOTHING;

INSERT INTO "YeuCauGiamSat"
	("YCGiamSatID", "CongViecID", "NguoiThueID", "GiamSatID", "FreelancerID", "TrangThai", "LyDoTuChoi", "PhiGiamSatThoa", "NgayYeuCau", "NgayChapNhan", "NgayHoanThanh")
VALUES
	(1, 1, 1, 1, 1, 'DaChapNhan', NULL, 500000.00, '2026-04-20 09:05:00', '2026-04-20 10:00:00', NULL),
	(2, 2, 2, 2, 2, 'ChoDuyet', NULL, 300000.00, '2026-04-20 09:15:00', NULL, NULL),
	(3, 3, 3, 3, 3, 'DaChapNhan', NULL, 250000.00, '2026-04-20 09:25:00', '2026-04-20 10:10:00', NULL),
	(4, 4, 4, 4, 4, 'TuChoi', 'Khong phu hop', 200000.00, '2026-04-20 09:35:00', NULL, NULL),
	(5, 5, 5, 5, 5, 'DaChapNhan', NULL, 280000.00, '2026-04-20 09:45:00', '2026-04-20 10:20:00', NULL),
	(6, 6, 6, 6, 6, 'ChoDuyet', NULL, 260000.00, '2026-04-20 09:55:00', NULL, NULL),
	(7, 7, 1, 1, 7, 'DaChapNhan', NULL, 240000.00, '2026-04-20 10:05:00', '2026-04-20 10:30:00', NULL),
	(8, 8, 2, 2, 8, 'DaChapNhan', NULL, 220000.00, '2026-04-20 10:15:00', '2026-04-20 10:40:00', NULL),
	(9, 9, 3, 3, 9, 'ChoDuyet', NULL, 210000.00, '2026-04-20 10:25:00', NULL, NULL),
	(10, 10, 4, 4, 10, 'DaChapNhan', NULL, 230000.00, '2026-04-20 10:35:00', '2026-04-20 10:50:00', NULL),
	(11, 11, 5, 5, 11, 'DaChapNhan', NULL, 250000.00, '2026-04-20 10:45:00', '2026-04-20 11:00:00', NULL),
	(12, 12, 6, 6, 12, 'ChoDuyet', NULL, 260000.00, '2026-04-20 10:55:00', NULL, NULL),
	(13, 13, 1, 7, 1, 'DaChapNhan', NULL, 240000.00, '2026-04-20 11:05:00', '2026-04-20 11:10:00', NULL),
	(14, 14, 2, 8, 2, 'DaChapNhan', NULL, 220000.00, '2026-04-20 11:15:00', '2026-04-20 11:20:00', NULL),
	(15, 15, 3, 9, 3, 'TuChoi', 'Khong phu hop', 200000.00, '2026-04-20 11:25:00', NULL, NULL),
	(16, 16, 4, 1, 4, 'DaChapNhan', NULL, 230000.00, '2026-04-20 11:35:00', '2026-04-20 11:40:00', NULL),
	(17, 17, 5, 2, 5, 'ChoDuyet', NULL, 250000.00, '2026-04-20 11:45:00', NULL, NULL),
	(18, 18, 6, 3, 6, 'DaChapNhan', NULL, 240000.00, '2026-04-20 11:55:00', '2026-04-20 12:00:00', NULL),
	(19, 19, 1, 4, 7, 'DaChapNhan', NULL, 220000.00, '2026-04-20 12:05:00', '2026-04-20 12:10:00', NULL),
	(20, 20, 2, 5, 8, 'ChoDuyet', NULL, 210000.00, '2026-04-20 12:15:00', NULL, NULL),
	(21, 21, 3, 6, 9, 'DaChapNhan', NULL, 230000.00, '2026-04-20 12:25:00', '2026-04-20 12:30:00', NULL),
	(22, 22, 4, 7, 10, 'DaChapNhan', NULL, 240000.00, '2026-04-20 12:35:00', '2026-04-20 12:40:00', NULL),
	(23, 23, 5, 8, 11, 'ChoDuyet', NULL, 250000.00, '2026-04-20 12:45:00', NULL, NULL),
	(24, 24, 6, 9, 12, 'DaChapNhan', NULL, 260000.00, '2026-04-20 12:55:00', '2026-04-20 13:00:00', NULL),
	(25, 25, 1, 1, 1, 'DaChapNhan', NULL, 240000.00, '2026-04-20 13:05:00', '2026-04-20 13:10:00', NULL),
	(26, 26, 2, 2, 2, 'ChoDuyet', NULL, 230000.00, '2026-04-20 13:15:00', NULL, NULL),
	(27, 27, 3, 3, 3, 'DaChapNhan', NULL, 250000.00, '2026-04-20 13:25:00', '2026-04-20 13:30:00', NULL),
	(28, 28, 4, 4, 4, 'DaChapNhan', NULL, 220000.00, '2026-04-20 13:35:00', '2026-04-20 13:40:00', NULL),
	(29, 29, 5, 5, 5, 'ChoDuyet', NULL, 210000.00, '2026-04-20 13:45:00', NULL, NULL),
	(30, 30, 6, 6, 6, 'DaChapNhan', NULL, 230000.00, '2026-04-20 13:55:00', '2026-04-20 14:00:00', NULL)
ON CONFLICT ("YCGiamSatID") DO NOTHING;

INSERT INTO "TienDo"
	("TienDoID", "CongViecID", "FreelancerID", "TieuDe", "MoTa", "PhanTram", "TepDinhKem", "XacNhanBoi", "TrangThaiXacNhan", "NgayTao")
VALUES
	(1, 1, 1, 'Hoàn thành wireframe', 'Đã gửi wireframe cho trang chủ, trang sản phẩm và trang giỏ hàng. Bao gồm user flow và sitemap. File PDF 15 trang với annotations chi tiết về chức năng từng màn hình.', 30, 'wireframe-v1.pdf', 1, 'DaXacNhan', '2026-04-21 09:00:00'),
	(2, 1, 1, 'Hoàn thành UI mockup', 'Đã gửi mockup desktop và mobile với đầy đủ màn hình. Sử dụng color palette đã thống nhất, typography Roboto. File Figma có components và auto-layout để dễ chỉnh sửa.', 60, 'mockup-v1.fig', NULL, 'ChuaXacNhan', '2026-04-22 09:30:00'),
	(3, 2, 2, 'Cập nhật API', 'Đã hoàn thành 20% API: authentication endpoints (login, register, refresh token), user profile CRUD. Có unit tests coverage 85%. Swagger docs đã cập nhật.', 20, 'api-v1.pdf', 2, 'DaXacNhan', '2026-04-22 10:00:00'),
	(4, 3, 3, 'Thiết kế logo', 'Đã gửi 2 phương án logo với concept khác nhau: phương án A hiện đại minimalist, phương án B truyền thống elegant. Mỗi phương án có 3 variations về màu sắc.', 40, 'logo-v1.png', NULL, 'ChuaXacNhan', '2026-04-22 10:30:00'),
	(5, 4, 4, 'Sprint 1', 'Hoàn thành giao diện 5 màn hình chính: Home, Product List, Product Detail, Cart, Checkout. Đã implement responsive cho mobile và tablet. Code đã push lên Git branch feature/ui-sprint1.', 50, 'ui-sprint1.fig', 4, 'DaXacNhan', '2026-04-22 11:00:00'),
	(6, 5, 5, 'Khởi động dự án', 'Lập kế hoạch chi tiết: phân tích requirements, chia tasks, estimate effort. Tạo project roadmap 8 tuần với 4 milestones. Setup Git repository, CI/CD pipeline và project management tool.', 10, 'plan.docx', NULL, 'ChuaXacNhan', '2026-04-22 11:30:00'),
	(7, 6, 6, 'CI/CD', 'Pipeline cơ bản đã hoạt động: auto build khi push code, run tests, deploy lên staging. Sử dụng GitHub Actions với Docker. Build time trung bình 5 phút. Cần optimize thêm caching.', 30, 'cicd.yml', 6, 'DaXacNhan', '2026-04-22 12:00:00'),
	(8, 7, 7, 'Test case', 'Viết test case cho 3 modules chính: Authentication (15 cases), Product Management (20 cases), Order Processing (18 cases). Bao gồm positive và negative scenarios. File Excel có expected results.', 20, 'testcase.xlsx', NULL, 'ChuaXacNhan', '2026-04-22 12:30:00'),
	(9, 8, 8, 'Dashboard', 'Thống kê KPI với 5 biểu đồ: doanh thu theo tháng, top sản phẩm, phân bố khách hàng, tỷ lệ chuyển đổi, traffic sources. Dữ liệu realtime từ Google Analytics API. Export PDF đã hoạt động.', 35, 'kpi.pdf', 2, 'DaXacNhan', '2026-04-22 13:00:00'),
	(10, 9, 9, 'Model v1', 'Hướng dẫn huấn luyện model classification với accuracy 87%. Dataset 10,000 samples đã cleaned và labeled. Jupyter notebook có step-by-step instructions, visualization và model evaluation metrics.', 25, 'model-v1.ipynb', NULL, 'ChuaXacNhan', '2026-04-22 13:30:00'),
	(11, 10, 10, 'UI audit', 'Báo cáo UX/UI audit 25 trang: phân tích 15 màn hình, tìm ra 32 issues về usability, accessibility, consistency. Mỗi issue có severity level, screenshots và recommendations cụ thể.', 45, 'audit.pdf', 4, 'DaXacNhan', '2026-04-22 14:00:00'),
	(12, 11, 11, 'Bảo mật', 'Kiểm thử cơ bản: test OWASP Top 10, tìm thấy 5 vulnerabilities (2 high, 3 medium severity). Báo cáo có proof of concept, impact analysis và remediation steps cho từng lỗ hổng.', 30, 'security.pdf', NULL, 'ChuaXacNhan', '2026-04-22 14:30:00'),
	(13, 12, 12, 'SEO', 'Tối ưu technical SEO: fix 15 broken links, optimize 20 images, improve page speed từ 65 lên 88 điểm. Setup sitemap XML, robots.txt, structured data cho 10 trang quan trọng. Google Search Console đã verify.', 40, 'seo.pdf', 6, 'DaXacNhan', '2026-04-22 15:00:00'),
	(14, 13, 1, 'Content', 'Viết 5 bài blog SEO-friendly (800-1200 từ/bài): "Top 10 Tips...", "How to...", "Ultimate Guide...". Mỗi bài có keyword research, meta description, internal links và featured image suggestions.', 20, 'content.docx', NULL, 'ChuaXacNhan', '2026-04-22 15:30:00'),
	(15, 14, 2, 'Video', 'Dựng video 30s cho Facebook Ads: intro 3s, product showcase 20s, call-to-action 7s. Có subtitles, background music, motion graphics. Giao 3 versions: 16:9, 1:1, 9:16 cho các platforms khác nhau.', 50, 'video.mp4', 2, 'DaXacNhan', '2026-04-22 16:00:00'),
	(16, 15, 3, 'Fanpage', 'Đăng 10 bài trên Facebook fanpage: 5 bài giới thiệu sản phẩm, 3 bài tips hữu ích, 2 bài behind-the-scenes. Mỗi bài có hình ảnh chất lượng cao, caption hấp dẫn, hashtags phù hợp. Engagement rate trung bình 4.2%.', 30, 'post.xlsx', NULL, 'ChuaXacNhan', '2026-04-22 16:30:00'),
	(17, 16, 4, 'E-commerce', 'Khởi tạo shop trên Shopify: setup theme, cấu hình payment methods (COD, VNPay, Momo), shipping zones, tax settings. Import 50 sản phẩm đầu tiên với descriptions và images. Shop đã live ở chế độ password-protected.', 15, 'shop.pdf', 4, 'DaXacNhan', '2026-04-22 17:00:00'),
	(18, 17, 5, 'UX research', 'Phỏng vấn 12 người dùng (mỗi session 45 phút): tìm hiểu pain points, needs, behaviors. Tạo 3 user personas chi tiết với demographics, goals, frustrations. Có audio recordings và transcripts đầy đủ.', 25, 'ux.docx', NULL, 'ChuaXacNhan', '2026-04-22 17:30:00'),
	(19, 18, 6, 'Branding', 'Phương án branding với 3 directions khác nhau: Modern Tech, Elegant Classic, Playful Creative. Mỗi direction có mood board, color palette, typography, visual examples. Presentation 40 slides với rationale cho từng lựa chọn.', 35, 'brand.pdf', 6, 'DaXacNhan', '2026-04-22 18:00:00'),
	(20, 19, 7, 'Minh họa', 'Vẽ 8 minh họa vector cho website: hero image, 4 feature icons, 2 infographics, 1 mascot character. Style flat design, color palette consistent. File AI có layers tổ chức tốt, dễ chỉnh sửa.', 20, 'illu.png', NULL, 'ChuaXacNhan', '2026-04-22 18:30:00'),
	(21, 20, 8, 'Copywriting', 'Viết nội dung cho 5 trang: Homepage (hero, features, testimonials), About Us, Services (3 pages). Tone of voice professional yet friendly. Mỗi section có headline, body copy, CTA. Tổng 3,500 từ.', 30, 'copy.docx', 2, 'DaXacNhan', '2026-04-22 19:00:00'),
	(22, 21, 9, '3D', 'Mô hình 3D sản phẩm với Blender: high-poly model với textures chi tiết, lighting setup cho product shots. Export 5 angles khác nhau ở resolution 4K. File .blend và rendered images PNG.', 40, '3d.obj', NULL, 'ChuaXacNhan', '2026-04-22 19:30:00'),
	(23, 22, 10, 'Automation', 'RPA flow tự động hóa quy trình nhập liệu: đọc data từ Excel, validate, nhập vào hệ thống CRM, gửi email xác nhận. Xử lý được 100 records/giờ. UiPath workflow đã test với 500 sample records.', 25, 'rpa.png', 4, 'DaXacNhan', '2026-04-22 20:00:00'),
	(24, 23, 11, 'CRM', 'Tích hợp CRM Salesforce: mapping fields, setup workflows, import 1,000 customer records. Tạo custom reports và dashboards. Training document 15 trang cho team sử dụng CRM.', 30, 'crm.docx', NULL, 'ChuaXacNhan', '2026-04-22 20:30:00'),
	(25, 24, 12, 'ERP', 'Tích hợp ERP SAP modules: Finance, Inventory, Sales. Setup master data, configure workflows, test transactions. Migration plan cho 5,000 SKUs. User manual 30 trang với screenshots từng bước.', 35, 'erp.pdf', 6, 'DaXacNhan', '2026-04-22 21:00:00'),
	(26, 25, 1, 'IoT', 'Lắp đặt 10 thiết bị IoT sensors: temperature, humidity, motion detectors. Setup gateway, configure MQTT broker, test data transmission. Dashboard realtime hiển thị data từ tất cả sensors. Uptime 99.5%.', 20, 'iot.pdf', NULL, 'ChuaXacNhan', '2026-04-22 21:30:00'),
	(27, 26, 2, 'Game', 'Gameplay demo 3 phút: character movement, combat system, inventory management. Build cho Windows với Unity. FPS stable 60, no major bugs. Có tutorial level để người chơi làm quen với controls.', 30, 'game.mp4', 2, 'DaXacNhan', '2026-04-22 22:00:00'),
	(28, 27, 3, 'AR/VR', 'Demo AR với ARKit: place 3D furniture models trong không gian thực, scale/rotate objects, take screenshots. Test trên iPhone 12 Pro, tracking stable, occlusion hoạt động tốt. Video demo 2 phút.', 25, 'ar.mp4', NULL, 'ChuaXacNhan', '2026-04-22 22:30:00'),
	(29, 28, 4, 'GIS', 'Layer bản đồ với 3 datasets: địa điểm cửa hàng (50 points), khu vực phân phối (15 polygons), tuyến đường giao hàng (20 lines). Sử dụng QGIS, export sang GeoJSON. Có styling và labels rõ ràng.', 40, 'gis.zip', 4, 'DaXacNhan', '2026-04-22 23:00:00'),
	(30, 29, 5, 'Training', 'Đào tạo cơ bản cho 15 nhân viên (3 sessions x 2 giờ): giới thiệu hệ thống, hướng dẫn sử dụng từng module, Q&A. Slides 60 trang, video recordings, quiz assessment. Pass rate 93%.', 50, 'training.pdf', NULL, 'ChuaXacNhan', '2026-04-22 23:30:00')
ON CONFLICT ("TienDoID") DO NOTHING;

INSERT INTO "TranhChap"
	("TranhChapID", "CongViecID", "NguoiGuiID", "GiamSatID", "LyDo", "MoTa", "TrangThai", "YeuCauHoanTien", "NgayMo", "NgayDong")
VALUES
	(1, 1, 1, 1, 'Chậm tiến độ', 'Người thuê cho rằng tiến độ chậm 2 ngày so với cam kết. Freelancer đã hứa giao mockup vào 20/04 nhưng đến 22/04 mới gửi. Ảnh hưởng đến kế hoạch launch sản phẩm của công ty.', 'DangXuLy', 2000000.00, '2026-04-23 09:00:00', NULL),
	(2, 2, 2, 2, 'Chất lượng', 'Chất lượng code chưa đạt yêu cầu: thiếu error handling, không có unit tests, API documentation không đầy đủ. Yêu cầu refactor và bổ sung tests trước khi chấp nhận.', 'MoiMo', 1500000.00, '2026-04-23 09:10:00', NULL),
	(3, 3, 3, 3, 'Phạm vi', 'Thay đổi yêu cầu: khách hàng muốn thêm 3 màn hình mới không có trong scope ban đầu. Freelancer yêu cầu tăng budget 30%. Cần thỏa thuận lại về phạm vi và chi phí.', 'DangXuLy', 1000000.00, '2026-04-23 09:20:00', NULL),
	(4, 4, 4, 4, 'Chậm tiến độ', 'Trễ 3 ngày so với deadline đã cam kết. Freelancer giải thích do bị ốm nhưng không thông báo trước. Người thuê yêu cầu bồi thường 500k cho việc delay.', 'DangXuLy', 500000.00, '2026-04-23 09:30:00', NULL),
	(5, 5, 5, 5, 'Giao tiếp', 'Không phản hồi tin nhắn trong 48 giờ. Người thuê gửi 5 tin nhắn hỏi về tiến độ nhưng freelancer không trả lời. Gây lo lắng về việc dự án có được hoàn thành đúng hạn.', 'MoiMo', 700000.00, '2026-04-23 09:40:00', NULL),
	(6, 6, 6, 6, 'Chi phí', 'Vượt ngân sách: freelancer yêu cầu thêm 900k cho tính năng không có trong báo giá ban đầu. Người thuê cho rằng tính năng này nằm trong scope và không nên tính phí thêm.', 'DangXuLy', 900000.00, '2026-04-23 09:50:00', NULL),
	(7, 7, 1, 7, 'Phạm vi', 'Mở rộng phạm vi công việc: thêm 2 modules mới, tích hợp thêm 3 APIs bên thứ ba. Freelancer đề xuất tăng timeline 2 tuần và budget thêm 800k. Cần đơn vị giám sát xác nhận.', 'MoiMo', 800000.00, '2026-04-23 10:00:00', NULL),
	(8, 8, 2, 8, 'Chất lượng', 'Bug nhiều: tìm thấy 15 bugs trong đó 5 bugs critical ảnh hưởng đến chức năng chính. Yêu cầu freelancer fix tất cả bugs trước khi thanh toán đợt cuối.', 'DangXuLy', 1200000.00, '2026-04-23 10:10:00', NULL),
	(9, 9, 3, 9, 'Chậm tiến độ', 'Trễ 5 ngày: dự án đáng lẽ hoàn thành 18/04 nhưng đến 23/04 vẫn chưa xong. Freelancer không đưa ra lý do rõ ràng. Người thuê yêu cầu hoàn lại 2 triệu tiền đặt cọc.', 'DangXuLy', 2000000.00, '2026-04-23 10:20:00', NULL),
	(10, 10, 4, 1, 'Chi phí', 'Tăng chi phí đột ngột: freelancer thông báo cần thêm 1.1 triệu cho server costs và third-party services. Người thuê cho rằng các chi phí này nên được thông báo từ đầu.', 'MoiMo', 1100000.00, '2026-04-23 10:30:00', NULL),
	(11, 11, 5, 2, 'Giao tiếp', 'Không rõ ràng trong communication: freelancer trả lời mơ hồ, không commit cụ thể về deadline. Nhiều lần hẹn meeting nhưng không tham gia. Ảnh hưởng đến tiến độ dự án.', 'DangXuLy', 600000.00, '2026-04-23 10:40:00', NULL),
	(12, 12, 6, 3, 'Chất lượng', 'Thiếu tính năng: giao sản phẩm thiếu 3 tính năng quan trọng đã liệt kê trong requirements. Freelancer giải thích do hiểu nhầm nhưng người thuê yêu cầu hoàn thiện đầy đủ.', 'MoiMo', 900000.00, '2026-04-23 10:50:00', NULL),
	(13, 13, 1, 4, 'Chậm tiến độ', 'Trễ 2 ngày: deadline 21/04 nhưng giao 23/04. Freelancer xin lỗi và giải thích do workload cao hơn dự kiến. Người thuê chấp nhận nhưng yêu cầu giảm 400k phí.', 'DangXuLy', 400000.00, '2026-04-23 11:00:00', NULL),
	(14, 14, 2, 5, 'Phạm vi', 'Thêm công việc ngoài scope: khách hàng yêu cầu thêm responsive design cho tablet (ban đầu chỉ có desktop và mobile). Freelancer đồng ý làm thêm với phí 700k.', 'MoiMo', 700000.00, '2026-04-23 11:10:00', NULL),
	(15, 15, 3, 6, 'Giao tiếp', 'Trả lời chậm: mất 24-36 giờ mới reply tin nhắn. Người thuê cần feedback nhanh để điều chỉnh kịp thời nhưng freelancer không online thường xuyên. Đề nghị cải thiện responsiveness.', 'DangXuLy', 500000.00, '2026-04-23 11:20:00', NULL),
	(16, 16, 4, 7, 'Chất lượng', 'Kết quả chưa đạt: design không match với brand guidelines đã cung cấp. Màu sắc, typography không đúng. Yêu cầu redesign theo đúng guidelines.', 'MoiMo', 650000.00, '2026-04-23 11:30:00', NULL),
	(17, 17, 5, 8, 'Chi phí', 'Thay đổi giá: freelancer yêu cầu tăng giá 950k do phát hiện công việc phức tạp hơn dự kiến. Người thuê không đồng ý vì đã có báo giá chi tiết từ đầu.', 'DangXuLy', 950000.00, '2026-04-23 11:40:00', NULL),
	(18, 18, 6, 9, 'Chậm tiến độ', 'Trễ 4 ngày: dự án mobile app delay nghiêm trọng. Freelancer giải thích do gặp technical issues với React Native nhưng không thông báo sớm. Yêu cầu bồi thường.', 'MoiMo', 800000.00, '2026-04-23 11:50:00', NULL),
	(19, 19, 1, 1, 'Phạm vi', 'Không đúng yêu cầu: sản phẩm giao không match với mockup đã approve. Nhiều chi tiết khác biệt. Freelancer cần chỉnh sửa lại theo đúng mockup.', 'DangXuLy', 1200000.00, '2026-04-23 12:00:00', NULL),
	(20, 20, 2, 2, 'Chất lượng', 'Sản phẩm lỗi: app crash khi test trên một số devices. Performance kém, loading time quá lâu. Cần optimize và fix bugs trước khi release.', 'MoiMo', 1100000.00, '2026-04-23 12:10:00', NULL),
	(21, 21, 3, 3, 'Giao tiếp', 'Không hợp tác: freelancer từ chối thực hiện revisions hợp lý. Thái độ không chuyên nghiệp khi nhận feedback. Người thuê yêu cầu đơn vị giám sát can thiệp.', 'DangXuLy', 500000.00, '2026-04-23 12:20:00', NULL),
	(22, 22, 4, 4, 'Chi phí', 'Vượt chi phí: tổng chi phí thực tế cao hơn 900k so với báo giá do phát sinh thêm cloud services và APIs. Cần làm rõ trách nhiệm chi trả.', 'MoiMo', 900000.00, '2026-04-23 12:30:00', NULL),
	(23, 23, 5, 5, 'Chậm tiến độ', 'Trễ 6 ngày: dự án CI/CD pipeline delay nghiêm trọng. Ảnh hưởng đến deployment schedule của toàn bộ team. Yêu cầu hoàn lại 1.3 triệu.', 'DangXuLy', 1300000.00, '2026-04-23 12:40:00', NULL),
	(24, 24, 6, 6, 'Chất lượng', 'Không ổn định: hệ thống hay bị downtime, performance không stable. Load testing cho thấy không đáp ứng được yêu cầu 1000 concurrent users như đã cam kết.', 'MoiMo', 1000000.00, '2026-04-23 12:50:00', NULL),
	(25, 25, 1, 7, 'Phạm vi', 'Ngoài hợp đồng: freelancer thực hiện thêm features không có trong scope và yêu cầu thanh toán thêm. Người thuê không yêu cầu các features này.', 'DangXuLy', 700000.00, '2026-04-23 13:00:00', NULL),
	(26, 26, 2, 8, 'Giao tiếp', 'Không hợp tác: từ chối tham gia meetings, không cung cấp progress updates đều đặn. Gây khó khăn cho việc theo dõi và quản lý dự án.', 'MoiMo', 600000.00, '2026-04-23 13:10:00', NULL),
	(27, 27, 3, 9, 'Chi phí', 'Thay đổi giá: sau khi đã thỏa thuận và ký hợp đồng, freelancer yêu cầu tăng giá 800k. Lý do là đánh giá sai độ phức tạp ban đầu.', 'DangXuLy', 800000.00, '2026-04-23 13:20:00', NULL),
	(28, 28, 4, 1, 'Chậm tiến độ', 'Trễ 2 ngày: infrastructure setup chậm hơn dự kiến. Freelancer giải thích do AWS có issues nhưng người thuê cho rằng nên có backup plan.', 'MoiMo', 500000.00, '2026-04-23 13:30:00', NULL),
	(29, 29, 5, 2, 'Chất lượng', 'Chưa đạt yêu cầu: logo design không đủ professional, không phù hợp với target audience. Yêu cầu redesign với concept mới.', 'DangXuLy', 900000.00, '2026-04-23 13:40:00', NULL),
	(30, 30, 6, 3, 'Phạm vi', 'Cần thêm công việc: test coverage chưa đủ, cần thêm integration tests và E2E tests. Freelancer yêu cầu thêm 650k và 3 ngày.', 'MoiMo', 650000.00, '2026-04-23 13:50:00', NULL)
ON CONFLICT ("TranhChapID") DO NOTHING;

INSERT INTO "BangChungTranhChap"
	("BangChungID", "TranhChapID", "NguoiNopID", "GiamSatID", "LoaiBangChung", "NoiDung", "DuongDanFile", "NgayNop")
VALUES
	(1, 1, 1, 1, 'TinNhan', 'Ban chup tin nhan thong bao cham tien do', NULL, '2026-04-23 09:15:00'),
	(2, 1, 3, 1, 'File', 'File lich trinh cong viec freelancer da gui', 'schedule.xlsx', '2026-04-23 09:30:00'),
	(3, 2, 2, 2, 'TinNhan', 'Thong bao chat luong', NULL, '2026-04-23 09:35:00'),
	(4, 3, 3, 3, 'File', 'Bao cao pham vi', 'scope.pdf', '2026-04-23 09:40:00'),
	(5, 4, 4, 4, 'HinhAnh', 'Anh minh hoa loi', 'bug.png', '2026-04-23 09:45:00'),
	(6, 5, 5, 5, 'GhiChu', 'Ghi chu trao doi', NULL, '2026-04-23 09:50:00'),
	(7, 6, 6, 6, 'File', 'Bang chi phi', 'cost.xlsx', '2026-04-23 09:55:00'),
	(8, 7, 1, 7, 'TinNhan', 'Tin nhan lien quan', NULL, '2026-04-23 10:00:00'),
	(9, 8, 2, 8, 'File', 'Bao cao bug', 'bugs.xlsx', '2026-04-23 10:05:00'),
	(10, 9, 3, 9, 'HinhAnh', 'Anh tien do', 'progress.png', '2026-04-23 10:10:00'),
	(11, 10, 4, 1, 'GhiChu', 'Ghi chu', NULL, '2026-04-23 10:15:00'),
	(12, 11, 5, 2, 'File', 'Bien ban', 'report.pdf', '2026-04-23 10:20:00'),
	(13, 12, 6, 3, 'TinNhan', 'Tin nhan trao doi', NULL, '2026-04-23 10:25:00'),
	(14, 13, 1, 4, 'File', 'Tai lieu', 'doc.pdf', '2026-04-23 10:30:00'),
	(15, 14, 2, 5, 'HinhAnh', 'Anh demo', 'demo.png', '2026-04-23 10:35:00'),
	(16, 15, 3, 6, 'GhiChu', 'Ghi chu', NULL, '2026-04-23 10:40:00'),
	(17, 16, 4, 7, 'TinNhan', 'Tin nhan', NULL, '2026-04-23 10:45:00'),
	(18, 17, 5, 8, 'File', 'Chi phi', 'cost2.xlsx', '2026-04-23 10:50:00'),
	(19, 18, 6, 9, 'HinhAnh', 'Anh minh hoa', 'img1.png', '2026-04-23 10:55:00'),
	(20, 19, 1, 1, 'TinNhan', 'Trao doi', NULL, '2026-04-23 11:00:00'),
	(21, 20, 2, 2, 'File', 'Bao cao', 'report2.pdf', '2026-04-23 11:05:00'),
	(22, 21, 3, 3, 'GhiChu', 'Ghi chu', NULL, '2026-04-23 11:10:00'),
	(23, 22, 4, 4, 'TinNhan', 'Tin nhan', NULL, '2026-04-23 11:15:00'),
	(24, 23, 5, 5, 'File', 'Bang tien do', 'schedule2.xlsx', '2026-04-23 11:20:00'),
	(25, 24, 6, 6, 'HinhAnh', 'Anh loi', 'bug2.png', '2026-04-23 11:25:00'),
	(26, 25, 1, 7, 'GhiChu', 'Ghi chu', NULL, '2026-04-23 11:30:00'),
	(27, 26, 2, 8, 'TinNhan', 'Tin nhan', NULL, '2026-04-23 11:35:00'),
	(28, 27, 3, 9, 'File', 'Tai lieu', 'doc2.pdf', '2026-04-23 11:40:00'),
	(29, 28, 4, 1, 'HinhAnh', 'Anh demo', 'demo2.png', '2026-04-23 11:45:00'),
	(30, 29, 5, 2, 'GhiChu', 'Ghi chu', NULL, '2026-04-23 11:50:00')
ON CONFLICT ("BangChungID") DO NOTHING;

INSERT INTO "KetLuanTranhChap"
	("KetLuanID", "TranhChapID", "GiamSatID", "KetQua", "LyDo", "SoTienHoan", "BenChiuPhi", "NgayKetLuan")
VALUES
	(1, 1, 1, 'PhanChia', 'Hai ben deu co trach nhiem trong viec giao tiep va cap nhat tien do', 1000000.00, 'ChiaSe', '2026-04-24 10:00:00'),
	(2, 2, 2, 'HoanTienNguoiThue', 'Chat luong khong dat', 1500000.00, 'Freelancer', '2026-04-24 10:05:00'),
	(3, 3, 3, 'TiepTuc', 'Mo ta ro rang', 0.00, 'HeThong', '2026-04-24 10:10:00'),
	(4, 4, 4, 'PhanChia', 'Tre tien do', 500000.00, 'ChiaSe', '2026-04-24 10:15:00'),
	(5, 5, 5, 'HoanTienNguoiThue', 'Khong phan hoi', 700000.00, 'Freelancer', '2026-04-24 10:20:00'),
	(6, 6, 6, 'TiepTuc', 'Vuot ngan sach', 0.00, 'HeThong', '2026-04-24 10:25:00'),
	(7, 7, 7, 'HuyHopDong', 'Pham vi thay doi', 800000.00, 'NguoiThue', '2026-04-24 10:30:00'),
	(8, 8, 8, 'PhanChia', 'Bug nhieu', 600000.00, 'ChiaSe', '2026-04-24 10:35:00'),
	(9, 9, 9, 'HoanTienNguoiThue', 'Tre 5 ngay', 2000000.00, 'Freelancer', '2026-04-24 10:40:00'),
	(10, 10, 1, 'TiepTuc', 'Dieu chinh chi phi', 0.00, 'HeThong', '2026-04-24 10:45:00'),
	(11, 11, 2, 'PhanChia', 'Giao tiep kem', 400000.00, 'ChiaSe', '2026-04-24 10:50:00'),
	(12, 12, 3, 'HoanTienNguoiThue', 'Thieu tinh nang', 900000.00, 'Freelancer', '2026-04-24 10:55:00'),
	(13, 13, 4, 'TiepTuc', 'Tre nhe', 0.00, 'HeThong', '2026-04-24 11:00:00'),
	(14, 14, 5, 'PhanChia', 'Them cong viec', 700000.00, 'ChiaSe', '2026-04-24 11:05:00'),
	(15, 15, 6, 'HoanTienNguoiThue', 'Tra loi cham', 500000.00, 'Freelancer', '2026-04-24 11:10:00'),
	(16, 16, 7, 'TiepTuc', 'Chat luong dat', 0.00, 'HeThong', '2026-04-24 11:15:00'),
	(17, 17, 8, 'PhanChia', 'Thay doi gia', 600000.00, 'ChiaSe', '2026-04-24 11:20:00'),
	(18, 18, 9, 'HoanTienNguoiThue', 'Tre 4 ngay', 800000.00, 'Freelancer', '2026-04-24 11:25:00'),
	(19, 19, 1, 'TiepTuc', 'Co the tiep tuc', 0.00, 'HeThong', '2026-04-24 11:30:00'),
	(20, 20, 2, 'PhanChia', 'San pham loi', 700000.00, 'ChiaSe', '2026-04-24 11:35:00'),
	(21, 21, 3, 'HoanTienNguoiThue', 'Khong hop tac', 500000.00, 'Freelancer', '2026-04-24 11:40:00'),
	(22, 22, 4, 'TiepTuc', 'Can dieu chinh', 0.00, 'HeThong', '2026-04-24 11:45:00'),
	(23, 23, 5, 'PhanChia', 'Tre 6 ngay', 900000.00, 'ChiaSe', '2026-04-24 11:50:00'),
	(24, 24, 6, 'HoanTienNguoiThue', 'Khong on dinh', 1000000.00, 'Freelancer', '2026-04-24 11:55:00'),
	(25, 25, 7, 'TiepTuc', 'Ngoai hop dong', 0.00, 'HeThong', '2026-04-24 12:00:00'),
	(26, 26, 8, 'PhanChia', 'Giao tiep kem', 600000.00, 'ChiaSe', '2026-04-24 12:05:00'),
	(27, 27, 9, 'HoanTienNguoiThue', 'Thay doi gia', 800000.00, 'Freelancer', '2026-04-24 12:10:00'),
	(28, 28, 1, 'TiepTuc', 'Tre nhe', 0.00, 'HeThong', '2026-04-24 12:15:00'),
	(29, 29, 2, 'PhanChia', 'Chua dat', 700000.00, 'ChiaSe', '2026-04-24 12:20:00'),
	(30, 30, 3, 'HoanTienNguoiThue', 'Them cong viec', 650000.00, 'Freelancer', '2026-04-24 12:25:00')
ON CONFLICT ("KetLuanID") DO NOTHING;

INSERT INTO "ThanhToan"
	("ThanhToanID", "CongViecID", "NguoiThueID", "SoTien", "LoaiTT", "PhuongThuc", "TrangThai", "GiamSatID", "PhiGiamSatTT", "GhiChu", "NgayTao")
VALUES
	(1, 1, 1, 3000000.00, 'DatCoc', 'ChuyenKhoan', 'ThanhCong', 1, 200000.00, 'Dot dat coc 1', '2026-04-20 11:00:00'),
	(2, 1, 1, 4000000.00, 'ThanhToanCuoi', 'ThanhToanQuaMang', 'ChoXuLy', 1, 300000.00, 'Thanh toan sau khi nghiem thu', '2026-04-24 10:30:00'),
	(3, 1, 1, 500000.00, 'PhiGiamSat', 'Vi', 'ThanhCong', 1, 500000.00, 'Phi giam sat cong viec', '2026-04-24 10:45:00'),
	(4, 2, 2, 2500000.00, 'DatCoc', 'ChuyenKhoan', 'ThanhCong', 2, 150000.00, 'Dat coc', '2026-04-20 11:10:00'),
	(5, 3, 3, 3000000.00, 'DatCoc', 'Vi', 'ThanhCong', 3, 160000.00, 'Dat coc', '2026-04-20 11:20:00'),
	(6, 4, 4, 3500000.00, 'DatCoc', 'ThanhToanQuaMang', 'ChoXuLy', 4, 170000.00, 'Dat coc', '2026-04-20 11:30:00'),
	(7, 5, 5, 3800000.00, 'ThanhToanCuoi', 'ChuyenKhoan', 'ThanhCong', 5, 180000.00, 'Thanh toan cuoi', '2026-04-20 11:40:00'),
	(8, 6, 6, 4200000.00, 'DatCoc', 'Vi', 'ThanhCong', 6, 190000.00, 'Dat coc', '2026-04-20 11:50:00'),
	(9, 7, 1, 2600000.00, 'ThanhToanCuoi', 'ChuyenKhoan', 'ChoXuLy', 7, 150000.00, 'Thanh toan', '2026-04-20 12:00:00'),
	(10, 8, 2, 2800000.00, 'DatCoc', 'ThanhToanQuaMang', 'ThanhCong', 8, 140000.00, 'Dat coc', '2026-04-20 12:10:00'),
	(11, 9, 3, 3000000.00, 'ThanhToanCuoi', 'Vi', 'ThanhCong', 9, 160000.00, 'Thanh toan', '2026-04-20 12:20:00'),
	(12, 10, 4, 3200000.00, 'DatCoc', 'ChuyenKhoan', 'ChoXuLy', 1, 170000.00, 'Dat coc', '2026-04-20 12:30:00'),
	(13, 11, 5, 3400000.00, 'PhiGiamSat', 'Vi', 'ThanhCong', 2, 180000.00, 'Phi giam sat', '2026-04-20 12:40:00'),
	(14, 12, 6, 3600000.00, 'DatCoc', 'ChuyenKhoan', 'ThanhCong', 3, 190000.00, 'Dat coc', '2026-04-20 12:50:00'),
	(15, 13, 1, 3800000.00, 'ThanhToanCuoi', 'ThanhToanQuaMang', 'ThanhCong', 4, 200000.00, 'Thanh toan', '2026-04-20 13:00:00'),
	(16, 14, 2, 4000000.00, 'DatCoc', 'Vi', 'ChoXuLy', 5, 210000.00, 'Dat coc', '2026-04-20 13:10:00'),
	(17, 15, 3, 4200000.00, 'ThanhToanCuoi', 'ChuyenKhoan', 'ThanhCong', 6, 220000.00, 'Thanh toan', '2026-04-20 13:20:00'),
	(18, 16, 4, 4400000.00, 'DatCoc', 'ThanhToanQuaMang', 'ThanhCong', 7, 230000.00, 'Dat coc', '2026-04-20 13:30:00'),
	(19, 17, 5, 4600000.00, 'PhiGiamSat', 'Vi', 'ThanhCong', 8, 240000.00, 'Phi giam sat', '2026-04-20 13:40:00'),
	(20, 18, 6, 4800000.00, 'DatCoc', 'ChuyenKhoan', 'ChoXuLy', 9, 250000.00, 'Dat coc', '2026-04-20 13:50:00'),
	(21, 19, 1, 5000000.00, 'ThanhToanCuoi', 'Vi', 'ThanhCong', 1, 260000.00, 'Thanh toan', '2026-04-20 14:00:00'),
	(22, 20, 2, 5200000.00, 'DatCoc', 'ChuyenKhoan', 'ThanhCong', 2, 270000.00, 'Dat coc', '2026-04-20 14:10:00'),
	(23, 21, 3, 5400000.00, 'ThanhToanCuoi', 'ThanhToanQuaMang', 'ChoXuLy', 3, 280000.00, 'Thanh toan', '2026-04-20 14:20:00'),
	(24, 22, 4, 5600000.00, 'DatCoc', 'Vi', 'ThanhCong', 4, 290000.00, 'Dat coc', '2026-04-20 14:30:00'),
	(25, 23, 5, 5800000.00, 'PhiGiamSat', 'ChuyenKhoan', 'ThanhCong', 5, 300000.00, 'Phi giam sat', '2026-04-20 14:40:00'),
	(26, 24, 6, 6000000.00, 'DatCoc', 'ThanhToanQuaMang', 'ChoXuLy', 6, 310000.00, 'Dat coc', '2026-04-20 14:50:00'),
	(27, 25, 1, 6200000.00, 'ThanhToanCuoi', 'Vi', 'ThanhCong', 7, 320000.00, 'Thanh toan', '2026-04-20 15:00:00'),
	(28, 26, 2, 6400000.00, 'DatCoc', 'ChuyenKhoan', 'ThanhCong', 8, 330000.00, 'Dat coc', '2026-04-20 15:10:00'),
	(29, 27, 3, 6600000.00, 'ThanhToanCuoi', 'ThanhToanQuaMang', 'ChoXuLy', 9, 340000.00, 'Thanh toan', '2026-04-20 15:20:00'),
	(30, 28, 4, 6800000.00, 'DatCoc', 'Vi', 'ThanhCong', 1, 350000.00, 'Dat coc', '2026-04-20 15:30:00')
ON CONFLICT ("ThanhToanID") DO NOTHING;

INSERT INTO "CuocHoiThoai"
	("CuocHoiThoaiID", "CongViecID", "ThanhVien1ID", "ThanhVien2ID", "GiamSatID", "TinNhanCuoi", "TrangThai", "NgayTao")
VALUES
	(1, 1, 1, 3, 1, '2026-04-24 09:20:00', 'DangMo', '2026-04-20 09:15:00'),
	(2, 2, 2, 4, NULL, NULL, 'DangMo', '2026-04-20 09:20:00'),
	(3, 3, 3, 11, 2, NULL, 'DangMo', '2026-04-20 09:25:00'),
	(4, 4, 4, 12, 3, NULL, 'DangMo', '2026-04-20 09:30:00'),
	(5, 5, 5, 13, NULL, NULL, 'DangMo', '2026-04-20 09:35:00'),
	(6, 6, 6, 14, 4, NULL, 'DangMo', '2026-04-20 09:40:00'),
	(7, 7, 1, 15, NULL, NULL, 'DangMo', '2026-04-20 09:45:00'),
	(8, 8, 2, 16, 5, NULL, 'DangMo', '2026-04-20 09:50:00'),
	(9, 9, 3, 17, NULL, NULL, 'DangMo', '2026-04-20 09:55:00'),
	(10, 10, 4, 18, 6, NULL, 'DangMo', '2026-04-20 10:00:00'),
	(11, 11, 5, 19, NULL, NULL, 'DangMo', '2026-04-20 10:05:00'),
	(12, 12, 6, 20, 7, NULL, 'DangMo', '2026-04-20 10:10:00'),
	(13, 13, 1, 3, NULL, NULL, 'DangMo', '2026-04-20 10:15:00'),
	(14, 14, 2, 4, 8, NULL, 'DangMo', '2026-04-20 10:20:00'),
	(15, 15, 3, 11, NULL, NULL, 'DangMo', '2026-04-20 10:25:00'),
	(16, 16, 4, 12, 9, NULL, 'DangMo', '2026-04-20 10:30:00'),
	(17, 17, 5, 13, NULL, NULL, 'DangMo', '2026-04-20 10:35:00'),
	(18, 18, 6, 14, 1, NULL, 'DangMo', '2026-04-20 10:40:00'),
	(19, 19, 1, 15, NULL, NULL, 'DangMo', '2026-04-20 10:45:00'),
	(20, 20, 2, 16, 2, NULL, 'DangMo', '2026-04-20 10:50:00'),
	(21, 21, 3, 17, NULL, NULL, 'DangMo', '2026-04-20 10:55:00'),
	(22, 22, 4, 18, 3, NULL, 'DangMo', '2026-04-20 11:00:00'),
	(23, 23, 5, 19, NULL, NULL, 'DangMo', '2026-04-20 11:05:00'),
	(24, 24, 6, 20, 4, NULL, 'DangMo', '2026-04-20 11:10:00'),
	(25, 25, 1, 3, NULL, NULL, 'DangMo', '2026-04-20 11:15:00'),
	(26, 26, 2, 4, 5, NULL, 'DangMo', '2026-04-20 11:20:00'),
	(27, 27, 3, 11, NULL, NULL, 'DangMo', '2026-04-20 11:25:00'),
	(28, 28, 4, 12, 6, NULL, 'DangMo', '2026-04-20 11:30:00'),
	(29, 29, 5, 13, NULL, NULL, 'DangMo', '2026-04-20 11:35:00'),
	(30, 30, 6, 14, 7, NULL, 'DangMo', '2026-04-20 11:40:00')
ON CONFLICT ("CuocHoiThoaiID") DO NOTHING;

INSERT INTO "TinNhan"
	("TinNhanID", "CuocHoiThoaiID", "NguoiGuiID", "NoiDung", "LoaiTin", "DaDoc", "NgayTao")
VALUES
	(1, 1, 1, 'Ban co the gui ban cap nhat ngay hom nay khong?', 'VanBan', true, '2026-04-24 09:00:00'),
	(2, 1, 3, 'Toi da cap nhat mockup va dang cho xac nhan.', 'VanBan', true, '2026-04-24 09:05:00'),
	(3, 1, 1, 'Ok, toi se nhan xet trong 1 gio toi.', 'VanBan', false, '2026-04-24 09:20:00'),
	(4, 2, 2, 'Du an API se bat dau vao thu 2.', 'VanBan', false, '2026-04-24 09:30:00'),
	(5, 2, 4, 'Cam on, toi se chuan bi tai lieu.', 'VanBan', true, '2026-04-24 09:35:00'),
	(6, 3, 3, 'Xin chao, toi can them thong tin ve du an.', 'VanBan', true, '2026-04-24 09:40:00'),
	(7, 3, 5, 'Toi se gui chi tiet qua email.', 'VanBan', false, '2026-04-24 09:45:00'),
	(8, 4, 4, 'Logo da hoan thanh 50%.', 'VanBan', true, '2026-04-24 09:50:00'),
	(9, 4, 6, 'Rat tot, hay tiep tuc.', 'VanBan', true, '2026-04-24 09:55:00'),
	(10, 5, 5, 'Khi nao bat dau du an?', 'VanBan', false, '2026-04-24 10:00:00'),
	(11, 5, 7, 'Tuan sau chung ta se khoi dong.', 'VanBan', true, '2026-04-24 10:05:00'),
	(12, 6, 6, 'Toi can xem lai yeu cau.', 'VanBan', true, '2026-04-24 10:10:00'),
	(13, 6, 8, 'Duoc, toi se gui lai file.', 'VanBan', false, '2026-04-24 10:15:00'),
	(14, 7, 7, 'CI/CD da setup xong chua?', 'VanBan', true, '2026-04-24 10:20:00'),
	(15, 7, 9, 'Dang trong qua trinh cau hinh.', 'VanBan', true, '2026-04-24 10:25:00'),
	(16, 8, 8, 'Test case da viet xong.', 'VanBan', false, '2026-04-24 10:30:00'),
	(17, 8, 10, 'Tot, hay bat dau test.', 'VanBan', true, '2026-04-24 10:35:00'),
	(18, 9, 9, 'Dashboard can them bieu do nao?', 'VanBan', true, '2026-04-24 10:40:00'),
	(19, 9, 11, 'Them bieu do tron va cot.', 'VanBan', false, '2026-04-24 10:45:00'),
	(20, 10, 10, 'Model AI da huan luyen xong.', 'VanBan', true, '2026-04-24 10:50:00'),
	(21, 10, 12, 'Do chinh xac bao nhieu?', 'VanBan', true, '2026-04-24 10:55:00'),
	(22, 11, 11, 'UI audit se mat bao lau?', 'VanBan', false, '2026-04-24 11:00:00'),
	(23, 11, 13, 'Khoang 3 ngay lam viec.', 'VanBan', true, '2026-04-24 11:05:00'),
	(24, 12, 12, 'Bao mat can chu y diem nao?', 'VanBan', true, '2026-04-24 11:10:00'),
	(25, 12, 14, 'Chu trong SQL injection va XSS.', 'VanBan', false, '2026-04-24 11:15:00'),
	(26, 13, 13, 'SEO technical da toi uu.', 'VanBan', true, '2026-04-24 11:20:00'),
	(27, 13, 15, 'Cam on, toi se kiem tra.', 'VanBan', true, '2026-04-24 11:25:00'),
	(28, 14, 14, 'Content da viet xong 5 bai.', 'VanBan', false, '2026-04-24 11:30:00'),
	(29, 14, 16, 'Hay gui toi xem qua.', 'VanBan', true, '2026-04-24 11:35:00'),
	(30, 15, 15, 'Video da render xong.', 'VanBan', true, '2026-04-24 11:40:00')
ON CONFLICT ("TinNhanID") DO NOTHING;

INSERT INTO "DanhGia"
	("DanhGiaID", "CongViecID", "NguoiDanhGiaID", "NguoiDuocDGID", "DiemSo", "BinhLuan", "LoaiDanhGia", "GiamSatID", "NgayTao")
VALUES
	(1, 1, 1, 3, 5, 'Lam viec nhanh, chu dong cap nhat', 'NguoiThue_DanhGia_Freelancer', 1, '2026-04-25 08:00:00'),
	(2, 1, 3, 1, 4, 'Yeu cau ro rang, phoi hop tot', 'Freelancer_DanhGia_NguoiThue', 1, '2026-04-25 08:10:00'),
	(3, 2, 2, 4, 5, 'Ky nang tot, giao tiep tot', 'NguoiThue_DanhGia_Freelancer', 2, '2026-04-25 08:20:00'),
	(4, 2, 4, 2, 4, 'Khach hang de tinh, thanh toan dung han', 'Freelancer_DanhGia_NguoiThue', 2, '2026-04-25 08:30:00'),
	(5, 3, 3, 11, 4, 'Thiet ke dep, sang tao', 'NguoiThue_DanhGia_Freelancer', 3, '2026-04-25 08:40:00'),
	(6, 3, 11, 3, 5, 'Yeu cau chi tiet, ro rang', 'Freelancer_DanhGia_NguoiThue', 3, '2026-04-25 08:50:00'),
	(7, 4, 4, 12, 5, 'Fullstack gioi, giai quyet van de nhanh', 'NguoiThue_DanhGia_Freelancer', 4, '2026-04-25 09:00:00'),
	(8, 4, 12, 4, 4, 'Du an ro rang, hop tac tot', 'Freelancer_DanhGia_NguoiThue', 4, '2026-04-25 09:10:00'),
	(9, 5, 5, 13, 3, 'Can cai thien ky nang giao tiep', 'NguoiThue_DanhGia_Freelancer', 5, '2026-04-25 09:20:00'),
	(10, 5, 13, 5, 4, 'Khach hang tot, nhung yeu cau nhieu', 'Freelancer_DanhGia_NguoiThue', 5, '2026-04-25 09:30:00'),
	(11, 6, 6, 14, 5, 'DevOps xuat sac, setup nhanh', 'NguoiThue_DanhGia_Freelancer', 6, '2026-04-25 09:40:00'),
	(12, 6, 14, 6, 5, 'Du an thu vi, thanh toan nhanh', 'Freelancer_DanhGia_NguoiThue', 6, '2026-04-25 09:50:00'),
	(13, 7, 1, 15, 4, 'Mobile app dep, UX tot', 'NguoiThue_DanhGia_Freelancer', 7, '2026-04-25 10:00:00'),
	(14, 7, 15, 1, 4, 'Khach hang chuyen nghiep', 'Freelancer_DanhGia_NguoiThue', 7, '2026-04-25 10:10:00'),
	(15, 8, 2, 16, 4, 'Phan tich du lieu chinh xac', 'NguoiThue_DanhGia_Freelancer', 8, '2026-04-25 10:20:00'),
	(16, 8, 16, 2, 3, 'Yeu cau thay doi nhieu', 'Freelancer_DanhGia_NguoiThue', 8, '2026-04-25 10:30:00'),
	(17, 9, 3, 17, 5, 'AI model rat tot, do chinh xac cao', 'NguoiThue_DanhGia_Freelancer', 9, '2026-04-25 10:40:00'),
	(18, 9, 17, 3, 5, 'Du an AI thu vi, hoc duoc nhieu', 'Freelancer_DanhGia_NguoiThue', 9, '2026-04-25 10:50:00'),
	(19, 10, 4, 18, 4, 'Content chat luong, SEO tot', 'NguoiThue_DanhGia_Freelancer', 1, '2026-04-25 11:00:00'),
	(20, 10, 18, 4, 4, 'Khach hang ro rang, de lam viec', 'Freelancer_DanhGia_NguoiThue', 1, '2026-04-25 11:10:00'),
	(21, 11, 5, 19, 4, 'UI audit chi tiet, bao cao tot', 'NguoiThue_DanhGia_Freelancer', 2, '2026-04-25 11:20:00'),
	(22, 11, 19, 5, 4, 'Du an nho, thanh toan nhanh', 'Freelancer_DanhGia_NguoiThue', 2, '2026-04-25 11:30:00'),
	(23, 12, 6, 20, 5, 'Bao mat tot, kiem tra ky luong', 'NguoiThue_DanhGia_Freelancer', 3, '2026-04-25 11:40:00'),
	(24, 12, 20, 6, 5, 'Khach hang chuyen nghiep, du an lon', 'Freelancer_DanhGia_NguoiThue', 3, '2026-04-25 11:50:00'),
	(25, 13, 1, 3, 4, 'SEO technical tot, toc do tang', 'NguoiThue_DanhGia_Freelancer', 4, '2026-04-25 12:00:00'),
	(26, 13, 3, 1, 4, 'Yeu cau ro rang, hop tac tot', 'Freelancer_DanhGia_NguoiThue', 4, '2026-04-25 12:10:00'),
	(27, 14, 2, 4, 3, 'Content can cai thien them', 'NguoiThue_DanhGia_Freelancer', 5, '2026-04-25 12:20:00'),
	(28, 14, 4, 2, 4, 'Khach hang tot, feedback nhanh', 'Freelancer_DanhGia_NguoiThue', 5, '2026-04-25 12:30:00'),
	(29, 15, 3, 11, 5, 'Video editing xuat sac, sang tao', 'NguoiThue_DanhGia_Freelancer', 6, '2026-04-25 12:40:00'),
	(30, 15, 11, 3, 5, 'Du an video thu vi, thanh toan tot', 'Freelancer_DanhGia_NguoiThue', 6, '2026-04-25 12:50:00')
ON CONFLICT ("DanhGiaID") DO NOTHING;

INSERT INTO "ThongBao"
	("ThongBaoID", "TaiKhoanID", "TieuDe", "NoiDung", "LoaiThongBao", "DaDoc", "GiamSatID", "NgayTao")
VALUES
	(1, 3, 'Bao gia duoc chap nhan', 'Yeu cau #1 da chon bao gia cua ban', 'BaoGia', false, NULL, '2026-04-20 09:05:00'),
	(2, 1, 'Tien do moi', 'Freelancer vua cap nhat tien do 60%', 'CongViec', false, 1, '2026-04-22 09:40:00'),
	(3, 5, 'Tranh chap moi', 'Can xu ly tranh chap cong viec #1', 'TranhChap', false, 1, '2026-04-23 09:05:00'),
	(4, 4, 'Bao gia duoc chap nhan', 'Yeu cau #2 da chon bao gia cua ban', 'BaoGia', true, NULL, '2026-04-20 09:10:00'),
	(5, 2, 'Thanh toan thanh cong', 'Thanh toan dat coc da duoc xu ly', 'ThanhToan', true, NULL, '2026-04-20 11:15:00'),
	(6, 14, 'Cong viec moi', 'Ban co cong viec moi phu hop', 'CongViec', false, NULL, '2026-04-20 12:00:00'),
	(7, 1, 'Giam sat duoc chap nhan', 'Yeu cau giam sat cong viec #3 da duoc chap nhan', 'GiamSat', true, 2, '2026-04-20 10:15:00'),
	(8, 2, 'Tien do moi', 'Freelancer vua cap nhat tien do 40%', 'CongViec', false, 3, '2026-04-21 10:00:00'),
	(9, 3, 'Bao gia moi', 'Ban nhan duoc bao gia moi cho yeu cau #5', 'BaoGia', false, NULL, '2026-04-20 09:00:00'),
	(10, 4, 'Thanh toan thanh cong', 'Thanh toan cuoi da duoc xu ly', 'ThanhToan', true, NULL, '2026-04-24 11:00:00'),
	(11, 5, 'Tranh chap da giai quyet', 'Tranh chap cong viec #2 da duoc giai quyet', 'TranhChap', true, 2, '2026-04-24 10:10:00'),
	(12, 6, 'Danh gia moi', 'Ban nhan duoc danh gia 5 sao', 'DanhGia', false, NULL, '2026-04-25 08:15:00'),
	(13, 1, 'Cong viec sap het han', 'Cong viec #4 sap het han trong 3 ngay', 'CongViec', false, 4, '2026-04-23 09:00:00'),
	(14, 2, 'Bao gia duoc chap nhan', 'Yeu cau #6 da chon bao gia cua ban', 'BaoGia', true, NULL, '2026-04-20 09:15:00'),
	(15, 3, 'Thong bao he thong', 'Ban co tin nhan moi tu nguoi thue', 'HeThong', false, NULL, '2026-04-24 09:10:00'),
	(16, 4, 'Giam sat duoc chap nhan', 'Yeu cau giam sat cong viec #6 da duoc chap nhan', 'GiamSat', true, 4, '2026-04-20 10:20:00'),
	(17, 5, 'Thanh toan thanh cong', 'Phi giam sat da duoc thanh toan', 'ThanhToan', true, 1, '2026-04-24 10:50:00'),
	(18, 6, 'Tien do moi', 'Freelancer vua cap nhat tien do 80%', 'CongViec', false, 5, '2026-04-22 14:00:00'),
	(19, 1, 'Thong bao he thong', 'Co bao cao vi pham moi can xu ly', 'HeThong', false, NULL, '2026-04-21 14:05:00'),
	(20, 2, 'Danh gia moi', 'Ban nhan duoc danh gia 4 sao', 'DanhGia', true, NULL, '2026-04-25 09:00:00'),
	(21, 21, 'Cong viec hoan thanh', 'Cong viec #1 da hoan thanh', 'CongViec', false, 1, '2026-04-25 10:00:00'),
	(22, 22, 'Tranh chap moi', 'Can xu ly tranh chap cong viec #5', 'TranhChap', false, 5, '2026-04-23 09:45:00'),
	(23, 23, 'Bao gia moi', 'Ban nhan duoc bao gia moi cho yeu cau #13', 'BaoGia', false, NULL, '2026-04-20 10:15:00'),
	(24, 24, 'Giam sat duoc chap nhan', 'Yeu cau giam sat cong viec #10 da duoc chap nhan', 'GiamSat', true, 6, '2026-04-20 10:55:00'),
	(25, 25, 'Thanh toan thanh cong', 'Thanh toan dat coc da duoc xu ly', 'ThanhToan', true, NULL, '2026-04-20 13:05:00'),
	(26, 26, 'Thong bao he thong', 'Ban co tin nhan moi tu freelancer', 'HeThong', false, NULL, '2026-04-24 10:20:00'),
	(27, 27, 'Tien do moi', 'Freelancer vua cap nhat tien do 50%', 'CongViec', false, 7, '2026-04-22 11:00:00'),
	(28, 28, 'Danh gia moi', 'Ban nhan duoc danh gia 5 sao', 'DanhGia', true, NULL, '2026-04-25 10:20:00'),
	(29, 29, 'Yeu cau moi', 'Ban co yeu cau moi phu hop', 'YeuCau', false, NULL, '2026-04-20 13:45:00'),
	(30, 30, 'Tranh chap da giai quyet', 'Tranh chap cong viec #10 da duoc giai quyet', 'TranhChap', true, 1, '2026-04-24 11:35:00')
ON CONFLICT ("ThongBaoID") DO NOTHING;

INSERT INTO "BaoCao"
	("BaoCaoID", "NguoiBaoCaoID", "NguoiBiCaoID", "LyDo", "MoTa", "TrangThai", "KetQua", "AdminXuLyID", "NgayTao", "NgayXuLy")
VALUES
	(1, 2, 4, 'Spam tin nhan', 'Gui nhieu tin nhan khong lien quan du an', 'DangXuLy', NULL, 6, '2026-04-21 14:00:00', NULL),
	(2, 3, 5, 'Vi pham hop dong', 'Khong hoan thanh cong viec dung thoi han', 'DangXuLy', NULL, 6, '2026-04-21 14:10:00', NULL),
	(3, 4, 6, 'Chat luong kem', 'San pham khong dat yeu cau', 'DaXuLy', 'Canh cao', 6, '2026-04-21 14:20:00', '2026-04-22 10:00:00'),
	(4, 5, 7, 'Giao tiep khong tot', 'Khong phan hoi tin nhan', 'DangXuLy', NULL, 29, '2026-04-21 14:30:00', NULL),
	(5, 6, 8, 'Spam tin nhan', 'Gui qua nhieu tin nhan quang cao', 'DaXuLy', 'Khoa tai khoan 7 ngay', 29, '2026-04-21 14:40:00', '2026-04-22 11:00:00'),
	(6, 7, 9, 'Lua dao', 'Yeu cau thanh toan ngoai he thong', 'DangXuLy', NULL, 6, '2026-04-21 14:50:00', NULL),
	(7, 8, 10, 'Vi pham hop dong', 'Khong giao san pham', 'DaXuLy', 'Hoan tien', 6, '2026-04-21 15:00:00', '2026-04-23 09:00:00'),
	(8, 9, 11, 'Noi dung khong phu hop', 'Dang noi dung xuc pham', 'DangXuLy', NULL, 29, '2026-04-21 15:10:00', NULL),
	(9, 10, 12, 'Chat luong kem', 'Code khong chay duoc', 'DaXuLy', 'Canh cao', 29, '2026-04-21 15:20:00', '2026-04-22 14:00:00'),
	(10, 11, 13, 'Giao tiep khong tot', 'Thai do khong chuyen nghiep', 'DangXuLy', NULL, 6, '2026-04-21 15:30:00', NULL),
	(11, 12, 14, 'Vi pham hop dong', 'Tang gia dot ngot', 'DaXuLy', 'Canh cao', 6, '2026-04-21 15:40:00', '2026-04-23 10:00:00'),
	(12, 13, 15, 'Spam tin nhan', 'Gui tin nhan lien tuc', 'DangXuLy', NULL, 29, '2026-04-21 15:50:00', NULL),
	(13, 14, 16, 'Chat luong kem', 'Thiet ke khong dep', 'DaXuLy', 'Khong co vi pham', 29, '2026-04-21 16:00:00', '2026-04-22 15:00:00'),
	(14, 15, 17, 'Lua dao', 'Thong tin gia mao', 'DangXuLy', NULL, 6, '2026-04-21 16:10:00', NULL),
	(15, 16, 18, 'Vi pham hop dong', 'Khong tuan thu thoa thuan', 'DaXuLy', 'Canh cao', 6, '2026-04-21 16:20:00', '2026-04-23 11:00:00'),
	(16, 17, 19, 'Giao tiep khong tot', 'Khong tra loi email', 'DangXuLy', NULL, 29, '2026-04-21 16:30:00', NULL),
	(17, 18, 20, 'Noi dung khong phu hop', 'Noi dung vi pham', 'DaXuLy', 'Xoa noi dung', 29, '2026-04-21 16:40:00', '2026-04-22 16:00:00'),
	(18, 19, 21, 'Chat luong kem', 'San pham loi nhieu', 'DangXuLy', NULL, 6, '2026-04-21 16:50:00', NULL),
	(19, 20, 22, 'Spam tin nhan', 'Gui tin nhan rac', 'DaXuLy', 'Canh cao', 6, '2026-04-21 17:00:00', '2026-04-23 12:00:00'),
	(20, 21, 23, 'Vi pham hop dong', 'Huy hop dong dot ngot', 'DangXuLy', NULL, 29, '2026-04-21 17:10:00', NULL),
	(21, 22, 24, 'Lua dao', 'Lua dao tien dat coc', 'DaXuLy', 'Khoa tai khoan vinh vien', 29, '2026-04-21 17:20:00', '2026-04-22 17:00:00'),
	(22, 23, 25, 'Giao tiep khong tot', 'Noi chuyen bat lich su', 'DangXuLy', NULL, 6, '2026-04-21 17:30:00', NULL),
	(23, 24, 26, 'Chat luong kem', 'Khong dung yeu cau', 'DaXuLy', 'Canh cao', 6, '2026-04-21 17:40:00', '2026-04-23 13:00:00'),
	(24, 25, 27, 'Noi dung khong phu hop', 'Quang cao spam', 'DangXuLy', NULL, 29, '2026-04-21 17:50:00', NULL),
	(25, 26, 28, 'Vi pham hop dong', 'Khong lam dung tien do', 'DaXuLy', 'Canh cao', 29, '2026-04-21 18:00:00', '2026-04-22 18:00:00'),
	(26, 27, 29, 'Spam tin nhan', 'Gui tin nhan qua nhieu', 'DangXuLy', NULL, 6, '2026-04-21 18:10:00', NULL),
	(27, 28, 30, 'Chat luong kem', 'Ket qua khong tot', 'DaXuLy', 'Khong co vi pham', 6, '2026-04-21 18:20:00', '2026-04-23 14:00:00'),
	(28, 29, 1, 'Giao tiep khong tot', 'Khong hop tac', 'DangXuLy', NULL, 29, '2026-04-21 18:30:00', NULL),
	(29, 30, 2, 'Vi pham hop dong', 'Thay doi yeu cau lien tuc', 'DaXuLy', 'Canh cao', 29, '2026-04-21 18:40:00', '2026-04-22 19:00:00'),
	(30, 1, 3, 'Lua dao', 'Thong tin khong chinh xac', 'DangXuLy', NULL, 6, '2026-04-21 18:50:00', NULL)
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
INSERT INTO "FreelancerKyNang" ("FreelancerID", "KyNangID")
VALUES
	-- FreelancerID 1 (TaiKhoanID=3): Frontend Engineer - React, Next.js, UI/UX, Figma, TypeScript, TailwindCSS
	(1, 11), (1, 12), (1, 20), (1, 19), (1, 14), (1, 15),
	-- FreelancerID 2 (TaiKhoanID=4): Backend Engineer - NestJS, PostgreSQL, Redis, Docker, JWT, REST API
	(2, 1), (2, 2), (2, 3), (2, 6), (2, 10), (2, 4),
	-- FreelancerID 3 (TaiKhoanID=11): AI Engineer - Python, Machine Learning, Data Analytics
	(3, 36), (3, 37), (3, 38),
	-- FreelancerID 4 (TaiKhoanID=12): Content Writer - SEO, Content Writing, Social Media
	(4, 23), (4, 26), (4, 25),
	-- FreelancerID 5 (TaiKhoanID=13): Fullstack Engineer - NestJS, PostgreSQL, React, TypeScript, Docker
	(5, 1), (5, 2), (5, 11), (5, 14), (5, 6),
	-- FreelancerID 6 (TaiKhoanID=14): Frontend Engineer - Vue.js, React, TypeScript, TailwindCSS
	(6, 13), (6, 11), (6, 14), (6, 15),
	-- FreelancerID 7 (TaiKhoanID=15): UX Researcher - UI/UX Design, Wireframing, Prototyping, Figma
	(7, 20), (7, 21), (7, 22), (7, 19),
	-- FreelancerID 8 (TaiKhoanID=16): Security Engineer - Pentest, OWASP, Testing, Linux
	(8, 32), (8, 33), (8, 31), (8, 30),
	-- FreelancerID 9 (TaiKhoanID=17): Video Editor - Content Writing, Social Media
	(9, 26), (9, 25),
	-- FreelancerID 10 (TaiKhoanID=18): SEO Specialist - SEO, Content Writing, Google Ads
	(10, 23), (10, 26), (10, 24),
	-- FreelancerID 11 (TaiKhoanID=19): Illustrator - Logo Design, Brand Identity, Figma
	(11, 34), (11, 35), (11, 19),
	-- FreelancerID 12 (TaiKhoanID=20): Game Designer - TypeScript, Docker, CI/CD
	(12, 14), (12, 6), (12, 27)
ON CONFLICT DO NOTHING;


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
