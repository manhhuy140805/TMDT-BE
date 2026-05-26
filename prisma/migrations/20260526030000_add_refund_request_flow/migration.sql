-- Refund requests are reviewed by the freelancer before a dispute exists.
CREATE TYPE "TrangThaiYeuCauHoanTien" AS ENUM ('ChoFreelancerDuyet', 'DaDongY', 'DaTuChoi');

CREATE TABLE "YeuCauHoanTien" (
    "YeuCauHoanTienID" SERIAL NOT NULL,
    "CongViecID" INTEGER NOT NULL,
    "NguoiThueID" INTEGER NOT NULL,
    "FreelancerID" INTEGER NOT NULL,
    "LyDo" VARCHAR(255) NOT NULL,
    "MoTa" TEXT,
    "TrangThai" "TrangThaiYeuCauHoanTien" NOT NULL DEFAULT 'ChoFreelancerDuyet',
    "TongEscrow" DECIMAL(15,2) NOT NULL,
    "PhiHeThong" DECIMAL(15,2) NOT NULL,
    "TienFreelancer" DECIMAL(15,2) NOT NULL,
    "TienGiamSat" DECIMAL(15,2) NOT NULL,
    "TienHoan" DECIMAL(15,2) NOT NULL,
    "TranhChapID" INTEGER,
    "NgayTao" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "NgayPhanHoi" TIMESTAMP(3),
    CONSTRAINT "YeuCauHoanTien_pkey" PRIMARY KEY ("YeuCauHoanTienID")
);

CREATE UNIQUE INDEX "YeuCauHoanTien_TranhChapID_key" ON "YeuCauHoanTien"("TranhChapID");
CREATE INDEX "YeuCauHoanTien_CongViecID_idx" ON "YeuCauHoanTien"("CongViecID");
CREATE INDEX "YeuCauHoanTien_NguoiThueID_idx" ON "YeuCauHoanTien"("NguoiThueID");
CREATE INDEX "YeuCauHoanTien_FreelancerID_idx" ON "YeuCauHoanTien"("FreelancerID");
CREATE INDEX "YeuCauHoanTien_TrangThai_idx" ON "YeuCauHoanTien"("TrangThai");

ALTER TABLE "YeuCauHoanTien"
    ADD CONSTRAINT "YeuCauHoanTien_CongViecID_fkey"
    FOREIGN KEY ("CongViecID") REFERENCES "CongViec"("CongViecID")
    ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "YeuCauHoanTien"
    ADD CONSTRAINT "YeuCauHoanTien_NguoiThueID_fkey"
    FOREIGN KEY ("NguoiThueID") REFERENCES "TaiKhoan"("TaiKhoanID")
    ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "YeuCauHoanTien"
    ADD CONSTRAINT "YeuCauHoanTien_FreelancerID_fkey"
    FOREIGN KEY ("FreelancerID") REFERENCES "TaiKhoan"("TaiKhoanID")
    ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "YeuCauHoanTien"
    ADD CONSTRAINT "YeuCauHoanTien_TranhChapID_fkey"
    FOREIGN KEY ("TranhChapID") REFERENCES "TranhChap"("TranhChapID")
    ON DELETE SET NULL ON UPDATE CASCADE;

-- A complaint opened manually still comes after completion in the service.
-- A rejected refund request can put active work into TranhChap before inserting
-- its automatically generated dispute.
CREATE OR REPLACE FUNCTION "kiem_tra_tranh_chap_ket_qua_hoan_thanh"()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    trang_thai_cong_viec "TrangThaiCongViec";
    nguoi_thue_id INTEGER;
    giam_sat_id INTEGER;
BEGIN
    SELECT "TrangThai", "NguoiThueID", "GiamSatID"
      INTO trang_thai_cong_viec, nguoi_thue_id, giam_sat_id
      FROM "CongViec"
     WHERE "CongViecID" = NEW."CongViecID";

    IF trang_thai_cong_viec NOT IN ('HoanThanh', 'TranhChap') THEN
        RAISE EXCEPTION 'Chi co the mo tranh chap sau hoan thanh hoac khi tu choi hoan tien';
    END IF;

    IF NEW."NguoiGuiID" IS DISTINCT FROM nguoi_thue_id THEN
        RAISE EXCEPTION 'Chi khach hang moi co the mo tranh chap ve ket qua cong viec';
    END IF;

    IF NEW."GiamSatID" IS DISTINCT FROM giam_sat_id THEN
        RAISE EXCEPTION 'Tranh chap phai do don vi giam sat cua cong viec xu ly';
    END IF;

    RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION "giu_cong_viec_hoan_thanh_khi_co_tranh_chap"()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW."TrangThai" NOT IN ('HoanThanh', 'TranhChap')
       AND EXISTS (
           SELECT 1
           FROM "TranhChap"
           WHERE "CongViecID" = NEW."CongViecID"
       ) THEN
        RAISE EXCEPTION 'Cong viec co tranh chap phai giu trang thai hoan thanh hoac tranh chap';
    END IF;

    RETURN NEW;
END;
$$;
