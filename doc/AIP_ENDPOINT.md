# API ENDPOINT TONG HOP

## Thong tin chung

- Port mac dinh: `3000` (co the doi qua bien moi truong `PORT`)
- Base URL local: `http://localhost:3000`
- App dang dung ValidationPipe global voi:
  - `whitelist: true`
  - `forbidNonWhitelisted: true`
  - `transform: true`
- Auth hien tai:
  - Khong dung token
  - Khong hash password

## Danh sach endpoint

| Method | Path                  | Mo ta                          |
| ------ | --------------------- | ------------------------------ |
| GET    | /health               | Kiem tra app con song          |
| POST   | /auth/register        | Dang ky tai khoan              |
| POST   | /auth/login           | Dang nhap tai khoan            |
| GET    | /users                | Lay danh sach nguoi dung       |
| GET    | /users/search         | Tim kiem nguoi dung            |
| GET    | /users/:id            | Lay thong tin nguoi dung       |
| GET    | /users/:id/profile    | Lay profile chi tiet           |
| GET    | /users/:id/jobs       | Lay danh sach cong viec        |
| PUT    | /users/:id            | Cap nhat thong tin nguoi dung  |
| DELETE | /users/:id            | Xoa nguoi dung (soft delete)   |
| GET    | /categories           | Lay danh sach loai dich vu     |
| GET    | /categories/:id       | Lay thong tin loai dich vu     |
| POST   | /categories           | Tao loai dich vu moi           |
| PUT    | /categories/:id       | Cap nhat loai dich vu          |
| DELETE | /categories/:id       | Xoa loai dich vu               |
| POST   | /jobs                 | Tao yeu cau thue moi           |
| GET    | /jobs                 | Lay danh sach yeu cau          |
| GET    | /jobs/search          | Tim kiem yeu cau               |
| GET    | /jobs/:id             | Lay thong tin yeu cau          |
| PUT    | /jobs/:id             | Cap nhat yeu cau               |
| DELETE | /jobs/:id             | Xoa yeu cau (soft delete)      |
| POST   | /proposals            | Tao bao gia moi                |
| GET    | /proposals/:id        | Lay thong tin bao gia          |
| PUT    | /proposals/:id        | Cap nhat bao gia               |
| DELETE | /proposals/:id        | Xoa bao gia                    |
| GET    | /jobs/:id/proposals   | Lay bao gia cua yeu cau        |
| GET    | /freelancers/:id/proposals | Lay bao gia cua freelancer |
| POST   | /contracts            | Tao hop dong moi               |
| GET    | /contracts            | Lay danh sach hop dong         |
| GET    | /contracts/:id        | Lay thong tin hop dong         |
| GET    | /contracts/:id/detail | Lay chi tiet hop dong          |
| PUT    | /contracts/:id/status | Cap nhat trang thai hop dong   |
| GET    | /users/:id/contracts  | Lay hop dong cua user          |
| GET    | /supervisors          | Lay danh sach don vi giam sat  |
| GET    | /supervisors/search   | Tim kiem don vi giam sat       |
| GET    | /supervisors/:id      | Lay thong tin don vi giam sat  |
| POST   | /supervisors          | Tao don vi giam sat moi        |
| PUT    | /supervisors/:id      | Cap nhat don vi giam sat       |
| DELETE | /supervisors/:id      | Xoa don vi giam sat            |
| POST   | /contracts/:id/supervisor | Client chon giam sat       |
| PUT    | /contracts/:id/supervisor/accept | Freelancer chap nhan giam sat |
| PUT    | /contracts/:id/supervisor/reject | Freelancer tu choi giam sat |
| POST   | /contracts/:id/progress | Tao tien do moi            |
| GET    | /contracts/:id/progress | Lay danh sach tien do      |
| GET    | /progress/:id         | Lay thong tin tien do      |
| PUT    | /progress/:id         | Cap nhat tien do           |
| DELETE | /progress/:id         | Xoa tien do                |
| GET    | /users/:id/contracts  | Lay hop dong cua user          |

---

## 1) GET /health

### Mo ta

Tra ve trang thai co ban cua ung dung.

### Request body

Khong co.

### Response 200

```json
{
  "status": "ok",
  "timestamp": "2026-04-22T12:00:00.000Z"
}
```

---

## 2) POST /auth/register

### Mo ta

Tao tai khoan moi trong bang `TaiKhoan`.

Neu `vaiTro` la:

- `NguoiThue`: tao them ban ghi trong bang `NguoiThue`
- `Freelancer`: tao them ban ghi trong bang `Freelancer`
- `DonViGiamSat`: tao them ban ghi trong bang `DonViGiamSat`

Mac dinh `vaiTro = NguoiThue` neu khong truyen.

### Request body

```json
{
  "tenDangNhap": "user01",
  "matKhau": "123456",
  "email": "user01@example.com",
  "hoTen": "Nguyen Van A",
  "soDienThoai": "0901000001",
  "gioiTinh": "Nam",
  "diaChi": "Ha Noi",
  "vaiTro": "NguoiThue",
  "tenDonVi": "Cong ty giam sat A"
}
```

### Truong bat buoc

- `tenDangNhap`
- `matKhau`
- `email`
- `hoTen`

### Gia tri hop le

- `gioiTinh`: `Nam` | `Nu` | `Khac`
- `vaiTro`: `NguoiThue` | `Freelancer` | `DonViGiamSat`

### Response 201

```json
{
  "message": "Dang ky thanh cong",
  "user": {
    "taiKhoanId": 10,
    "tenDangNhap": "user01",
    "email": "user01@example.com",
    "hoTen": "Nguyen Van A",
    "soDienThoai": "0901000001",
    "gioiTinh": "Nam",
    "diaChi": "Ha Noi",
    "vaiTro": "NguoiThue",
    "trangThai": "HoatDong",
    "ngayTao": "2026-04-22T12:10:00.000Z"
  }
}
```

### Loi thuong gap

- `400 Bad Request`
  - `tenDangNhap is required`
  - `matKhau is required`
  - `email is required`
  - `hoTen is required`
  - `Ten dang nhap da ton tai`
  - `Email da ton tai`
  - `GioiTinh khong hop le`
  - `VaiTro khong hop le`

---

## 3) POST /auth/login

### Mo ta

Dang nhap bang `tenDangNhap` va `matKhau` dang luu plain text.

### Request body

```json
{
  "tenDangNhap": "user01",
  "matKhau": "123456"
}
```

### Truong bat buoc

- `tenDangNhap`
- `matKhau`

### Response 201

```json
{
  "message": "Dang nhap thanh cong",
  "user": {
    "taiKhoanId": 10,
    "tenDangNhap": "user01",
    "email": "user01@example.com",
    "hoTen": "Nguyen Van A",
    "soDienThoai": "0901000001",
    "gioiTinh": "Nam",
    "diaChi": "Ha Noi",
    "vaiTro": "NguoiThue",
    "trangThai": "HoatDong",
    "ngayTao": "2026-04-22T12:10:00.000Z"
  }
}
```

### Loi thuong gap

- `400 Bad Request`
  - `tenDangNhap is required`
  - `matKhau is required`
- `401 Unauthorized`
  - `Thong tin dang nhap khong chinh xac`
  - `Tai khoan khong hoat dong`

---
==============================================================================================================
## 4) GET /users

### Mo ta

Lay danh sach tat ca nguoi dung trong he thong.

### Request body

Khong co.

### Response 200

```json
{
  "total": 2,
  "users": [
    {
      "taiKhoanId": 10,
      "tenDangNhap": "user01",
      "email": "user01@example.com",
      "hoTen": "Nguyen Van A",
      "soDienThoai": "0901000001",
      "gioiTinh": "Nam",
      "diaChi": "Ha Noi",
      "vaiTro": "NguoiThue",
      "trangThai": "HoatDong",
      "ngayTao": "2026-04-22T12:10:00.000Z",
      "ngayCapNhat": "2026-04-22T12:10:00.000Z"
    }
  ]
}
```

---

## 5) GET /users/search

### Mo ta

Tim kiem nguoi dung theo tu khoa (tenDangNhap, email, hoTen, soDienThoai).

### Query params

- `keyword` (optional): Tu khoa tim kiem

### Vi du

```
GET /users/search?keyword=nguyen
```

### Response 200

```json
{
  "total": 1,
  "users": [
    {
      "taiKhoanId": 10,
      "tenDangNhap": "user01",
      "email": "user01@example.com",
      "hoTen": "Nguyen Van A",
      "soDienThoai": "0901000001",
      "gioiTinh": "Nam",
      "diaChi": "Ha Noi",
      "vaiTro": "NguoiThue",
      "trangThai": "HoatDong",
      "ngayTao": "2026-04-22T12:10:00.000Z",
      "ngayCapNhat": "2026-04-22T12:10:00.000Z"
    }
  ]
}
```

---

## 6) GET /users/:id

### Mo ta

Lay thong tin co ban cua mot nguoi dung.

### Path params

- `id`: ID cua nguoi dung

### Response 200

```json
{
  "user": {
    "taiKhoanId": 10,
    "tenDangNhap": "user01",
    "email": "user01@example.com",
    "hoTen": "Nguyen Van A",
    "soDienThoai": "0901000001",
    "gioiTinh": "Nam",
    "diaChi": "Ha Noi",
    "vaiTro": "NguoiThue",
    "trangThai": "HoatDong",
    "ngayTao": "2026-04-22T12:10:00.000Z",
    "ngayCapNhat": "2026-04-22T12:10:00.000Z"
  }
}
```

### Loi thuong gap

- `404 Not Found`
  - `Nguoi dung khong ton tai`

---

## 7) GET /users/:id/profile

### Mo ta

Lay thong tin profile chi tiet cua nguoi dung theo vai tro (NguoiThue, Freelancer, DonViGiamSat).

### Path params

- `id`: ID cua nguoi dung

### Response 200 (NguoiThue)

```json
{
  "user": {
    "taiKhoanId": 10,
    "tenDangNhap": "user01",
    "email": "user01@example.com",
    "hoTen": "Nguyen Van A",
    "soDienThoai": "0901000001",
    "gioiTinh": "Nam",
    "diaChi": "Ha Noi",
    "vaiTro": "NguoiThue",
    "trangThai": "HoatDong",
    "ngayTao": "2026-04-22T12:10:00.000Z",
    "ngayCapNhat": "2026-04-22T12:10:00.000Z"
  },
  "profile": {
    "role": "NguoiThue",
    "nguoiThue": {
      "nguoiThueId": 5,
      "congTy": "Cong ty ABC",
      "moTa": "Cong ty chuyen ve phat trien phan mem",
      "diemTinCay": "4.50",
      "tongYeuCau": 10,
      "tyLeHoanThanh": "85.00"
    }
  }
}
```

### Response 200 (Freelancer)

```json
{
  "user": { ... },
  "profile": {
    "role": "Freelancer",
    "freelancer": {
      "freelancerId": 8,
      "kinhNghiem": 3,
      "chuyenGia": "Web Development",
      "kyNang": "JavaScript, TypeScript, React, Node.js",
      "xepHang": "4.80",
      "soDu": "5000000.00",
      "xacThucEmail": true,
      "xacThucSDT": true,
      "tongCongViec": 25,
      "tyLeHoanThanh": "92.00"
    }
  }
}
```

### Response 200 (DonViGiamSat)

```json
{
  "user": { ... },
  "profile": {
    "role": "DonViGiamSat",
    "donViGiamSat": {
      "giamSatId": 3,
      "tenDonVi": "Cong ty giam sat A",
      "moTa": "Chuyen giam sat cac du an CNTT",
      "nangLuc": "ISO 9001, ISO 27001",
      "chungChi": "Chung chi giam sat quoc te",
      "phiGiamSat": "2000000.00",
      "xepHang": "4.70",
      "tongCongViecGS": 15,
      "trangThai": "HoatDong",
      "ngayDangKy": "2026-01-15T08:00:00.000Z"
    }
  }
}
```

### Loi thuong gap

- `404 Not Found`
  - `Nguoi dung khong ton tai`

---

## 8) GET /users/:id/jobs

### Mo ta

Lay danh sach cong viec cua nguoi dung (NguoiThue hoac Freelancer).

### Path params

- `id`: ID cua nguoi dung

### Response 200

```json
{
  "total": 2,
  "jobs": [
    {
      "congViecId": 15,
      "yeuCauId": 8,
      "freelancerId": 5,
      "nguoiThueId": 3,
      "giaThoa": "5000000.00",
      "thoiGianThoa": 30,
      "trangThai": "DangThucHien",
      "ngayBatDau": "2026-04-20T08:00:00.000Z",
      "ngayKetThuc": null,
      "giamSatId": 2,
      "trangThaiGiamSat": "DangGiamSat",
      "phiGiamSat": "500000.00",
      "ngayTao": "2026-04-20T08:00:00.000Z"
    }
  ]
}
```

### Loi thuong gap

- `404 Not Found`
  - `Nguoi dung khong ton tai`

---

## 9) PUT /users/:id

### Mo ta

Cap nhat thong tin nguoi dung.

### Path params

- `id`: ID cua nguoi dung

### Request body

```json
{
  "tenDangNhap": "user01_updated",
  "email": "newemail@example.com",
  "hoTen": "Nguyen Van B",
  "soDienThoai": "0901000002",
  "gioiTinh": "Nu",
  "diaChi": "Ho Chi Minh",
  "trangThai": "HoatDong"
}
```

### Truong co the cap nhat

- `tenDangNhap`
- `email`
- `hoTen`
- `soDienThoai`
- `gioiTinh`
- `diaChi`
- `trangThai`

### Gia tri hop le

- `gioiTinh`: `Nam` | `Nu` | `Khac`
- `trangThai`: `HoatDong` | `BiKhoa` | `ChoDuyet` | `DaBi`

### Response 200

```json
{
  "message": "Cap nhat nguoi dung thanh cong",
  "user": {
    "taiKhoanId": 10,
    "tenDangNhap": "user01_updated",
    "email": "newemail@example.com",
    "hoTen": "Nguyen Van B",
    "soDienThoai": "0901000002",
    "gioiTinh": "Nu",
    "diaChi": "Ho Chi Minh",
    "vaiTro": "NguoiThue",
    "trangThai": "HoatDong",
    "ngayTao": "2026-04-22T12:10:00.000Z",
    "ngayCapNhat": "2026-04-22T14:30:00.000Z"
  }
}
```

### Loi thuong gap

- `400 Bad Request`
  - `Khong co truong hop le de cap nhat`
  - `Ten dang nhap da ton tai`
  - `Email da ton tai`
  - `GioiTinh khong hop le`
  - `TrangThai khong hop le`
- `404 Not Found`
  - `Nguoi dung khong ton tai`

---

## 10) DELETE /users/:id

### Mo ta

Xoa nguoi dung (soft delete - chi cap nhat trangThai thanh "DaBi").

### Path params

- `id`: ID cua nguoi dung

### Response 200

```json
{
  "message": "Xoa nguoi dung thanh cong",
  "userId": 10,
  "trangThai": "DaBi"
}
```

### Loi thuong gap

- `404 Not Found`
  - `Nguoi dung khong ton tai`

---

## 11) GET /categories

### Mo ta

Lay danh sach tat ca loai dich vu.

### Request body

Khong co.

### Response 200

```json
{
  "total": 3,
  "categories": [
    {
      "loaiDichVuId": 1,
      "tenLoai": "Thiet ke web",
      "moTa": "Thiet ke giao dien website",
      "hinhAnh": "https://example.com/web-design.jpg"
    },
    {
      "loaiDichVuId": 2,
      "tenLoai": "Lap trinh mobile",
      "moTa": "Phat trien ung dung di dong",
      "hinhAnh": null
    }
  ]
}
```

---
=============================================================================================================
## 12) GET /categories/:id

### Mo ta

Lay thong tin chi tiet cua mot loai dich vu.

### Path params

- `id`: ID cua loai dich vu

### Response 200

```json
{
  "category": {
    "loaiDichVuId": 1,
    "tenLoai": "Thiet ke web",
    "moTa": "Thiet ke giao dien website",
    "hinhAnh": "https://example.com/web-design.jpg"
  }
}
```

### Loi thuong gap

- `404 Not Found`
  - `Loai dich vu khong ton tai`

---

## 13) POST /categories

### Mo ta

Tao loai dich vu moi.

### Request body

```json
{
  "tenLoai": "Thiet ke web",
  "moTa": "Thiet ke giao dien website",
  "hinhAnh": "https://example.com/web-design.jpg"
}
```

### Truong bat buoc

- `tenLoai`

### Response 201

```json
{
  "message": "Tao loai dich vu thanh cong",
  "category": {
    "loaiDichVuId": 1,
    "tenLoai": "Thiet ke web",
    "moTa": "Thiet ke giao dien website",
    "hinhAnh": "https://example.com/web-design.jpg"
  }
}
```

### Loi thuong gap

- `400 Bad Request`
  - `tenLoai is required`
  - `Ten loai dich vu da ton tai`

---

## 14) PUT /categories/:id

### Mo ta

Cap nhat thong tin loai dich vu.

### Path params

- `id`: ID cua loai dich vu

### Request body

```json
{
  "tenLoai": "Thiet ke web va mobile",
  "moTa": "Thiet ke giao dien website va ung dung mobile",
  "hinhAnh": "https://example.com/new-image.jpg"
}
```

### Truong co the cap nhat

- `tenLoai`
- `moTa`
- `hinhAnh`

### Response 200

```json
{
  "message": "Cap nhat loai dich vu thanh cong",
  "category": {
    "loaiDichVuId": 1,
    "tenLoai": "Thiet ke web va mobile",
    "moTa": "Thiet ke giao dien website va ung dung mobile",
    "hinhAnh": "https://example.com/new-image.jpg"
  }
}
```

### Loi thuong gap

- `400 Bad Request`
  - `Khong co truong hop le de cap nhat`
  - `Ten loai dich vu da ton tai`
- `404 Not Found`
  - `Loai dich vu khong ton tai`

---

## 15) DELETE /categories/:id

### Mo ta

Xoa loai dich vu (hard delete).

### Path params

- `id`: ID cua loai dich vu

### Response 200

```json
{
  "message": "Xoa loai dich vu thanh cong",
  "categoryId": 1
}
```

### Loi thuong gap

- `404 Not Found`
  - `Loai dich vu khong ton tai`

---
==============================================================================================================
## 16) POST /jobs

### Mo ta

Tao yeu cau thue moi (job posting).

### Request body

```json
{
  "nguoiThueId": 5,
  "loaiDichVuId": 1,
  "tieuDe": "Can thiet ke website ban hang",
  "moTa": "Can thiet ke website ban hang online voi day du tinh nang gio hang, thanh toan",
  "nganSachMin": 5000000,
  "nganSachMax": 10000000,
  "thoiHan": "2026-05-30",
  "yeuCauGiamSat": true
}
```

### Truong bat buoc

- `nguoiThueId`
- `loaiDichVuId`
- `tieuDe`
- `moTa`
- `nganSachMin`
- `nganSachMax`
- `thoiHan`

### Response 201

```json
{
  "message": "Tao yeu cau thanh cong",
  "job": {
    "yeuCauId": 15,
    "nguoiThueId": 5,
    "loaiDichVuId": 1,
    "tieuDe": "Can thiet ke website ban hang",
    "moTa": "Can thiet ke website ban hang online voi day du tinh nang gio hang, thanh toan",
    "nganSachMin": "5000000.00",
    "nganSachMax": "10000000.00",
    "thoiHan": "2026-05-30T00:00:00.000Z",
    "trangThai": "DangMo",
    "soLuongBaoGia": 0,
    "yeuCauGiamSat": true,
    "ngayTao": "2026-04-23T08:00:00.000Z",
    "ngayCapNhat": "2026-04-23T08:00:00.000Z",
    "nguoiThue": {
      "taiKhoanId": 10,
      "hoTen": "Nguyen Van A",
      "email": "user01@example.com"
    },
    "loaiDichVu": {
      "loaiDichVuId": 1,
      "tenLoai": "Thiet ke web"
    }
  }
}
```

### Loi thuong gap

- `400 Bad Request`
  - `tieuDe is required`
  - `moTa is required`
  - `Nguoi thue khong ton tai`
  - `Loai dich vu khong ton tai`
  - `Ngan sach phai lon hon hoac bang 0`
  - `Ngan sach min phai nho hon hoac bang ngan sach max`
  - `Thoi han khong hop le`

---
phần dưới chưa làm ============================================================================================
## 17) GET /jobs

### Mo ta

Lay danh sach tat ca yeu cau thue.

### Request body

Khong co.

### Response 200

```json
{
  "total": 2,
  "jobs": [
    {
      "yeuCauId": 15,
      "nguoiThueId": 5,
      "loaiDichVuId": 1,
      "tieuDe": "Can thiet ke website ban hang",
      "moTa": "Can thiet ke website ban hang online",
      "nganSachMin": "5000000.00",
      "nganSachMax": "10000000.00",
      "thoiHan": "2026-05-30T00:00:00.000Z",
      "trangThai": "DangMo",
      "soLuongBaoGia": 3,
      "yeuCauGiamSat": true,
      "ngayTao": "2026-04-23T08:00:00.000Z",
      "ngayCapNhat": "2026-04-23T08:00:00.000Z",
      "nguoiThue": {
        "taiKhoanId": 10,
        "hoTen": "Nguyen Van A",
        "email": "user01@example.com"
      },
      "loaiDichVu": {
        "loaiDichVuId": 1,
        "tenLoai": "Thiet ke web"
      }
    }
  ]
}
```

---

## 18) GET /jobs/search

### Mo ta

Tim kiem yeu cau thue theo tu khoa, loai dich vu, hoac ngan sach.

### Query params

- `keyword` (optional): Tim kiem trong tieu de va mo ta
- `category` (optional): ID loai dich vu
- `budget` (optional): Ngan sach (tim yeu cau co ngan sach min <= budget <= ngan sach max)

### Vi du

```
GET /jobs/search?keyword=website&category=1&budget=7000000
```

### Response 200

```json
{
  "total": 1,
  "jobs": [
    {
      "yeuCauId": 15,
      "nguoiThueId": 5,
      "loaiDichVuId": 1,
      "tieuDe": "Can thiet ke website ban hang",
      "moTa": "Can thiet ke website ban hang online",
      "nganSachMin": "5000000.00",
      "nganSachMax": "10000000.00",
      "thoiHan": "2026-05-30T00:00:00.000Z",
      "trangThai": "DangMo",
      "soLuongBaoGia": 3,
      "yeuCauGiamSat": true,
      "ngayTao": "2026-04-23T08:00:00.000Z",
      "ngayCapNhat": "2026-04-23T08:00:00.000Z",
      "nguoiThue": {
        "taiKhoanId": 10,
        "hoTen": "Nguyen Van A",
        "email": "user01@example.com"
      },
      "loaiDichVu": {
        "loaiDichVuId": 1,
        "tenLoai": "Thiet ke web"
      }
    }
  ]
}
```

---

## 19) GET /jobs/:id

### Mo ta

Lay thong tin chi tiet cua mot yeu cau thue.

### Path params

- `id`: ID cua yeu cau

### Response 200

```json
{
  "job": {
    "yeuCauId": 15,
    "nguoiThueId": 5,
    "loaiDichVuId": 1,
    "tieuDe": "Can thiet ke website ban hang",
    "moTa": "Can thiet ke website ban hang online voi day du tinh nang gio hang, thanh toan",
    "nganSachMin": "5000000.00",
    "nganSachMax": "10000000.00",
    "thoiHan": "2026-05-30T00:00:00.000Z",
    "trangThai": "DangMo",
    "soLuongBaoGia": 3,
    "yeuCauGiamSat": true,
    "ngayTao": "2026-04-23T08:00:00.000Z",
    "ngayCapNhat": "2026-04-23T08:00:00.000Z",
    "nguoiThue": {
      "taiKhoanId": 10,
      "hoTen": "Nguyen Van A",
      "email": "user01@example.com"
    },
    "loaiDichVu": {
      "loaiDichVuId": 1,
      "tenLoai": "Thiet ke web"
    }
  }
}
```

### Loi thuong gap

- `404 Not Found`
  - `Yeu cau khong ton tai`

---

## 20) PUT /jobs/:id

### Mo ta

Cap nhat thong tin yeu cau thue.

### Path params

- `id`: ID cua yeu cau

### Request body

```json
{
  "loaiDichVuId": 2,
  "tieuDe": "Can thiet ke website va mobile app",
  "moTa": "Mo ta cap nhat",
  "nganSachMin": 8000000,
  "nganSachMax": 15000000,
  "thoiHan": "2026-06-15",
  "trangThai": "DangMo",
  "yeuCauGiamSat": false
}
```

### Truong co the cap nhat

- `loaiDichVuId`
- `tieuDe`
- `moTa`
- `nganSachMin`
- `nganSachMax`
- `thoiHan`
- `trangThai`
- `yeuCauGiamSat`

### Gia tri hop le cho trangThai

- `MoDau` | `DangMo` | `DaDong` | `DaHuy` | `HoanThanh`

### Response 200

```json
{
  "message": "Cap nhat yeu cau thanh cong",
  "job": {
    "yeuCauId": 15,
    "nguoiThueId": 5,
    "loaiDichVuId": 2,
    "tieuDe": "Can thiet ke website va mobile app",
    "moTa": "Mo ta cap nhat",
    "nganSachMin": "8000000.00",
    "nganSachMax": "15000000.00",
    "thoiHan": "2026-06-15T00:00:00.000Z",
    "trangThai": "DangMo",
    "soLuongBaoGia": 3,
    "yeuCauGiamSat": false,
    "ngayTao": "2026-04-23T08:00:00.000Z",
    "ngayCapNhat": "2026-04-23T10:30:00.000Z",
    "nguoiThue": {
      "taiKhoanId": 10,
      "hoTen": "Nguyen Van A",
      "email": "user01@example.com"
    },
    "loaiDichVu": {
      "loaiDichVuId": 2,
      "tenLoai": "Lap trinh mobile"
    }
  }
}
```

### Loi thuong gap

- `400 Bad Request`
  - `Khong co truong hop le de cap nhat`
  - `Loai dich vu khong ton tai`
  - `Ngan sach min phai lon hon hoac bang 0`
  - `Ngan sach max phai lon hon hoac bang 0`
  - `Thoi han khong hop le`
  - `TrangThai khong hop le`
- `404 Not Found`
  - `Yeu cau khong ton tai`

---

## 21) DELETE /jobs/:id

### Mo ta

Xoa yeu cau thue (soft delete - cap nhat trangThai thanh "DaHuy").

### Path params

- `id`: ID cua yeu cau

### Response 200

```json
{
  "message": "Xoa yeu cau thanh cong",
  "jobId": 15
}
```

### Loi thuong gap

- `404 Not Found`
  - `Yeu cau khong ton tai`

---
=========================================================================================================
## 22) POST /proposals

### Mo ta

Tao bao gia moi cho mot yeu cau thue.

### Request body

```json
{
  "yeuCauId": 15,
  "freelancerId": 8,
  "giaDeXuat": 7000000,
  "thoiGianThucHien": 25,
  "noiDung": "Toi co kinh nghiem 3 nam ve thiet ke web, da tung lam nhieu du an tuong tu"
}
```

### Truong bat buoc

- `yeuCauId`
- `freelancerId`
- `giaDeXuat`
- `thoiGianThucHien`

### Response 201

```json
{
  "message": "Tao bao gia thanh cong",
  "proposal": {
    "baoGiaId": 25,
    "yeuCauId": 15,
    "freelancerId": 8,
    "giaDeXuat": "7000000.00",
    "thoiGianThucHien": 25,
    "noiDung": "Toi co kinh nghiem 3 nam ve thiet ke web",
    "trangThai": "DaGui",
    "ngayTao": "2026-04-23T09:00:00.000Z",
    "ngayCapNhat": "2026-04-23T09:00:00.000Z",
    "freelancer": {
      "freelancerId": 8,
      "taiKhoanId": 12,
      "hoTen": "Tran Van B",
      "email": "freelancer01@example.com",
      "kinhNghiem": 3,
      "kyNang": "JavaScript, React, Node.js",
      "xepHang": "4.80"
    },
    "yeuCau": {
      "yeuCauId": 15,
      "tieuDe": "Can thiet ke website ban hang",
      "nguoiThueId": 5
    }
  }
}
```

### Loi thuong gap

- `400 Bad Request`
  - `Yeu cau khong ton tai`
  - `Freelancer khong ton tai`
  - `Gia de xuat phai lon hon 0`
  - `Thoi gian thuc hien phai lon hon 0`
  - `Freelancer da gui bao gia cho yeu cau nay`

---

## 23) GET /proposals/:id

### Mo ta

Lay thong tin chi tiet cua mot bao gia.

### Path params

- `id`: ID cua bao gia

### Response 200

```json
{
  "proposal": {
    "baoGiaId": 25,
    "yeuCauId": 15,
    "freelancerId": 8,
    "giaDeXuat": "7000000.00",
    "thoiGianThucHien": 25,
    "noiDung": "Toi co kinh nghiem 3 nam ve thiet ke web",
    "trangThai": "DaGui",
    "ngayTao": "2026-04-23T09:00:00.000Z",
    "ngayCapNhat": "2026-04-23T09:00:00.000Z",
    "freelancer": {
      "freelancerId": 8,
      "taiKhoanId": 12,
      "hoTen": "Tran Van B",
      "email": "freelancer01@example.com",
      "kinhNghiem": 3,
      "kyNang": "JavaScript, React, Node.js",
      "xepHang": "4.80"
    },
    "yeuCau": {
      "yeuCauId": 15,
      "tieuDe": "Can thiet ke website ban hang",
      "nguoiThueId": 5
    }
  }
}
```

### Loi thuong gap

- `404 Not Found`
  - `Bao gia khong ton tai`

---

## 24) PUT /proposals/:id

### Mo ta

Cap nhat thong tin bao gia.

### Path params

- `id`: ID cua bao gia

### Request body

```json
{
  "giaDeXuat": 6500000,
  "thoiGianThucHien": 20,
  "noiDung": "Cap nhat: Co the hoan thanh som hon",
  "trangThai": "DaGui"
}
```

### Truong co the cap nhat

- `giaDeXuat`
- `thoiGianThucHien`
- `noiDung`
- `trangThai`

### Gia tri hop le cho trangThai

- `DaGui` | `DuocChon` | `TuChoi` | `HetHan`

### Response 200

```json
{
  "message": "Cap nhat bao gia thanh cong",
  "proposal": {
    "baoGiaId": 25,
    "yeuCauId": 15,
    "freelancerId": 8,
    "giaDeXuat": "6500000.00",
    "thoiGianThucHien": 20,
    "noiDung": "Cap nhat: Co the hoan thanh som hon",
    "trangThai": "DaGui",
    "ngayTao": "2026-04-23T09:00:00.000Z",
    "ngayCapNhat": "2026-04-23T10:00:00.000Z",
    "freelancer": {
      "freelancerId": 8,
      "taiKhoanId": 12,
      "hoTen": "Tran Van B",
      "email": "freelancer01@example.com",
      "kinhNghiem": 3,
      "kyNang": "JavaScript, React, Node.js",
      "xepHang": "4.80"
    },
    "yeuCau": {
      "yeuCauId": 15,
      "tieuDe": "Can thiet ke website ban hang",
      "nguoiThueId": 5
    }
  }
}
```

### Loi thuong gap

- `400 Bad Request`
  - `Khong co truong hop le de cap nhat`
  - `Gia de xuat phai lon hon 0`
  - `Thoi gian thuc hien phai lon hon 0`
  - `TrangThai khong hop le`
- `404 Not Found`
  - `Bao gia khong ton tai`

---

## 25) DELETE /proposals/:id

### Mo ta

Xoa bao gia (hard delete).

### Path params

- `id`: ID cua bao gia

### Response 200

```json
{
  "message": "Xoa bao gia thanh cong",
  "proposalId": 25
}
```

### Loi thuong gap

- `404 Not Found`
  - `Bao gia khong ton tai`

---

## 26) GET /jobs/:id/proposals

### Mo ta

Lay danh sach tat ca bao gia cua mot yeu cau thue.

### Path params

- `id`: ID cua yeu cau thue

### Response 200

```json
{
  "total": 3,
  "proposals": [
    {
      "baoGiaId": 25,
      "yeuCauId": 15,
      "freelancerId": 8,
      "giaDeXuat": "7000000.00",
      "thoiGianThucHien": 25,
      "noiDung": "Toi co kinh nghiem 3 nam",
      "trangThai": "DaGui",
      "ngayTao": "2026-04-23T09:00:00.000Z",
      "ngayCapNhat": "2026-04-23T09:00:00.000Z",
      "freelancer": {
        "freelancerId": 8,
        "taiKhoanId": 12,
        "hoTen": "Tran Van B",
        "email": "freelancer01@example.com",
        "kinhNghiem": 3,
        "kyNang": "JavaScript, React, Node.js",
        "xepHang": "4.80"
      },
      "yeuCau": {
        "yeuCauId": 15,
        "tieuDe": "Can thiet ke website ban hang",
        "nguoiThueId": 5
      }
    }
  ]
}
```

### Loi thuong gap

- `400 Bad Request`
  - `Yeu cau khong ton tai`

---

## 27) GET /freelancers/:id/proposals

### Mo ta

Lay danh sach tat ca bao gia cua mot freelancer.

### Path params

- `id`: ID cua freelancer

### Response 200

```json
{
  "total": 5,
  "proposals": [
    {
      "baoGiaId": 25,
      "yeuCauId": 15,
      "freelancerId": 8,
      "giaDeXuat": "7000000.00",
      "thoiGianThucHien": 25,
      "noiDung": "Toi co kinh nghiem 3 nam",
      "trangThai": "DaGui",
      "ngayTao": "2026-04-23T09:00:00.000Z",
      "ngayCapNhat": "2026-04-23T09:00:00.000Z",
      "freelancer": {
        "freelancerId": 8,
        "taiKhoanId": 12,
        "hoTen": "Tran Van B",
        "email": "freelancer01@example.com",
        "kinhNghiem": 3,
        "kyNang": "JavaScript, React, Node.js",
        "xepHang": "4.80"
      },
      "yeuCau": {
        "yeuCauId": 15,
        "tieuDe": "Can thiet ke website ban hang",
        "nguoiThueId": 5
      }
    }
  ]
}
```

### Loi thuong gap

- `400 Bad Request`
  - `Freelancer khong ton tai`

---
=============================================================================================================
## 28) POST /contracts

### Mo ta

Tao hop dong moi giua nguoi thue va freelancer.

### Request body

```json
{
  "yeuCauId": 15,
  "freelancerId": 8,
  "nguoiThueId": 5,
  "giaThoa": 7000000,
  "thoiGianThoa": 25
}
```

### Truong bat buoc

- `yeuCauId`
- `freelancerId`
- `nguoiThueId`
- `giaThoa`
- `thoiGianThoa`

### Response 201

```json
{
  "message": "Tao hop dong thanh cong",
  "contract": {
    "congViecId": 30,
    "yeuCauId": 15,
    "freelancerId": 8,
    "nguoiThueId": 5,
    "giaThoa": "7000000.00",
    "thoiGianThoa": 25,
    "trangThai": "MoiTao",
    "ngayBatDau": null,
    "ngayKetThuc": null,
    "giamSatId": null,
    "trangThaiGiamSat": "KhongCo",
    "phiGiamSat": "0.00",
    "ngayTao": "2026-04-23T10:00:00.000Z",
    "yeuCau": {
      "yeuCauId": 15,
      "tieuDe": "Can thiet ke website ban hang",
      "moTa": "Can thiet ke website ban hang online voi day du tinh nang"
    },
    "freelancer": {
      "freelancerId": 8,
      "taiKhoanId": 12,
      "hoTen": "Tran Van B",
      "email": "freelancer01@example.com"
    },
    "nguoiThue": {
      "nguoiThueId": 5,
      "taiKhoanId": 10,
      "hoTen": "Nguyen Van A",
      "email": "user01@example.com"
    },
    "giamSat": null
  }
}
```

### Loi thuong gap

- `400 Bad Request`
  - `Yeu cau khong ton tai`
  - `Freelancer khong ton tai`
  - `Nguoi thue khong ton tai`
  - `Gia thoa phai lon hon 0`
  - `Thoi gian thoa phai lon hon 0`

---

## 29) GET /contracts

### Mo ta

Lay danh sach tat ca hop dong.

### Request body

Khong co.

### Response 200

```json
{
  "total": 2,
  "contracts": [
    {
      "congViecId": 30,
      "yeuCauId": 15,
      "freelancerId": 8,
      "nguoiThueId": 5,
      "giaThoa": "7000000.00",
      "thoiGianThoa": 25,
      "trangThai": "DangThucHien",
      "ngayBatDau": "2026-04-23T10:30:00.000Z",
      "ngayKetThuc": null,
      "giamSatId": null,
      "trangThaiGiamSat": "KhongCo",
      "phiGiamSat": "0.00",
      "ngayTao": "2026-04-23T10:00:00.000Z",
      "yeuCau": {
        "yeuCauId": 15,
        "tieuDe": "Can thiet ke website ban hang",
        "moTa": "Can thiet ke website ban hang online"
      },
      "freelancer": {
        "freelancerId": 8,
        "taiKhoanId": 12,
        "hoTen": "Tran Van B",
        "email": "freelancer01@example.com"
      },
      "nguoiThue": {
        "nguoiThueId": 5,
        "taiKhoanId": 10,
        "hoTen": "Nguyen Van A",
        "email": "user01@example.com"
      },
      "giamSat": null
    }
  ]
}
```

---

## 30) GET /contracts/:id

### Mo ta

Lay thong tin chi tiet cua mot hop dong.

### Path params

- `id`: ID cua hop dong

### Response 200

```json
{
  "contract": {
    "congViecId": 30,
    "yeuCauId": 15,
    "freelancerId": 8,
    "nguoiThueId": 5,
    "giaThoa": "7000000.00",
    "thoiGianThoa": 25,
    "trangThai": "DangThucHien",
    "ngayBatDau": "2026-04-23T10:30:00.000Z",
    "ngayKetThuc": null,
    "giamSatId": null,
    "trangThaiGiamSat": "KhongCo",
    "phiGiamSat": "0.00",
    "ngayTao": "2026-04-23T10:00:00.000Z",
    "yeuCau": {
      "yeuCauId": 15,
      "tieuDe": "Can thiet ke website ban hang",
      "moTa": "Can thiet ke website ban hang online voi day du tinh nang"
    },
    "freelancer": {
      "freelancerId": 8,
      "taiKhoanId": 12,
      "hoTen": "Tran Van B",
      "email": "freelancer01@example.com"
    },
    "nguoiThue": {
      "nguoiThueId": 5,
      "taiKhoanId": 10,
      "hoTen": "Nguyen Van A",
      "email": "user01@example.com"
    },
    "giamSat": null
  }
}
```

### Loi thuong gap

- `404 Not Found`
  - `Hop dong khong ton tai`

---

## 31) GET /contracts/:id/detail

### Mo ta

Lay chi tiet day du cua mot hop dong (tuong tu GET /contracts/:id).

### Path params

- `id`: ID cua hop dong

### Response 200

Giong voi GET /contracts/:id

### Loi thuong gap

- `404 Not Found`
  - `Hop dong khong ton tai`

---

## 32) PUT /contracts/:id/status

### Mo ta

Cap nhat trang thai hop dong.

### Path params

- `id`: ID cua hop dong

### Request body

```json
{
  "trangThai": "DangThucHien"
}
```

### Truong bat buoc

- `trangThai`

### Gia tri hop le cho trangThai

- `MoiTao` | `DangThucHien` | `HoanThanh` | `DaHuy` | `TranhChap`

### Luu y

- Khi trangThai chuyen sang `DangThucHien`: Tu dong set `ngayBatDau`
- Khi trangThai chuyen sang `HoanThanh` hoac `DaHuy`: Tu dong set `ngayKetThuc`

### Response 200

```json
{
  "message": "Cap nhat trang thai hop dong thanh cong",
  "contract": {
    "congViecId": 30,
    "yeuCauId": 15,
    "freelancerId": 8,
    "nguoiThueId": 5,
    "giaThoa": "7000000.00",
    "thoiGianThoa": 25,
    "trangThai": "DangThucHien",
    "ngayBatDau": "2026-04-23T10:30:00.000Z",
    "ngayKetThuc": null,
    "giamSatId": null,
    "trangThaiGiamSat": "KhongCo",
    "phiGiamSat": "0.00",
    "ngayTao": "2026-04-23T10:00:00.000Z",
    "yeuCau": {
      "yeuCauId": 15,
      "tieuDe": "Can thiet ke website ban hang",
      "moTa": "Can thiet ke website ban hang online"
    },
    "freelancer": {
      "freelancerId": 8,
      "taiKhoanId": 12,
      "hoTen": "Tran Van B",
      "email": "freelancer01@example.com"
    },
    "nguoiThue": {
      "nguoiThueId": 5,
      "taiKhoanId": 10,
      "hoTen": "Nguyen Van A",
      "email": "user01@example.com"
    },
    "giamSat": null
  }
}
```

### Loi thuong gap

- `400 Bad Request`
  - `TrangThai khong hop le`
- `404 Not Found`
  - `Hop dong khong ton tai`

---

## 33) GET /users/:id/contracts

### Mo ta

Lay danh sach hop dong cua mot user (NguoiThue hoac Freelancer).

### Path params

- `id`: ID cua user (TaiKhoanID)

### Response 200

```json
{
  "total": 3,
  "contracts": [
    {
      "congViecId": 30,
      "yeuCauId": 15,
      "freelancerId": 8,
      "nguoiThueId": 5,
      "giaThoa": "7000000.00",
      "thoiGianThoa": 25,
      "trangThai": "DangThucHien",
      "ngayBatDau": "2026-04-23T10:30:00.000Z",
      "ngayKetThuc": null,
      "giamSatId": null,
      "trangThaiGiamSat": "KhongCo",
      "phiGiamSat": "0.00",
      "ngayTao": "2026-04-23T10:00:00.000Z",
      "yeuCau": {
        "yeuCauId": 15,
        "tieuDe": "Can thiet ke website ban hang",
        "moTa": "Can thiet ke website ban hang online"
      },
      "freelancer": {
        "freelancerId": 8,
        "taiKhoanId": 12,
        "hoTen": "Tran Van B",
        "email": "freelancer01@example.com"
      },
      "nguoiThue": {
        "nguoiThueId": 5,
        "taiKhoanId": 10,
        "hoTen": "Nguyen Van A",
        "email": "user01@example.com"
      },
      "giamSat": null
    }
  ]
}
```

### Loi thuong gap

- `404 Not Found`
  - `Nguoi dung khong ton tai`

---

## Ghi chu

- Chua co JWT/session.
- Chua co refresh token.
- Chua hash password (chi phu hop dev/test).

=============================================================================================================
## 34) GET /supervisors

### Mo ta

Lay danh sach tat ca don vi giam sat.

### Request body

Khong co.

### Response 200

```json
{
  "total": 2,
  "supervisors": [
    {
      "giamSatId": 1,
      "taiKhoanId": 15,
      "tenDonVi": "Cong ty giam sat A",
      "moTa": "Chuyen giam sat cac du an CNTT",
      "nangLuc": "ISO 9001, ISO 27001",
      "chungChi": "Chung chi giam sat quoc te",
      "phiGiamSat": "2000000.00",
      "xepHang": "4.70",
      "tongCongViecGS": 15,
      "trangThai": "HoatDong",
      "ngayDangKy": "2026-01-15T08:00:00.000Z",
      "taiKhoan": {
        "taiKhoanId": 15,
        "hoTen": "Nguyen Van C",
        "email": "giamsat01@example.com",
        "soDienThoai": "0901000003"
      }
    }
  ]
}
```

---

## 35) GET /supervisors/search

### Mo ta

Tim kiem don vi giam sat theo tu khoa (tenDonVi, moTa, nangLuc).

### Query params

- `keyword` (optional): Tu khoa tim kiem

### Vi du

```
GET /supervisors/search?keyword=ISO
```

### Response 200

```json
{
  "total": 1,
  "supervisors": [
    {
      "giamSatId": 1,
      "taiKhoanId": 15,
      "tenDonVi": "Cong ty giam sat A",
      "moTa": "Chuyen giam sat cac du an CNTT",
      "nangLuc": "ISO 9001, ISO 27001",
      "chungChi": "Chung chi giam sat quoc te",
      "phiGiamSat": "2000000.00",
      "xepHang": "4.70",
      "tongCongViecGS": 15,
      "trangThai": "HoatDong",
      "ngayDangKy": "2026-01-15T08:00:00.000Z",
      "taiKhoan": {
        "taiKhoanId": 15,
        "hoTen": "Nguyen Van C",
        "email": "giamsat01@example.com",
        "soDienThoai": "0901000003"
      }
    }
  ]
}
```

---

## 36) GET /supervisors/:id

### Mo ta

Lay thong tin chi tiet cua mot don vi giam sat.

### Path params

- `id`: ID cua don vi giam sat

### Response 200

```json
{
  "supervisor": {
    "giamSatId": 1,
    "taiKhoanId": 15,
    "tenDonVi": "Cong ty giam sat A",
    "moTa": "Chuyen giam sat cac du an CNTT",
    "nangLuc": "ISO 9001, ISO 27001",
    "chungChi": "Chung chi giam sat quoc te",
    "phiGiamSat": "2000000.00",
    "xepHang": "4.70",
    "tongCongViecGS": 15,
    "trangThai": "HoatDong",
    "ngayDangKy": "2026-01-15T08:00:00.000Z",
    "taiKhoan": {
      "taiKhoanId": 15,
      "hoTen": "Nguyen Van C",
      "email": "giamsat01@example.com",
      "soDienThoai": "0901000003"
    }
  }
}
```

### Loi thuong gap

- `404 Not Found`
  - `Don vi giam sat khong ton tai`

---

## 37) POST /supervisors

### Mo ta

Tao don vi giam sat moi.

### Request body

```json
{
  "taiKhoanId": 15,
  "tenDonVi": "Cong ty giam sat A",
  "moTa": "Chuyen giam sat cac du an CNTT",
  "nangLuc": "ISO 9001, ISO 27001",
  "chungChi": "Chung chi giam sat quoc te",
  "phiGiamSat": 2000000
}
```

### Truong bat buoc

- `taiKhoanId`
- `tenDonVi`
- `phiGiamSat`

### Response 201

```json
{
  "message": "Tao don vi giam sat thanh cong",
  "supervisor": {
    "giamSatId": 1,
    "taiKhoanId": 15,
    "tenDonVi": "Cong ty giam sat A",
    "moTa": "Chuyen giam sat cac du an CNTT",
    "nangLuc": "ISO 9001, ISO 27001",
    "chungChi": "Chung chi giam sat quoc te",
    "phiGiamSat": "2000000.00",
    "xepHang": "0.00",
    "tongCongViecGS": 0,
    "trangThai": "ChoDuyet",
    "ngayDangKy": "2026-04-23T11:00:00.000Z",
    "taiKhoan": {
      "taiKhoanId": 15,
      "hoTen": "Nguyen Van C",
      "email": "giamsat01@example.com",
      "soDienThoai": "0901000003"
    }
  }
}
```

### Loi thuong gap

- `400 Bad Request`
  - `tenDonVi is required`
  - `Tai khoan khong ton tai`
  - `Tai khoan da co don vi giam sat`
  - `Phi giam sat phai lon hon hoac bang 0`

---

## 38) PUT /supervisors/:id

### Mo ta

Cap nhat thong tin don vi giam sat.

### Path params

- `id`: ID cua don vi giam sat

### Request body

```json
{
  "tenDonVi": "Cong ty giam sat A - Cap nhat",
  "moTa": "Mo ta cap nhat",
  "nangLuc": "ISO 9001, ISO 27001, ISO 14001",
  "chungChi": "Chung chi cap nhat",
  "phiGiamSat": 2500000,
  "trangThai": "HoatDong"
}
```

### Truong co the cap nhat

- `tenDonVi`
- `moTa`
- `nangLuc`
- `chungChi`
- `phiGiamSat`
- `trangThai`

### Gia tri hop le cho trangThai

- `HoatDong` | `TamNghi` | `BiKhoa` | `ChoDuyet`

### Response 200

```json
{
  "message": "Cap nhat don vi giam sat thanh cong",
  "supervisor": {
    "giamSatId": 1,
    "taiKhoanId": 15,
    "tenDonVi": "Cong ty giam sat A - Cap nhat",
    "moTa": "Mo ta cap nhat",
    "nangLuc": "ISO 9001, ISO 27001, ISO 14001",
    "chungChi": "Chung chi cap nhat",
    "phiGiamSat": "2500000.00",
    "xepHang": "4.70",
    "tongCongViecGS": 15,
    "trangThai": "HoatDong",
    "ngayDangKy": "2026-01-15T08:00:00.000Z",
    "taiKhoan": {
      "taiKhoanId": 15,
      "hoTen": "Nguyen Van C",
      "email": "giamsat01@example.com",
      "soDienThoai": "0901000003"
    }
  }
}
```

### Loi thuong gap

- `400 Bad Request`
  - `Khong co truong hop le de cap nhat`
  - `Phi giam sat phai lon hon hoac bang 0`
  - `TrangThai khong hop le`
- `404 Not Found`
  - `Don vi giam sat khong ton tai`

---

## 39) DELETE /supervisors/:id

### Mo ta

Xoa don vi giam sat (soft delete - cap nhat trangThai thanh "BiKhoa").

### Path params

- `id`: ID cua don vi giam sat

### Response 200

```json
{
  "message": "Xoa don vi giam sat thanh cong",
  "supervisorId": 1
}
```

### Loi thuong gap

- `404 Not Found`
  - `Don vi giam sat khong ton tai`

---

## Ghi chu

- Chua co JWT/session.
- Chua co refresh token.
- Chua hash password (chi phu hop dev/test).

=============================================================================================================
## 40) POST /contracts/:id/supervisor

### Mo ta

Client (NguoiThue) chon don vi giam sat cho hop dong. Tao ban ghi YeuCauGiamSat voi trang thai "ChoDuyet" va cap nhat thong tin giam sat vao hop dong.

### Path params

- `id`: ID cua hop dong

### Request body

```json
{
  "giamSatId": 1,
  "phiGiamSat": 2000000
}
```

### Truong bat buoc

- `giamSatId`
- `phiGiamSat`

### Response 201

```json
{
  "message": "Chon don vi giam sat thanh cong",
  "yeuCauGiamSatId": 5,
  "trangThai": "ChoDuyet"
}
```

### Loi thuong gap

- `400 Bad Request`
  - `Don vi giam sat khong ton tai`
  - `Don vi giam sat khong hoat dong`
  - `Phi giam sat phai lon hon hoac bang 0`
  - `Freelancer khong ton tai`
- `404 Not Found`
  - `Hop dong khong ton tai`

---

## 41) PUT /contracts/:id/supervisor/accept

### Mo ta

Freelancer chap nhan don vi giam sat da duoc chon. Cap nhat trang thai YeuCauGiamSat thanh "DaChapNhan" va trang thai giam sat cua hop dong thanh "DangGiamSat".

### Path params

- `id`: ID cua hop dong

### Request body

Khong co.

### Response 200

```json
{
  "message": "Chap nhan don vi giam sat thanh cong",
  "yeuCauGiamSatId": 5,
  "trangThai": "DaChapNhan"
}
```

### Loi thuong gap

- `400 Bad Request`
  - `Hop dong chua co don vi giam sat`
- `404 Not Found`
  - `Hop dong khong ton tai`
  - `Khong tim thay yeu cau giam sat cho duyet`

---

## 42) PUT /contracts/:id/supervisor/reject

### Mo ta

Freelancer tu choi don vi giam sat da duoc chon. Cap nhat trang thai YeuCauGiamSat thanh "TuChoi" va xoa thong tin giam sat khoi hop dong.

### Path params

- `id`: ID cua hop dong

### Request body

Khong co.

### Response 200

```json
{
  "message": "Tu choi don vi giam sat thanh cong",
  "yeuCauGiamSatId": 5,
  "trangThai": "TuChoi"
}
```

### Loi thuong gap

- `400 Bad Request`
  - `Hop dong chua co don vi giam sat`
- `404 Not Found`
  - `Hop dong khong ton tai`
  - `Khong tim thay yeu cau giam sat cho duyet`

---

## Ghi chu

- Chua co JWT/session.
- Chua co refresh token.
- Chua hash password (chi phu hop dev/test).

=============================================================================================================
## 43) POST /contracts/:id/progress

### Mo ta

Freelancer tao bao cao tien do moi cho hop dong.

### Path params

- `id`: ID cua hop dong

### Request body

```json
{
  "congViecId": 30,
  "freelancerId": 8,
  "tieuDe": "Hoan thanh thiet ke giao dien",
  "moTa": "Da hoan thanh thiet ke giao dien trang chu va trang san pham",
  "phanTram": 30,
  "tepDinhKem": "https://example.com/files/design-v1.zip"
}
```

### Truong bat buoc

- `congViecId`
- `freelancerId`
- `tieuDe`
- `phanTram`

### Response 201

```json
{
  "message": "Tao tien do thanh cong",
  "progress": {
    "tienDoId": 10,
    "congViecId": 30,
    "freelancerId": 8,
    "tieuDe": "Hoan thanh thiet ke giao dien",
    "moTa": "Da hoan thanh thiet ke giao dien trang chu va trang san pham",
    "phanTram": 30,
    "tepDinhKem": "https://example.com/files/design-v1.zip",
    "xacNhanBoi": null,
    "trangThaiXacNhan": "ChuaXacNhan",
    "ngayTao": "2026-04-23T14:00:00.000Z",
    "congViec": {
      "congViecId": 30,
      "yeuCauId": 15,
      "giaThoa": "7000000.00"
    },
    "freelancer": {
      "freelancerId": 8,
      "taiKhoanId": 12,
      "hoTen": "Tran Van B",
      "email": "freelancer01@example.com"
    },
    "donViGiamSat": null
  }
}
```

### Loi thuong gap

- `400 Bad Request`
  - `tieuDe is required`
  - `Hop dong khong ton tai`
  - `Freelancer khong ton tai`
  - `Phan tram phai tu 0 den 100`

---

## 44) GET /contracts/:id/progress

### Mo ta

Lay danh sach tat ca tien do cua mot hop dong.

### Path params

- `id`: ID cua hop dong

### Response 200

```json
{
  "total": 3,
  "progress": [
    {
      "tienDoId": 10,
      "congViecId": 30,
      "freelancerId": 8,
      "tieuDe": "Hoan thanh thiet ke giao dien",
      "moTa": "Da hoan thanh thiet ke giao dien trang chu va trang san pham",
      "phanTram": 30,
      "tepDinhKem": "https://example.com/files/design-v1.zip",
      "xacNhanBoi": null,
      "trangThaiXacNhan": "ChuaXacNhan",
      "ngayTao": "2026-04-23T14:00:00.000Z",
      "congViec": {
        "congViecId": 30,
        "yeuCauId": 15,
        "giaThoa": "7000000.00"
      },
      "freelancer": {
        "freelancerId": 8,
        "taiKhoanId": 12,
        "hoTen": "Tran Van B",
        "email": "freelancer01@example.com"
      },
      "donViGiamSat": null
    }
  ]
}
```

### Loi thuong gap

- `400 Bad Request`
  - `Hop dong khong ton tai`

---

## 45) GET /progress/:id

### Mo ta

Lay thong tin chi tiet cua mot tien do.

### Path params

- `id`: ID cua tien do

### Response 200

```json
{
  "progress": {
    "tienDoId": 10,
    "congViecId": 30,
    "freelancerId": 8,
    "tieuDe": "Hoan thanh thiet ke giao dien",
    "moTa": "Da hoan thanh thiet ke giao dien trang chu va trang san pham",
    "phanTram": 30,
    "tepDinhKem": "https://example.com/files/design-v1.zip",
    "xacNhanBoi": 1,
    "trangThaiXacNhan": "DaXacNhan",
    "ngayTao": "2026-04-23T14:00:00.000Z",
    "congViec": {
      "congViecId": 30,
      "yeuCauId": 15,
      "giaThoa": "7000000.00"
    },
    "freelancer": {
      "freelancerId": 8,
      "taiKhoanId": 12,
      "hoTen": "Tran Van B",
      "email": "freelancer01@example.com"
    },
    "donViGiamSat": {
      "giamSatId": 1,
      "tenDonVi": "Cong ty giam sat A"
    }
  }
}
```

### Loi thuong gap

- `404 Not Found`
  - `Tien do khong ton tai`

---

## 46) PUT /progress/:id

### Mo ta

Cap nhat thong tin tien do.

### Path params

- `id`: ID cua tien do

### Request body

```json
{
  "tieuDe": "Hoan thanh thiet ke giao dien - Cap nhat",
  "moTa": "Mo ta cap nhat",
  "phanTram": 50,
  "tepDinhKem": "https://example.com/files/design-v2.zip",
  "trangThaiXacNhan": "DaXacNhan"
}
```

### Truong co the cap nhat

- `tieuDe`
- `moTa`
- `phanTram`
- `tepDinhKem`
- `trangThaiXacNhan`

### Gia tri hop le cho trangThaiXacNhan

- `ChuaXacNhan` | `DaXacNhan` | `TuChoi`

### Response 200

```json
{
  "message": "Cap nhat tien do thanh cong",
  "progress": {
    "tienDoId": 10,
    "congViecId": 30,
    "freelancerId": 8,
    "tieuDe": "Hoan thanh thiet ke giao dien - Cap nhat",
    "moTa": "Mo ta cap nhat",
    "phanTram": 50,
    "tepDinhKem": "https://example.com/files/design-v2.zip",
    "xacNhanBoi": 1,
    "trangThaiXacNhan": "DaXacNhan",
    "ngayTao": "2026-04-23T14:00:00.000Z",
    "congViec": {
      "congViecId": 30,
      "yeuCauId": 15,
      "giaThoa": "7000000.00"
    },
    "freelancer": {
      "freelancerId": 8,
      "taiKhoanId": 12,
      "hoTen": "Tran Van B",
      "email": "freelancer01@example.com"
    },
    "donViGiamSat": {
      "giamSatId": 1,
      "tenDonVi": "Cong ty giam sat A"
    }
  }
}
```

### Loi thuong gap

- `400 Bad Request`
  - `Khong co truong hop le de cap nhat`
  - `Phan tram phai tu 0 den 100`
  - `TrangThai khong hop le`
- `404 Not Found`
  - `Tien do khong ton tai`

---

## 47) DELETE /progress/:id

### Mo ta

Xoa tien do (hard delete).

### Path params

- `id`: ID cua tien do

### Response 200

```json
{
  "message": "Xoa tien do thanh cong",
  "progressId": 10
}
```

### Loi thuong gap

- `404 Not Found`
  - `Tien do khong ton tai`

---

## Ghi chu

- Chua co JWT/session.
- Chua co refresh token.
- Chua hash password (chi phu hop dev/test).
