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
                 AND kl."KetQua" IN ('HoanTienNguoiThue', 'HuyHopDong')
           ) THEN
            RETURN NEW;
        END IF;

        RAISE EXCEPTION 'Cong viec co tranh chap phai giu trang thai hoan thanh hoac tranh chap tru khi ket luan hoan tien/huy hop dong';
    END IF;

    RETURN NEW;
END;
$$;
