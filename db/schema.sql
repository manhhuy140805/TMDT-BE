-- ============================================================
-- Freelance Reverse Auction System - Database Schema v2.0
-- Cập nhật: Thêm tác nhân Đơn Vị Giám Sát (Supervisor)
-- ============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ------------------------------------------------------------
-- 1. LOAI_DICH_VU
-- ------------------------------------------------------------
CREATE TABLE LoaiDichVu (
    LoaiDichVuID    INT             NOT NULL AUTO_INCREMENT,
    TenLoai         VARCHAR(100)    NOT NULL,
    MoTa            VARCHAR(255)    NULL,
    HinhAnh         VARCHAR(255)    NULL,
    PRIMARY KEY (LoaiDichVuID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Danh mục loại dịch vụ';

-- ------------------------------------------------------------
-- 2. TAI_KHOAN  (core – tất cả vai trò dùng chung)
-- ------------------------------------------------------------
CREATE TABLE TaiKhoan (
    TaiKhoanID      INT             NOT NULL AUTO_INCREMENT,
    TenDangNhap     VARCHAR(50)     NOT NULL,
    MatKhau         VARCHAR(255)    NOT NULL,
    Email           VARCHAR(100)    NOT NULL,
    HoTen           VARCHAR(100)    NOT NULL,
    SoDienThoai     VARCHAR(15)     NULL,
    GioiTinh        ENUM('Nam','Nu','Khac') NULL,
    DiaChi          VARCHAR(255)    NULL,
    -- VaiTro phân biệt 5 loại tác nhân trong hệ thống
    VaiTro          ENUM('KhachVangLai','NguoiThue','Freelancer',
                         'DonViGiamSat','Admin') NOT NULL DEFAULT 'KhachVangLai',
    TrangThai       ENUM('HoatDong','BiKhoa','ChoDuyet','DaBi') 
                    NOT NULL DEFAULT 'HoatDong',
    NgayTao         DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    NgayCapNhat     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP 
                    ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (TaiKhoanID),
    UNIQUE KEY uq_email (Email),
    UNIQUE KEY uq_tendangnhap (TenDangNhap)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Tài khoản tất cả người dùng';

-- ------------------------------------------------------------
-- 3. NGUOI_THUE
-- ------------------------------------------------------------
CREATE TABLE NguoiThue (
    NguoiThueID     INT             NOT NULL AUTO_INCREMENT,
    TaiKhoanID      INT             NOT NULL,
    CongTy          VARCHAR(150)    NULL,
    MoTa            TEXT            NULL,
    DiemTinCay      DECIMAL(3,2)    NOT NULL DEFAULT 0.00,
    TongYeuCau      INT             NOT NULL DEFAULT 0,
    TyLeHoanThanh   DECIMAL(5,2)    NOT NULL DEFAULT 0.00
                    COMMENT 'Tỉ lệ % công việc hoàn thành',
    PRIMARY KEY (NguoiThueID),
    CONSTRAINT fk_nt_taikhoan FOREIGN KEY (TaiKhoanID)
        REFERENCES TaiKhoan (TaiKhoanID) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Hồ sơ người thuê';

-- ------------------------------------------------------------
-- 4. FREELANCER
-- ------------------------------------------------------------
CREATE TABLE Freelancer (
    FreelancerID    INT             NOT NULL AUTO_INCREMENT,
    TaiKhoanID      INT             NOT NULL,
    KinhNghiem      INT             NOT NULL DEFAULT 0 COMMENT 'Số năm kinh nghiệm',
    ChuyenGia       VARCHAR(150)    NULL,
    KyNang          TEXT            NULL COMMENT 'JSON array các kỹ năng',
    XepHang         DECIMAL(3,2)    NOT NULL DEFAULT 0.00,
    SoDu            DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
    XacThucEmail    TINYINT(1)      NOT NULL DEFAULT 0,
    XacThucSDT      TINYINT(1)      NOT NULL DEFAULT 0,
    TongCongViec    INT             NOT NULL DEFAULT 0,
    TyLeHoanThanh   DECIMAL(5,2)    NOT NULL DEFAULT 0.00,
    PRIMARY KEY (FreelancerID),
    CONSTRAINT fk_fl_taikhoan FOREIGN KEY (TaiKhoanID)
        REFERENCES TaiKhoan (TaiKhoanID) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Hồ sơ freelancer';

-- ------------------------------------------------------------
-- 5. DON_VI_GIAM_SAT  [MỚI - UC-30, UC-31]
-- ------------------------------------------------------------
CREATE TABLE DonViGiamSat (
    GiamSatID       INT             NOT NULL AUTO_INCREMENT,
    TaiKhoanID      INT             NOT NULL,
    TenDonVi        VARCHAR(150)    NOT NULL,
    MoTa            TEXT            NULL,
    NangLuc         TEXT            NULL  COMMENT 'Mô tả năng lực chuyên môn',
    ChungChi        VARCHAR(255)    NULL  COMMENT 'Danh sách chứng chỉ',
    PhiGiamSat      DECIMAL(15,2)   NOT NULL DEFAULT 0.00
                    COMMENT 'Phí dịch vụ giám sát mặc định',
    XepHang         DECIMAL(3,2)    NOT NULL DEFAULT 0.00,
    TongCongViecGS  INT             NOT NULL DEFAULT 0
                    COMMENT 'Tổng số công việc đã giám sát',
    TrangThai       ENUM('HoatDong','TamNghi','BiKhoa','ChoDuyet')
                    NOT NULL DEFAULT 'ChoDuyet',
    NgayDangKy      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (GiamSatID),
    CONSTRAINT fk_dvgs_taikhoan FOREIGN KEY (TaiKhoanID)
        REFERENCES TaiKhoan (TaiKhoanID) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Đơn vị giám sát (Supervisor)';

-- ------------------------------------------------------------
-- 6. YEU_CAU
-- ------------------------------------------------------------
CREATE TABLE YeuCau (
    YeuCauID        INT             NOT NULL AUTO_INCREMENT,
    NguoiThueID     INT             NOT NULL,
    LoaiDichVuID    INT             NOT NULL,
    GiamSatID       INT             NOT NULL,
    TieuDe          VARCHAR(200)    NOT NULL,
    MoTa            TEXT            NOT NULL,
    NganSachMin     DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
    NganSachMax     DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
    ThoiHan         DATE            NOT NULL,
    TrangThai       ENUM('DangNhanHoSo','DaDong','DaChot','DaHuy')
                    NOT NULL DEFAULT 'DangNhanHoSo',
    SoLuongBaoGia   INT             NOT NULL DEFAULT 0,
    YeuCauGiamSat   TINYINT(1)      NOT NULL DEFAULT 1
                    COMMENT 'Luôn TRUE vì mọi yêu cầu đều có đơn vị giám sát',
    NgayTao         DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    NgayCapNhat     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP
                    ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (YeuCauID),
    CONSTRAINT fk_yc_nguoithue FOREIGN KEY (NguoiThueID)
        REFERENCES NguoiThue (NguoiThueID),
    CONSTRAINT fk_yc_loaidichvu FOREIGN KEY (LoaiDichVuID)
        REFERENCES LoaiDichVu (LoaiDichVuID),
    CONSTRAINT fk_yc_giamsat FOREIGN KEY (GiamSatID)
        REFERENCES DonViGiamSat (GiamSatID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Yêu cầu thuê dịch vụ';

-- ------------------------------------------------------------
-- 7. BAO_GIA
-- ------------------------------------------------------------
CREATE TABLE BaoGia (
    BaoGiaID            INT             NOT NULL AUTO_INCREMENT,
    YeuCauID            INT             NOT NULL,
    FreelancerID        INT             NOT NULL,
    GiaDeXuat           DECIMAL(15,2)   NOT NULL,
    ThoiGianThucHien    INT             NOT NULL COMMENT 'Số ngày',
    NoiDung             TEXT            NULL,
    TrangThai           ENUM('DaGui','DuocChon','TuChoi','HetHan')
                        NOT NULL DEFAULT 'DaGui',
    NgayTao             DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    NgayCapNhat         DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP
                        ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (BaoGiaID),
    CONSTRAINT fk_bg_yeucau    FOREIGN KEY (YeuCauID)
        REFERENCES YeuCau (YeuCauID),
    CONSTRAINT fk_bg_freelancer FOREIGN KEY (FreelancerID)
        REFERENCES Freelancer (FreelancerID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Báo giá từ freelancer';

-- ------------------------------------------------------------
-- 8. CONG_VIEC
-- ------------------------------------------------------------
CREATE TABLE CongViec (
    CongViecID          INT             NOT NULL AUTO_INCREMENT,
    YeuCauID            INT             NOT NULL,
    FreelancerID        INT             NOT NULL,
    NguoiThueID         INT             NOT NULL,
    GiaThoa             DECIMAL(15,2)   NOT NULL,
    ThoiGianThoa        INT             NOT NULL COMMENT 'Số ngày thỏa thuận',
    TrangThai           ENUM('MoiTao','DangThucHien','HoanThanh',
                             'DaHuy','TranhChap') NOT NULL DEFAULT 'MoiTao',
    NgayBatDau          DATETIME        NULL,
    NgayKetThuc         DATETIME        NULL,
    -- Trường mới liên quan Supervisor
    GiamSatID           INT             NOT NULL
                        COMMENT 'Đơn vị giám sát bắt buộc cho công việc',
    TrangThaiGiamSat    ENUM('KhongCo','ChoDuyet','DangGiamSat',
                             'HoanThanh','TuChoi') NOT NULL DEFAULT 'ChoDuyet',
    PhiGiamSat          DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
    NgayTao             DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (CongViecID),
    CONSTRAINT fk_cv_yeucau     FOREIGN KEY (YeuCauID)
        REFERENCES YeuCau (YeuCauID),
    CONSTRAINT fk_cv_freelancer FOREIGN KEY (FreelancerID)
        REFERENCES Freelancer (FreelancerID),
    CONSTRAINT fk_cv_nguoithue  FOREIGN KEY (NguoiThueID)
        REFERENCES NguoiThue (NguoiThueID),
    CONSTRAINT fk_cv_giamsat    FOREIGN KEY (GiamSatID)
        REFERENCES DonViGiamSat (GiamSatID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Công việc đã ký kết';

-- ------------------------------------------------------------
-- 9. YEU_CAU_GIAM_SAT  [MỚI - UC-32, UC-41, UC-43]
-- ------------------------------------------------------------
CREATE TABLE YeuCauGiamSat (
    YCGiamSatID         INT             NOT NULL AUTO_INCREMENT,
    CongViecID          INT             NOT NULL,
    NguoiThueID         INT             NOT NULL,
    GiamSatID           INT             NOT NULL,
    FreelancerID        INT             NOT NULL,
    TrangThai           ENUM('ChoDuyet','DaChapNhan','TuChoi','HoanThanh')
                        NOT NULL DEFAULT 'ChoDuyet',
    LyDoTuChoi          TEXT            NULL,
    PhiGiamSatThoa      DECIMAL(15,2)   NOT NULL DEFAULT 0.00
                        COMMENT 'Phí đã thỏa thuận cho lần giám sát này',
    NgayYeuCau          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    NgayChapNhan        DATETIME        NULL,
    NgayHoanThanh       DATETIME        NULL,
    PRIMARY KEY (YCGiamSatID),
    CONSTRAINT fk_ycgs_congviec   FOREIGN KEY (CongViecID)
        REFERENCES CongViec (CongViecID),
    CONSTRAINT fk_ycgs_nguoithue  FOREIGN KEY (NguoiThueID)
        REFERENCES NguoiThue (NguoiThueID),
    CONSTRAINT fk_ycgs_giamsat    FOREIGN KEY (GiamSatID)
        REFERENCES DonViGiamSat (GiamSatID),
    CONSTRAINT fk_ycgs_freelancer FOREIGN KEY (FreelancerID)
        REFERENCES Freelancer (FreelancerID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Yêu cầu & chấp thuận giám sát';

-- ------------------------------------------------------------
-- 10. TIEN_DO
-- ------------------------------------------------------------
CREATE TABLE TienDo (
    TienDoID            INT             NOT NULL AUTO_INCREMENT,
    CongViecID          INT             NOT NULL,
    FreelancerID        INT             NOT NULL,
    TieuDe              VARCHAR(200)    NOT NULL,
    MoTa                TEXT            NULL,
    PhanTram            TINYINT         NOT NULL DEFAULT 0
                        COMMENT 'Tiến độ 0–100%',
    TepDinhKem          VARCHAR(500)    NULL,
    -- Trường mới: Supervisor xác nhận tiến độ (UC-33, UC-34, UC-38)
    XacNhanBoi          INT             NULL
                        COMMENT 'GiamSatID nếu supervisor xác nhận',
    TrangThaiXacNhan    ENUM('ChuaXacNhan','DaXacNhan','TuChoi')
                        NOT NULL DEFAULT 'ChuaXacNhan',
    NgayTao             DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (TienDoID),
    CONSTRAINT fk_td_congviec   FOREIGN KEY (CongViecID)
        REFERENCES CongViec (CongViecID),
    CONSTRAINT fk_td_freelancer FOREIGN KEY (FreelancerID)
        REFERENCES Freelancer (FreelancerID),
    CONSTRAINT fk_td_xacnhanboi FOREIGN KEY (XacNhanBoi)
        REFERENCES DonViGiamSat (GiamSatID) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Cập nhật tiến độ công việc';

-- ------------------------------------------------------------
-- 11. TRANH_CHAP  [Chi mo sau khi cong viec hoan thanh]
-- ------------------------------------------------------------
CREATE TABLE TranhChap (
    TranhChapID         INT             NOT NULL AUTO_INCREMENT,
    CongViecID          INT             NOT NULL,
    NguoiGuiID          INT             NOT NULL COMMENT 'TaiKhoanID khach hang khong hai long ket qua',
    GiamSatID           INT             NOT NULL COMMENT 'Don vi giam sat cua cong viec xu ly',
    LyDo                VARCHAR(255)    NOT NULL,
    MoTa                TEXT            NULL,
    TrangThai           ENUM('MoiMo','DangXuLy','DaKetLuan','DaDong')
                        NOT NULL DEFAULT 'MoiMo',
    YeuCauHoanTien      DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
    NgayMo              DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    NgayDong            DATETIME        NULL,
    PRIMARY KEY (TranhChapID),
    CONSTRAINT fk_tc_congviec FOREIGN KEY (CongViecID)
        REFERENCES CongViec (CongViecID),
    CONSTRAINT fk_tc_nguoigui FOREIGN KEY (NguoiGuiID)
        REFERENCES TaiKhoan (TaiKhoanID),
    CONSTRAINT fk_tc_giamsat  FOREIGN KEY (GiamSatID)
        REFERENCES DonViGiamSat (GiamSatID) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Khieu nai ket qua sau khi cong viec hoan thanh';

-- ------------------------------------------------------------
-- 12. BANG_CHUNG_TRANH_CHAP  [MỚI - UC-36]
-- ------------------------------------------------------------
CREATE TABLE BangChungTranhChap (
    BangChungID         INT             NOT NULL AUTO_INCREMENT,
    TranhChapID         INT             NOT NULL,
    NguoiNopID          INT             NOT NULL COMMENT 'TaiKhoanID người nộp bằng chứng',
    GiamSatID           INT             NULL     COMMENT 'Supervisor thu thập',
    LoaiBangChung       ENUM('TinNhan','File','HinhAnh','GhiChu','KhacP')
                        NOT NULL DEFAULT 'GhiChu',
    NoiDung             TEXT            NULL,
    DuongDanFile        VARCHAR(500)    NULL,
    NgayNop             DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (BangChungID),
    CONSTRAINT fk_bctc_tranhchap FOREIGN KEY (TranhChapID)
        REFERENCES TranhChap (TranhChapID),
    CONSTRAINT fk_bctc_nguoinop  FOREIGN KEY (NguoiNopID)
        REFERENCES TaiKhoan (TaiKhoanID),
    CONSTRAINT fk_bctc_giamsat   FOREIGN KEY (GiamSatID)
        REFERENCES DonViGiamSat (GiamSatID) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Bằng chứng trong tranh chấp';

-- ------------------------------------------------------------
-- 13. KET_LUAN_TRANH_CHAP  [MỚI - UC-37]
-- ------------------------------------------------------------
CREATE TABLE KetLuanTranhChap (
    KetLuanID           INT             NOT NULL AUTO_INCREMENT,
    TranhChapID         INT             NOT NULL,
    GiamSatID           INT             NOT NULL,
    KetQua              ENUM('TiepTuc','HoanTienNguoiThue',
                             'HuyHopDong','PhanChia') NOT NULL,
    LyDo                TEXT            NOT NULL,
    SoTienHoan          DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
    BenChiuPhi          ENUM('NguoiThue','Freelancer','ChiaSe','HeThong')
                        NOT NULL DEFAULT 'ChiaSe',
    NgayKetLuan         DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (KetLuanID),
    UNIQUE KEY uq_tranhchap (TranhChapID),
    CONSTRAINT fk_kltc_tranhchap FOREIGN KEY (TranhChapID)
        REFERENCES TranhChap (TranhChapID),
    CONSTRAINT fk_kltc_giamsat   FOREIGN KEY (GiamSatID)
        REFERENCES DonViGiamSat (GiamSatID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Kết luận tranh chấp do Supervisor đưa ra';

-- ------------------------------------------------------------
-- 14. THANH_TOAN
-- ------------------------------------------------------------
CREATE TABLE ThanhToan (
    ThanhToanID         INT             NOT NULL AUTO_INCREMENT,
    CongViecID          INT             NOT NULL,
    NguoiThueID         INT             NOT NULL,
    SoTien              DECIMAL(15,2)   NOT NULL,
    LoaiTT              ENUM('DatCoc','ThanhToanCuoi','HoanTien',
                             'PhiGiamSat','PhiHeThong') NOT NULL,
    PhuongThuc          ENUM('ChuyenKhoan','ThanhToanQuaMang',
                             'Vi','TienMat') NOT NULL DEFAULT 'Vi',
    TrangThai           ENUM('ChoXuLy','ThanhCong','ThatBai','DaHoan')
                        NOT NULL DEFAULT 'ChoXuLy',
    -- Trường mới: thanh toán phí giám sát (UC-39)
    GiamSatID           INT             NULL
                        COMMENT 'Điền khi LoaiTT = PhiGiamSat',
    PhiGiamSatTT        DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
    GhiChu              VARCHAR(255)    NULL,
    NgayTao             DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (ThanhToanID),
    CONSTRAINT fk_tt_congviec  FOREIGN KEY (CongViecID)
        REFERENCES CongViec (CongViecID),
    CONSTRAINT fk_tt_nguoithue FOREIGN KEY (NguoiThueID)
        REFERENCES NguoiThue (NguoiThueID),
    CONSTRAINT fk_tt_giamsat   FOREIGN KEY (GiamSatID)
        REFERENCES DonViGiamSat (GiamSatID) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Giao dịch thanh toán';

-- ------------------------------------------------------------
-- 15. CUOC_HOI_THOAI
-- ------------------------------------------------------------
CREATE TABLE CuocHoiThoai (
    CuocHoiThoaiID      INT             NOT NULL AUTO_INCREMENT,
    CongViecID          INT             NULL,
    ThanhVien1ID        INT             NOT NULL COMMENT 'TaiKhoanID',
    ThanhVien2ID        INT             NOT NULL COMMENT 'TaiKhoanID',
    -- Trường mới: Supervisor tham gia hội thoại (UC-25)
    GiamSatID           INT             NULL,
    TinNhanCuoi         DATETIME        NULL,
    TrangThai           ENUM('DangMo','DaDong') NOT NULL DEFAULT 'DangMo',
    NgayTao             DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (CuocHoiThoaiID),
    CONSTRAINT fk_cht_congviec   FOREIGN KEY (CongViecID)
        REFERENCES CongViec (CongViecID) ON DELETE SET NULL,
    CONSTRAINT fk_cht_thanhvien1 FOREIGN KEY (ThanhVien1ID)
        REFERENCES TaiKhoan (TaiKhoanID),
    CONSTRAINT fk_cht_thanhvien2 FOREIGN KEY (ThanhVien2ID)
        REFERENCES TaiKhoan (TaiKhoanID),
    CONSTRAINT fk_cht_giamsat    FOREIGN KEY (GiamSatID)
        REFERENCES DonViGiamSat (GiamSatID) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Cuộc hội thoại tin nhắn';

-- ------------------------------------------------------------
-- 16. TIN_NHAN
-- ------------------------------------------------------------
CREATE TABLE TinNhan (
    TinNhanID           INT             NOT NULL AUTO_INCREMENT,
    CuocHoiThoaiID      INT             NOT NULL,
    NguoiGuiID          INT             NOT NULL COMMENT 'TaiKhoanID',
    NoiDung             TEXT            NOT NULL,
    LoaiTin             ENUM('VanBan','File','HinhAnh') NOT NULL DEFAULT 'VanBan',
    DaDoc               TINYINT(1)      NOT NULL DEFAULT 0,
    NgayTao             DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (TinNhanID),
    CONSTRAINT fk_tn_cuochoithoai FOREIGN KEY (CuocHoiThoaiID)
        REFERENCES CuocHoiThoai (CuocHoiThoaiID),
    CONSTRAINT fk_tn_nguoigui     FOREIGN KEY (NguoiGuiID)
        REFERENCES TaiKhoan (TaiKhoanID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Tin nhắn trong hội thoại';

-- ------------------------------------------------------------
-- 17. DANH_GIA
-- ------------------------------------------------------------
CREATE TABLE DanhGia (
    DanhGiaID           INT             NOT NULL AUTO_INCREMENT,
    CongViecID          INT             NOT NULL,
    NguoiDanhGiaID      INT             NOT NULL COMMENT 'TaiKhoanID',
    NguoiDuocDGID       INT             NOT NULL COMMENT 'TaiKhoanID',
    DiemSo              TINYINT         NOT NULL CHECK (DiemSo BETWEEN 1 AND 5),
    BinhLuan            TEXT            NULL,
    -- LoaiDanhGia mở rộng cho Supervisor (UC-42, UC-44, UC-45, UC-46)
    LoaiDanhGia         ENUM('NguoiThue_DanhGia_Freelancer',
                             'Freelancer_DanhGia_NguoiThue',
                             'NguoiThue_DanhGia_GiamSat',
                             'Freelancer_DanhGia_GiamSat',
                             'GiamSat_DanhGia_Freelancer',
                             'GiamSat_DanhGia_NguoiThue') NOT NULL,
    -- Trường mới: đánh giá liên quan đến Supervisor
    GiamSatID           INT             NULL,
    NgayTao             DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (DanhGiaID),
    CONSTRAINT fk_dg_congviec    FOREIGN KEY (CongViecID)
        REFERENCES CongViec (CongViecID),
    CONSTRAINT fk_dg_nguoidanhgia FOREIGN KEY (NguoiDanhGiaID)
        REFERENCES TaiKhoan (TaiKhoanID),
    CONSTRAINT fk_dg_nguoiduocdg FOREIGN KEY (NguoiDuocDGID)
        REFERENCES TaiKhoan (TaiKhoanID),
    CONSTRAINT fk_dg_giamsat     FOREIGN KEY (GiamSatID)
        REFERENCES DonViGiamSat (GiamSatID) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Đánh giá sau công việc';

-- ------------------------------------------------------------
-- 18. THONG_BAO
-- ------------------------------------------------------------
CREATE TABLE ThongBao (
    ThongBaoID          INT             NOT NULL AUTO_INCREMENT,
    TaiKhoanID          INT             NOT NULL,
    TieuDe              VARCHAR(200)    NOT NULL,
    NoiDung             TEXT            NULL,
    LoaiThongBao        ENUM('HeThong','YeuCau','BaoGia','CongViec',
                             'TranhChap','GiamSat','ThanhToan','DanhGia')
                        NOT NULL DEFAULT 'HeThong',
    DaDoc               TINYINT(1)      NOT NULL DEFAULT 0,
    -- Trường mới: thông báo liên quan Supervisor
    GiamSatID           INT             NULL,
    NgayTao             DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (ThongBaoID),
    CONSTRAINT fk_tb_taikhoan FOREIGN KEY (TaiKhoanID)
        REFERENCES TaiKhoan (TaiKhoanID),
    CONSTRAINT fk_tb_giamsat  FOREIGN KEY (GiamSatID)
        REFERENCES DonViGiamSat (GiamSatID) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Thông báo hệ thống';

-- ------------------------------------------------------------
-- 19. BAO_CAO
-- ------------------------------------------------------------
CREATE TABLE BaoCao (
    BaoCaoID            INT             NOT NULL AUTO_INCREMENT,
    NguoiBaoCaoID       INT             NOT NULL COMMENT 'TaiKhoanID',
    NguoiBiCaoID        INT             NOT NULL COMMENT 'TaiKhoanID',
    LyDo                VARCHAR(255)    NOT NULL,
    MoTa                TEXT            NULL,
    TrangThai           ENUM('ChoXuLy','DangXuLy','DaXuLy','HuyBo')
                        NOT NULL DEFAULT 'ChoXuLy',
    KetQua              TEXT            NULL,
    AdminXuLyID         INT             NULL COMMENT 'TaiKhoanID admin',
    NgayTao             DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    NgayXuLy            DATETIME        NULL,
    PRIMARY KEY (BaoCaoID),
    CONSTRAINT fk_bc_nguoibaocao FOREIGN KEY (NguoiBaoCaoID)
        REFERENCES TaiKhoan (TaiKhoanID),
    CONSTRAINT fk_bc_nguoibicao  FOREIGN KEY (NguoiBiCaoID)
        REFERENCES TaiKhoan (TaiKhoanID),
    CONSTRAINT fk_bc_adminxuly   FOREIGN KEY (AdminXuLyID)
        REFERENCES TaiKhoan (TaiKhoanID) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Báo cáo vi phạm';

-- ------------------------------------------------------------
-- 20. KHUYEN_MAI
-- ------------------------------------------------------------
CREATE TABLE KhuyenMai (
    KhuyenMaiID         INT             NOT NULL AUTO_INCREMENT,
    MaCode              VARCHAR(50)     NOT NULL,
    LoaiGiam            ENUM('PhanTram','SoTienCo') NOT NULL,
    GiaTriGiam          DECIMAL(15,2)   NOT NULL,
    GiaTriToiDa         DECIMAL(15,2)   NULL,
    SoLuotDung          INT             NOT NULL DEFAULT 0,
    GioiHanLuot         INT             NULL,
    TrangThai           ENUM('HoatDong','HetHan','ThuHoi') 
                        NOT NULL DEFAULT 'HoatDong',
    NgayBatDau          DATETIME        NOT NULL,
    NgayKetThuc         DATETIME        NOT NULL,
    PRIMARY KEY (KhuyenMaiID),
    UNIQUE KEY uq_macode (MaCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Mã khuyến mãi';

-- ============================================================
-- INDEXES bổ sung để tăng hiệu năng truy vấn
-- ============================================================
CREATE INDEX idx_yeucau_nguoithue   ON YeuCau (NguoiThueID);
CREATE INDEX idx_yeucau_trangthai   ON YeuCau (TrangThai);
CREATE INDEX idx_baogía_yeucau      ON BaoGia (YeuCauID);
CREATE INDEX idx_congviec_trangthai ON CongViec (TrangThai);
CREATE INDEX idx_congviec_giamsat   ON CongViec (GiamSatID);
CREATE INDEX idx_tiendо_congviec    ON TienDo (CongViecID);
CREATE INDEX idx_tranhchap_cv       ON TranhChap (CongViecID);
CREATE INDEX idx_tranhchap_gs       ON TranhChap (GiamSatID);
CREATE INDEX idx_danhgia_loai       ON DanhGia (LoaiDanhGia);
CREATE INDEX idx_thongbao_taikhoan  ON ThongBao (TaiKhoanID, DaDoc);
CREATE INDEX idx_tinhan_cuoc        ON TinNhan (CuocHoiThoaiID);

-- ============================================================
-- DỮ LIỆU MẪU (seed data)
-- ============================================================

-- Loại dịch vụ
INSERT INTO LoaiDichVu (TenLoai, MoTa) VALUES
('Lập trình web', 'Frontend, Backend, Fullstack'),
('Thiết kế đồ họa', 'Logo, Banner, UI/UX'),
('Marketing', 'SEO, Social Media, Content'),
('Phân tích dữ liệu', 'Data Analysis, Machine Learning'),
('Biên dịch', 'Dịch thuật tài liệu đa ngôn ngữ');

-- Tài khoản mẫu
INSERT INTO TaiKhoan (TenDangNhap, MatKhau, Email, HoTen, VaiTro, TrangThai) VALUES
('admin01',    '$2b$10$xxx', 'admin@fras.vn',        'Quản Trị Viên',  'Admin',          'HoatDong'),
('client01',   '$2b$10$xxx', 'client01@gmail.com',   'Nguyễn Văn An',  'NguoiThue',      'HoatDong'),
('freelancer01','$2b$10$xxx','free01@gmail.com',      'Trần Thị Bình',  'Freelancer',     'HoatDong'),
('supervisor01','$2b$10$xxx','super01@company.vn',   'Công Ty Giám Sát ABC', 'DonViGiamSat','HoatDong');

-- Hồ sơ người thuê
INSERT INTO NguoiThue (TaiKhoanID, CongTy, MoTa) VALUES
(2, 'Startup ABC', 'Cần tuyển freelancer cho nhiều dự án web');

-- Hồ sơ freelancer
INSERT INTO Freelancer (TaiKhoanID, KinhNghiem, ChuyenGia, KyNang) VALUES
(3, 3, 'Lập trình web', '["React","NodeJS","MySQL"]');

-- Hồ sơ đơn vị giám sát
INSERT INTO DonViGiamSat (TaiKhoanID, TenDonVi, MoTa, PhiGiamSat, TrangThai) VALUES
(4, 'Công Ty Giám Sát ABC', 'Chuyên giám sát dự án công nghệ', 500000.00, 'HoatDong');

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- KẾT THÚC SCRIPT
-- Tổng: 20 bảng | 4 bảng mới | ~12 trường mới | 11 indexes
-- ============================================================
