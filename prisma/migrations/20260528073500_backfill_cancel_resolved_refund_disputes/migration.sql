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
        IF NEW."TrangThai" = 'DaHuy'
           AND EXISTS (
               SELECT 1
               FROM "TranhChap" AS tc
               JOIN "KetLuanTranhChap" AS kl
                 ON kl."TranhChapID" = tc."TranhChapID"
               WHERE tc."CongViecID" = NEW."CongViecID"
                 AND tc."TrangThai" IN ('DaKetLuan', 'DaDong')
                 AND kl."KetQua" IN ('HoanTienNguoiThue', 'HuyHopDong', 'PhanChia')
           ) THEN
            RETURN NEW;
        END IF;

        RAISE EXCEPTION 'Cong viec co tranh chap phai giu trang thai hoan thanh hoac tranh chap tru khi ket luan hoan tien/huy hop dong/phan chia';
    END IF;

    RETURN NEW;
END;
$$;

UPDATE "CongViec" AS cv
SET
  "TrangThai" = 'DaHuy',
  "TrangThaiGiamSat" = 'HoanThanh',
  "NgayKetThuc" = COALESCE(cv."NgayKetThuc", NOW())
FROM "TranhChap" AS tc
JOIN "KetLuanTranhChap" AS kl
  ON kl."TranhChapID" = tc."TranhChapID"
WHERE tc."CongViecID" = cv."CongViecID"
  AND tc."TrangThai" IN ('DaKetLuan', 'DaDong')
  AND kl."KetQua" IN ('HoanTienNguoiThue', 'HuyHopDong', 'PhanChia')
  AND cv."TrangThai" <> 'DaHuy';

UPDATE "YeuCauGiamSat" AS ycgs
SET
  "TrangThai" = 'HoanThanh',
  "NgayHoanThanh" = COALESCE(ycgs."NgayHoanThanh", NOW())
FROM "TranhChap" AS tc
JOIN "KetLuanTranhChap" AS kl
  ON kl."TranhChapID" = tc."TranhChapID"
WHERE tc."CongViecID" = ycgs."CongViecID"
  AND tc."TrangThai" IN ('DaKetLuan', 'DaDong')
  AND kl."KetQua" IN ('HoanTienNguoiThue', 'HuyHopDong', 'PhanChia')
  AND ycgs."TrangThai" = 'DaChapNhan';
