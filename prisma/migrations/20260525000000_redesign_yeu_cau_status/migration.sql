-- YeuCau now tracks recruitment only; CongViec tracks execution/completion.
ALTER TYPE "TrangThaiYeuCau" RENAME TO "TrangThaiYeuCau_old";

CREATE TYPE "TrangThaiYeuCau" AS ENUM (
    'DangNhanHoSo',
    'DaDong',
    'DaChot',
    'DaHuy'
);

ALTER TABLE "YeuCau" ALTER COLUMN "TrangThai" DROP DEFAULT;

ALTER TABLE "YeuCau"
    ALTER COLUMN "TrangThai" TYPE "TrangThaiYeuCau"
    USING (
        CASE "TrangThai"::text
            WHEN 'MoDau' THEN 'DangNhanHoSo'
            WHEN 'DangMo' THEN 'DangNhanHoSo'
            WHEN 'HoanThanh' THEN 'DaChot'
            ELSE "TrangThai"::text
        END
    )::"TrangThaiYeuCau";

ALTER TABLE "YeuCau"
    ALTER COLUMN "TrangThai" SET DEFAULT 'DangNhanHoSo';

DROP TYPE "TrangThaiYeuCau_old";
