-- Supervisor approval now happens on YeuCau before proposals/contracts proceed.
ALTER TABLE "YeuCau"
    ADD COLUMN "TrangThaiGiamSat" "TrangThaiYeuCauGiamSat" NOT NULL DEFAULT 'ChoDuyet',
    ADD COLUMN "LyDoTuChoiGiamSat" TEXT,
    ADD COLUMN "NgayGiamSatChapNhan" TIMESTAMP(3);

-- Preserve approved supervision for requests that already produced active work.
UPDATE "YeuCau" AS yc
   SET "TrangThaiGiamSat" = CASE
           WHEN cv."TrangThaiGiamSat" IN ('DangGiamSat', 'HoanThanh')
               THEN 'DaChapNhan'::"TrangThaiYeuCauGiamSat"
           WHEN cv."TrangThaiGiamSat" = 'TuChoi'
               THEN 'TuChoi'::"TrangThaiYeuCauGiamSat"
           ELSE yc."TrangThaiGiamSat"
       END,
       "NgayGiamSatChapNhan" = CASE
           WHEN cv."TrangThaiGiamSat" IN ('DangGiamSat', 'HoanThanh')
               THEN cv."NgayTao"
           ELSE yc."NgayGiamSatChapNhan"
       END
  FROM "CongViec" AS cv
 WHERE cv."YeuCauID" = yc."YeuCauID";
