-- Every YeuCau and CongViec must be assigned to an active supervisor account.
DO $$
DECLARE
    default_supervisor_id INTEGER;
BEGIN
    SELECT "TaiKhoanID"
      INTO default_supervisor_id
      FROM "DonViGiamSat"
     WHERE "TrangThai" = 'HoatDong'
     ORDER BY "GiamSatID"
     LIMIT 1;

    IF (
        EXISTS (SELECT 1 FROM "YeuCau" WHERE "GiamSatID" IS NULL)
        OR EXISTS (SELECT 1 FROM "CongViec" WHERE "GiamSatID" IS NULL)
        OR EXISTS (
            SELECT 1
              FROM "YeuCau" AS yc
             WHERE yc."TrangThai" IN ('DangNhanHoSo', 'DaDong')
               AND NOT EXISTS (
                   SELECT 1
                     FROM "DonViGiamSat" AS gs
                    WHERE gs."TaiKhoanID" = yc."GiamSatID"
                      AND gs."TrangThai" = 'HoatDong'
               )
        )
    ) AND default_supervisor_id IS NULL THEN
        RAISE EXCEPTION 'Cannot assign supervision: no active DonViGiamSat account exists';
    END IF;

    UPDATE "YeuCau"
       SET "GiamSatID" = default_supervisor_id
     WHERE "GiamSatID" IS NULL;

    UPDATE "YeuCau"
       SET "YeuCauGiamSat" = TRUE
     WHERE "YeuCauGiamSat" = FALSE;

    UPDATE "YeuCau" AS yc
       SET "GiamSatID" = default_supervisor_id
     WHERE yc."TrangThai" IN ('DangNhanHoSo', 'DaDong')
       AND NOT EXISTS (
           SELECT 1
             FROM "DonViGiamSat" AS gs
            WHERE gs."TaiKhoanID" = yc."GiamSatID"
              AND gs."TrangThai" = 'HoatDong'
       );

    UPDATE "CongViec" AS cv
       SET "GiamSatID" = yc."GiamSatID",
           "TrangThaiGiamSat" = CASE
               WHEN cv."TrangThaiGiamSat" = 'KhongCo'
                   THEN 'ChoDuyet'::"TrangThaiGiamSatCongViec"
               ELSE cv."TrangThaiGiamSat"
           END
      FROM "YeuCau" AS yc
     WHERE cv."YeuCauID" = yc."YeuCauID"
       AND cv."GiamSatID" IS NULL;
END $$;

ALTER TABLE "YeuCau"
    ALTER COLUMN "GiamSatID" SET NOT NULL,
    ALTER COLUMN "YeuCauGiamSat" SET DEFAULT TRUE;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
          FROM pg_constraint
         WHERE conname = 'YeuCau_bat_buoc_giam_sat_check'
           AND conrelid = '"YeuCau"'::regclass
    ) THEN
        ALTER TABLE "YeuCau"
            ADD CONSTRAINT "YeuCau_bat_buoc_giam_sat_check"
            CHECK ("YeuCauGiamSat" = TRUE);
    END IF;
END $$;

ALTER TABLE "CongViec"
    ALTER COLUMN "GiamSatID" SET NOT NULL,
    ALTER COLUMN "TrangThaiGiamSat" SET DEFAULT 'ChoDuyet';

-- Backfill the supervision workflow entry needed by existing work records.
INSERT INTO "YeuCauGiamSat" (
    "CongViecID",
    "NguoiThueID",
    "GiamSatID",
    "FreelancerID",
    "TrangThai",
    "PhiGiamSatThoa",
    "NgayYeuCau"
)
SELECT
    cv."CongViecID",
    cv."NguoiThueID",
    cv."GiamSatID",
    cv."FreelancerID",
    CASE cv."TrangThaiGiamSat"
        WHEN 'DangGiamSat' THEN 'DaChapNhan'::"TrangThaiYeuCauGiamSat"
        WHEN 'HoanThanh' THEN 'HoanThanh'::"TrangThaiYeuCauGiamSat"
        WHEN 'TuChoi' THEN 'TuChoi'::"TrangThaiYeuCauGiamSat"
        ELSE 'ChoDuyet'::"TrangThaiYeuCauGiamSat"
    END,
    cv."PhiGiamSat",
    cv."NgayTao"
FROM "CongViec" AS cv
WHERE NOT EXISTS (
    SELECT 1
      FROM "YeuCauGiamSat" AS ycgs
     WHERE ycgs."CongViecID" = cv."CongViecID"
);
