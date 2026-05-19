-- CreateTable: KyNang (danh mục kỹ năng dùng chung)
CREATE TABLE "KyNang" (
    "KyNangID"  SERIAL NOT NULL,
    "TenKyNang" VARCHAR(100) NOT NULL,
    "MoTa"      VARCHAR(255),

    CONSTRAINT "KyNang_pkey" PRIMARY KEY ("KyNangID")
);

-- CreateIndex
CREATE UNIQUE INDEX "uq_tenky_nang" ON "KyNang"("TenKyNang");

-- CreateTable: YeuCauKyNang (kỹ năng yêu cầu của một yêu cầu thuê)
CREATE TABLE "YeuCauKyNang" (
    "YeuCauID" INTEGER NOT NULL,
    "KyNangID" INTEGER NOT NULL,

    CONSTRAINT "YeuCauKyNang_pkey" PRIMARY KEY ("YeuCauID", "KyNangID")
);

-- CreateIndex
CREATE INDEX "YeuCauKyNang_YeuCauID_idx" ON "YeuCauKyNang"("YeuCauID");
CREATE INDEX "YeuCauKyNang_KyNangID_idx" ON "YeuCauKyNang"("KyNangID");

-- CreateTable: FreelancerKyNang (kỹ năng của freelancer - chuẩn hóa từ text tự do)
CREATE TABLE "FreelancerKyNang" (
    "FreelancerID" INTEGER NOT NULL,
    "KyNangID"     INTEGER NOT NULL,

    CONSTRAINT "FreelancerKyNang_pkey" PRIMARY KEY ("FreelancerID", "KyNangID")
);

-- CreateIndex
CREATE INDEX "FreelancerKyNang_FreelancerID_idx" ON "FreelancerKyNang"("FreelancerID");
CREATE INDEX "FreelancerKyNang_KyNangID_idx" ON "FreelancerKyNang"("KyNangID");

-- AddForeignKey
ALTER TABLE "YeuCauKyNang" ADD CONSTRAINT "YeuCauKyNang_YeuCauID_fkey"
    FOREIGN KEY ("YeuCauID") REFERENCES "YeuCau"("YeuCauID") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "YeuCauKyNang" ADD CONSTRAINT "YeuCauKyNang_KyNangID_fkey"
    FOREIGN KEY ("KyNangID") REFERENCES "KyNang"("KyNangID") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "FreelancerKyNang" ADD CONSTRAINT "FreelancerKyNang_FreelancerID_fkey"
    FOREIGN KEY ("FreelancerID") REFERENCES "Freelancer"("FreelancerID") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "FreelancerKyNang" ADD CONSTRAINT "FreelancerKyNang_KyNangID_fkey"
    FOREIGN KEY ("KyNangID") REFERENCES "KyNang"("KyNangID") ON DELETE CASCADE ON UPDATE CASCADE;
