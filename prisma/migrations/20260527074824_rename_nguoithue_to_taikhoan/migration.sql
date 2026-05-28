/*
  Warnings:

  - You are about to drop the column `GiamSatID` on the `BangChungTranhChap` table. All the data in the column will be lost.
  - You are about to drop the column `FreelancerID` on the `BaoGia` table. All the data in the column will be lost.
  - You are about to drop the column `TaiKhoanID` on the `CongViec` table. All the data in the column will be lost.
  - You are about to drop the column `GiamSatID` on the `CuocHoiThoai` table. All the data in the column will be lost.
  - You are about to drop the column `GiamSatID` on the `DanhGia` table. All the data in the column will be lost.
  - The primary key for the `FreelancerKyNang` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `FreelancerID` on the `FreelancerKyNang` table. All the data in the column will be lost.
  - You are about to drop the column `GiamSatID` on the `ThanhToan` table. All the data in the column will be lost.
  - You are about to drop the column `PhiGiamSatTT` on the `ThanhToan` table. All the data in the column will be lost.
  - You are about to drop the column `GiamSatID` on the `ThongBao` table. All the data in the column will be lost.
  - You are about to drop the column `FreelancerID` on the `TienDo` table. All the data in the column will be lost.
  - You are about to drop the column `TaiKhoanID` on the `YeuCauGiamSat` table. All the data in the column will be lost.
  - You are about to drop the column `TaiKhoanID` on the `YeuCauHoanTien` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[TaiKhoanID]` on the table `DonViGiamSat` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[TaiKhoanID]` on the table `Freelancer` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[TaiKhoanID]` on the table `NguoiThue` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `TaiKhoanID` to the `BaoGia` table without a default value. This is not possible if the table is not empty.
  - Added the required column `NguoiThueID` to the `CongViec` table without a default value. This is not possible if the table is not empty.
  - Added the required column `TaiKhoanID` to the `FreelancerKyNang` table without a default value. This is not possible if the table is not empty.
  - Added the required column `TaiKhoanID` to the `TienDo` table without a default value. This is not possible if the table is not empty.
  - Added the required column `NguoiThueID` to the `YeuCauGiamSat` table without a default value. This is not possible if the table is not empty.
  - Added the required column `NguoiThueID` to the `YeuCauHoanTien` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "BangChungTranhChap" DROP CONSTRAINT "BangChungTranhChap_GiamSatID_fkey";

-- DropForeignKey
ALTER TABLE "BaoGia" DROP CONSTRAINT "BaoGia_FreelancerID_fkey";

-- DropForeignKey
ALTER TABLE "CongViec" DROP CONSTRAINT "CongViec_FreelancerID_fkey";

-- DropForeignKey
ALTER TABLE "CongViec" DROP CONSTRAINT "CongViec_GiamSatID_fkey";

-- DropForeignKey
ALTER TABLE "CongViec" DROP CONSTRAINT "CongViec_TaiKhoanID_fkey";

-- DropForeignKey
ALTER TABLE "CuocHoiThoai" DROP CONSTRAINT "CuocHoiThoai_GiamSatID_fkey";

-- DropForeignKey
ALTER TABLE "DanhGia" DROP CONSTRAINT "DanhGia_GiamSatID_fkey";

-- DropForeignKey
ALTER TABLE "FreelancerKyNang" DROP CONSTRAINT "FreelancerKyNang_FreelancerID_fkey";

-- DropForeignKey
ALTER TABLE "KetLuanTranhChap" DROP CONSTRAINT "KetLuanTranhChap_GiamSatID_fkey";

-- DropForeignKey
ALTER TABLE "ThanhToan" DROP CONSTRAINT "ThanhToan_GiamSatID_fkey";

-- DropForeignKey
ALTER TABLE "ThongBao" DROP CONSTRAINT "ThongBao_GiamSatID_fkey";

-- DropForeignKey
ALTER TABLE "TienDo" DROP CONSTRAINT "TienDo_FreelancerID_fkey";

-- DropForeignKey
ALTER TABLE "TienDo" DROP CONSTRAINT "TienDo_XacNhanBoi_fkey";

-- DropForeignKey
ALTER TABLE "TranhChap" DROP CONSTRAINT "TranhChap_GiamSatID_fkey";

-- DropForeignKey
ALTER TABLE "YeuCauGiamSat" DROP CONSTRAINT "YeuCauGiamSat_FreelancerID_fkey";

-- DropForeignKey
ALTER TABLE "YeuCauGiamSat" DROP CONSTRAINT "YeuCauGiamSat_GiamSatID_fkey";

-- DropForeignKey
ALTER TABLE "YeuCauGiamSat" DROP CONSTRAINT "YeuCauGiamSat_TaiKhoanID_fkey";

-- DropForeignKey
ALTER TABLE "YeuCauHoanTien" DROP CONSTRAINT "YeuCauHoanTien_TaiKhoanID_fkey";

-- DropIndex
DROP INDEX "BangChungTranhChap_GiamSatID_idx";

-- DropIndex
DROP INDEX "BaoCao_AdminXuLyID_idx";

-- DropIndex
DROP INDEX "BaoGia_FreelancerID_idx";

-- DropIndex
DROP INDEX "CongViec_TaiKhoanID_idx";

-- DropIndex
DROP INDEX "CuocHoiThoai_GiamSatID_idx";

-- DropIndex
DROP INDEX "DanhGia_GiamSatID_idx";

-- DropIndex
DROP INDEX "idx_danhgia_loai";

-- DropIndex
DROP INDEX "DonViGiamSat_TaiKhoanID_idx";

-- DropIndex
DROP INDEX "Freelancer_TaiKhoanID_idx";

-- DropIndex
DROP INDEX "FreelancerKyNang_FreelancerID_idx";

-- DropIndex
DROP INDEX "FreelancerKyNang_KyNangID_idx";

-- DropIndex
DROP INDEX "KetLuanTranhChap_GiamSatID_idx";

-- DropIndex
DROP INDEX "NguoiThue_TaiKhoanID_idx";

-- DropIndex
DROP INDEX "ThanhToan_GiamSatID_idx";

-- DropIndex
DROP INDEX "ThongBao_GiamSatID_idx";

-- DropIndex
DROP INDEX "TienDo_FreelancerID_idx";

-- DropIndex
DROP INDEX "TienDo_XacNhanBoi_idx";

-- DropIndex
DROP INDEX "idx_tranhchap_gs";

-- DropIndex
DROP INDEX "YeuCauGiamSat_FreelancerID_idx";

-- DropIndex
DROP INDEX "YeuCauGiamSat_GiamSatID_idx";

-- DropIndex
DROP INDEX "YeuCauGiamSat_TaiKhoanID_idx";

-- DropIndex
DROP INDEX "YeuCauHoanTien_TaiKhoanID_idx";

-- DropIndex
DROP INDEX "YeuCauKyNang_KyNangID_idx";

-- DropIndex
DROP INDEX "YeuCauKyNang_YeuCauID_idx";

-- AlterTable
ALTER TABLE "BangChungTranhChap" DROP COLUMN "GiamSatID";

-- AlterTable
ALTER TABLE "BaoGia" DROP COLUMN "FreelancerID",
ADD COLUMN     "TaiKhoanID" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "CongViec" DROP COLUMN "TaiKhoanID",
ADD COLUMN     "DaThanhToanEscrow" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "FreelancerXacNhan" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "GiamSatXacNhan" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "NguoiThueID" INTEGER NOT NULL,
ADD COLUMN     "NguoiThueXacNhan" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "CuocHoiThoai" DROP COLUMN "GiamSatID";

-- AlterTable
ALTER TABLE "DanhGia" DROP COLUMN "GiamSatID";

-- AlterTable
ALTER TABLE "FreelancerKyNang" DROP CONSTRAINT "FreelancerKyNang_pkey",
DROP COLUMN "FreelancerID",
ADD COLUMN     "TaiKhoanID" INTEGER NOT NULL,
ADD CONSTRAINT "FreelancerKyNang_pkey" PRIMARY KEY ("TaiKhoanID", "KyNangID");

-- AlterTable
ALTER TABLE "ThanhToan" DROP COLUMN "GiamSatID",
DROP COLUMN "PhiGiamSatTT";

-- AlterTable
ALTER TABLE "ThongBao" DROP COLUMN "GiamSatID";

-- AlterTable
ALTER TABLE "TienDo" DROP COLUMN "FreelancerID",
ADD COLUMN     "TaiKhoanID" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "YeuCauGiamSat" DROP COLUMN "TaiKhoanID",
ADD COLUMN     "NguoiThueID" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "YeuCauHoanTien" DROP COLUMN "TaiKhoanID",
ADD COLUMN     "NguoiThueID" INTEGER NOT NULL;

-- CreateIndex
CREATE INDEX "BaoGia_TaiKhoanID_idx" ON "BaoGia"("TaiKhoanID");

-- CreateIndex
CREATE INDEX "CongViec_NguoiThueID_idx" ON "CongViec"("NguoiThueID");

-- CreateIndex
CREATE UNIQUE INDEX "DonViGiamSat_TaiKhoanID_key" ON "DonViGiamSat"("TaiKhoanID");

-- CreateIndex
CREATE UNIQUE INDEX "Freelancer_TaiKhoanID_key" ON "Freelancer"("TaiKhoanID");

-- CreateIndex
CREATE UNIQUE INDEX "NguoiThue_TaiKhoanID_key" ON "NguoiThue"("TaiKhoanID");

-- CreateIndex
CREATE INDEX "TienDo_TaiKhoanID_idx" ON "TienDo"("TaiKhoanID");

-- CreateIndex
CREATE INDEX "YeuCau_GiamSatID_idx" ON "YeuCau"("GiamSatID");

-- CreateIndex
CREATE INDEX "YeuCauHoanTien_NguoiThueID_idx" ON "YeuCauHoanTien"("NguoiThueID");

-- AddForeignKey
ALTER TABLE "FreelancerKyNang" ADD CONSTRAINT "FreelancerKyNang_TaiKhoanID_fkey" FOREIGN KEY ("TaiKhoanID") REFERENCES "TaiKhoan"("TaiKhoanID") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "YeuCau" ADD CONSTRAINT "YeuCau_GiamSatID_fkey" FOREIGN KEY ("GiamSatID") REFERENCES "TaiKhoan"("TaiKhoanID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BaoGia" ADD CONSTRAINT "BaoGia_TaiKhoanID_fkey" FOREIGN KEY ("TaiKhoanID") REFERENCES "TaiKhoan"("TaiKhoanID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CongViec" ADD CONSTRAINT "CongViec_FreelancerID_fkey" FOREIGN KEY ("FreelancerID") REFERENCES "TaiKhoan"("TaiKhoanID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CongViec" ADD CONSTRAINT "CongViec_NguoiThueID_fkey" FOREIGN KEY ("NguoiThueID") REFERENCES "TaiKhoan"("TaiKhoanID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CongViec" ADD CONSTRAINT "CongViec_GiamSatID_fkey" FOREIGN KEY ("GiamSatID") REFERENCES "TaiKhoan"("TaiKhoanID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "YeuCauGiamSat" ADD CONSTRAINT "YeuCauGiamSat_NguoiThueID_fkey" FOREIGN KEY ("NguoiThueID") REFERENCES "TaiKhoan"("TaiKhoanID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "YeuCauGiamSat" ADD CONSTRAINT "YeuCauGiamSat_FreelancerID_fkey" FOREIGN KEY ("FreelancerID") REFERENCES "TaiKhoan"("TaiKhoanID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "YeuCauGiamSat" ADD CONSTRAINT "YeuCauGiamSat_GiamSatID_fkey" FOREIGN KEY ("GiamSatID") REFERENCES "TaiKhoan"("TaiKhoanID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TienDo" ADD CONSTRAINT "TienDo_TaiKhoanID_fkey" FOREIGN KEY ("TaiKhoanID") REFERENCES "TaiKhoan"("TaiKhoanID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "YeuCauHoanTien" ADD CONSTRAINT "YeuCauHoanTien_NguoiThueID_fkey" FOREIGN KEY ("NguoiThueID") REFERENCES "TaiKhoan"("TaiKhoanID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- RenameIndex
ALTER INDEX "idx_baogia_yeucau" RENAME TO "BaoGia_YeuCauID_idx";

-- RenameIndex
ALTER INDEX "idx_congviec_giamsat" RENAME TO "CongViec_GiamSatID_idx";

-- RenameIndex
ALTER INDEX "idx_congviec_trangthai" RENAME TO "CongViec_TrangThai_idx";

-- RenameIndex
ALTER INDEX "uq_tranhchap" RENAME TO "KetLuanTranhChap_TranhChapID_key";

-- RenameIndex
ALTER INDEX "uq_macode" RENAME TO "KhuyenMai_MaCode_key";

-- RenameIndex
ALTER INDEX "uq_tenky_nang" RENAME TO "KyNang_TenKyNang_key";

-- RenameIndex
ALTER INDEX "uq_email" RENAME TO "TaiKhoan_Email_key";

-- RenameIndex
ALTER INDEX "uq_tendangnhap" RENAME TO "TaiKhoan_TenDangNhap_key";

-- RenameIndex
ALTER INDEX "idx_thongbao_taikhoan" RENAME TO "ThongBao_TaiKhoanID_DaDoc_idx";

-- RenameIndex
ALTER INDEX "idx_tiendo_congviec" RENAME TO "TienDo_CongViecID_idx";

-- RenameIndex
ALTER INDEX "idx_tinhan_cuoc" RENAME TO "TinNhan_CuocHoiThoaiID_idx";

-- RenameIndex
ALTER INDEX "idx_tranhchap_cv" RENAME TO "TranhChap_CongViecID_idx";

-- RenameIndex
ALTER INDEX "idx_yeucau_taikhoan" RENAME TO "YeuCau_TaiKhoanID_idx";

-- RenameIndex
ALTER INDEX "idx_yeucau_trangthai" RENAME TO "YeuCau_TrangThai_idx";
