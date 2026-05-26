-- A dispute is a customer's complaint about the result of completed work.
CREATE TEMP TABLE "_TranhChapKhongHopLe" AS
SELECT tc."TranhChapID"
FROM "TranhChap" AS tc
JOIN "CongViec" AS cv ON cv."CongViecID" = tc."CongViecID"
WHERE tc."NguoiGuiID" <> cv."NguoiThueID"
   OR cv."TrangThai" NOT IN ('HoanThanh', 'TranhChap');

DELETE FROM "BangChungTranhChap"
WHERE "TranhChapID" IN (SELECT "TranhChapID" FROM "_TranhChapKhongHopLe");

DELETE FROM "KetLuanTranhChap"
WHERE "TranhChapID" IN (SELECT "TranhChapID" FROM "_TranhChapKhongHopLe");

DELETE FROM "TranhChap"
WHERE "TranhChapID" IN (SELECT "TranhChapID" FROM "_TranhChapKhongHopLe");

DROP TABLE "_TranhChapKhongHopLe";

-- Legacy code used this contract status while a complaint was being handled.
-- Completed work now remains completed while TranhChap tracks the complaint.
UPDATE "CongViec" AS cv
SET "TrangThai" = 'HoanThanh',
    "NgayKetThuc" = COALESCE(cv."NgayKetThuc", CURRENT_TIMESTAMP)
WHERE cv."TrangThai" = 'TranhChap'
  AND EXISTS (
      SELECT 1
      FROM "TranhChap" AS tc
      WHERE tc."CongViecID" = cv."CongViecID"
        AND tc."NguoiGuiID" = cv."NguoiThueID"
  );

UPDATE "TranhChap" AS tc
SET "GiamSatID" = cv."GiamSatID"
FROM "CongViec" AS cv
WHERE cv."CongViecID" = tc."CongViecID"
  AND tc."GiamSatID" IS DISTINCT FROM cv."GiamSatID";

ALTER TABLE "TranhChap"
    ALTER COLUMN "GiamSatID" SET NOT NULL;

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

    IF trang_thai_cong_viec IS DISTINCT FROM 'HoanThanh' THEN
        RAISE EXCEPTION 'Chi co the tranh chap sau khi cong viec da hoan thanh';
    END IF;

    IF NEW."NguoiGuiID" IS DISTINCT FROM nguoi_thue_id THEN
        RAISE EXCEPTION 'Chi khach hang moi co the mo tranh chap ve ket qua cong viec';
    END IF;

    IF NEW."GiamSatID" IS NULL THEN
        NEW."GiamSatID" := giam_sat_id;
    ELSIF NEW."GiamSatID" IS DISTINCT FROM giam_sat_id THEN
        RAISE EXCEPTION 'Tranh chap phai do don vi giam sat cua cong viec xu ly';
    END IF;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS "tranh_chap_chi_sau_hoan_thanh" ON "TranhChap";

CREATE TRIGGER "tranh_chap_chi_sau_hoan_thanh"
BEFORE INSERT OR UPDATE OF "CongViecID", "NguoiGuiID", "GiamSatID"
ON "TranhChap"
FOR EACH ROW
EXECUTE FUNCTION "kiem_tra_tranh_chap_ket_qua_hoan_thanh"();

CREATE OR REPLACE FUNCTION "giu_cong_viec_hoan_thanh_khi_co_tranh_chap"()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW."TrangThai" <> 'HoanThanh'
       AND EXISTS (
           SELECT 1
           FROM "TranhChap"
           WHERE "CongViecID" = NEW."CongViecID"
       ) THEN
        RAISE EXCEPTION 'Cong viec da co tranh chap ket qua phai giu trang thai hoan thanh';
    END IF;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS "cong_viec_co_tranh_chap_phai_hoan_thanh" ON "CongViec";

CREATE TRIGGER "cong_viec_co_tranh_chap_phai_hoan_thanh"
BEFORE UPDATE OF "TrangThai"
ON "CongViec"
FOR EACH ROW
EXECUTE FUNCTION "giu_cong_viec_hoan_thanh_khi_co_tranh_chap"();
