# FRAS-TMDT Backend API Guide

**Base URL:** `http://localhost:3000`

---

## BREAKING CHANGES - Schema Refactor

### All Business Foreign Keys Now Use TaiKhoanID (User Account ID)

The entire database schema has been refactored. The key changes are:

1. **ALL business foreign keys now use `TaiKhoanID` directly** (the user account ID from the `TaiKhoan` table).
2. Tables `NguoiThue`, `Freelancer`, `DonViGiamSat` are now **ONLY profile/supplementary tables** - they store extra profile data but are NOT used as foreign keys in business tables.
3. **Creating a job (YeuCau):** You pass `nguoiThueId` which is the **TaiKhoanID** of the job creator, NOT a NguoiThue table ID.
4. **Creating a proposal (BaoGia):** You pass `freelancerId` which is the **TaiKhoanID** of the freelancer, NOT a Freelancer table ID.
5. **Contracts (CongViec):** `freelancerId` and `nguoiThueId` fields ARE TaiKhoanIDs directly.
6. **Role determination:** The system determines user role by checking `TaiKhoan.VaiTro` field (values: `NguoiThue`, `Freelancer`, `DonViGiamSat`, `Admin`, `KhachVangLai`).

### Migration Summary

| Before (Old Schema) | After (New Schema) |
|---|---|
| `YeuCau.NguoiThueID` -> `NguoiThue.NguoiThueID` | `YeuCau.TaiKhoanID` -> `TaiKhoan.TaiKhoanID` |
| `BaoGia.FreelancerID` -> `Freelancer.FreelancerID` | `BaoGia.TaiKhoanID` -> `TaiKhoan.TaiKhoanID` |
| `CongViec.FreelancerID` -> `Freelancer.FreelancerID` | `CongViec.FreelancerID` -> `TaiKhoan.TaiKhoanID` |
| `CongViec.NguoiThueID` -> `NguoiThue.NguoiThueID` | `CongViec.NguoiThueID` -> `TaiKhoan.TaiKhoanID` |

### What This Means for Frontend

- When calling any API, use the **logged-in user's `taiKhoanId`** as the identifier.
- No need to look up NguoiThue/Freelancer profile IDs for business operations.
- Profile tables are only needed for displaying extra profile info (company name, experience, etc.).

---

## Table of Contents

1. [Authentication](#1-authentication)
2. [Users](#2-users)
3. [Jobs (YeuCau)](#3-jobs)
4. [Proposals (BaoGia)](#4-proposals)
5. [Contracts (CongViec)](#5-contracts)
6. [Contract Flow](#6-contract-flow)
7. [Progress (TienDo)](#7-progress)
8. [Freelancers](#8-freelancers)
9. [Skills (KyNang)](#9-skills)
10. [Categories (LoaiDichVu)](#10-categories)
11. [Supervisors (DonViGiamSat)](#11-supervisors)
12. [Chat](#12-chat)
13. [WebSocket Chat Gateway](#13-websocket-chat-gateway)
14. [Recommendations](#14-recommendations)
15. [Payments (ThanhToan)](#15-payments)
16. [Disputes (TranhChap)](#16-disputes)
17. [Evidences (BangChung)](#17-evidences)
18. [Reviews (DanhGia)](#18-reviews)
19. [Notifications (ThongBao)](#19-notifications)
20. [Reports (BaoCao)](#20-reports)
21. [Admin](#21-admin)

---

## 1. Authentication

### POST /auth/register

Register a new user account.

**Request Body:**

| Field | Required | Description |
|---|---|---|
| tenDangNhap | Yes | Username |
| matKhau | Yes | Password |
| email | Yes | Email address |
| hoTen | Yes | Full name |
| soDienThoai | Optional | Phone number |
| gioiTinh | Optional | Gender: `Nam`, `Nu`, `Khac` |
| diaChi | Optional | Address |
| vaiTro | Optional | Role: `NguoiThue`, `Freelancer`, `DonViGiamSat`, `KhachVangLai` (default: `KhachVangLai`) |
| tenDonVi | Optional | Company/unit name (for DonViGiamSat role) |

**Response (200):**
```json
{
  "message": "Dang ky thanh cong",
  "user": {
    "taiKhoanId": 1,
    "tenDangNhap": "nguyenvana",
    "email": "nguyenvana@email.com",
    "hoTen": "Nguyen Van A",
    "soDienThoai": "0901234567",
    "gioiTinh": "Nam",
    "diaChi": "Ha Noi",
    "vaiTro": "NguoiThue",
    "trangThai": "HoatDong",
    "ngayTao": "2025-01-01T00:00:00.000Z"
  }
}
```

**Error Codes:**
- `400` - Missing required fields / Email already exists / Username already exists

---

### POST /auth/login

Login with email and password.

**Request Body:**

| Field | Required | Description |
|---|---|---|
| email | Yes | Email address |
| matKhau | Yes | Password |

**Response (200):**

```json
{
  "message": "Dang nhap thanh cong",
  "user": {
    "taiKhoanId": 1,
    "tenDangNhap": "nguyenvana",
    "email": "nguyenvana@email.com",
    "hoTen": "Nguyen Van A",
    "soDienThoai": "0901234567",
    "gioiTinh": "Nam",
    "diaChi": "Ha Noi",
    "vaiTro": "NguoiThue",
    "trangThai": "HoatDong",
    "ngayTao": "2025-01-01T00:00:00.000Z"
  }
}
```

**Error Codes:**
- `400` - Missing email or password
- `401` - Invalid credentials
- `403` - Account is banned/inactive

---

## 2. Users

### GET /users

Get all users.

**Response (200):**

```json
{
  "total": 5,
  "users": [
    {
      "taiKhoanId": 1,
      "tenDangNhap": "nguyenvana",
      "email": "nguyenvana@email.com",
      "hoTen": "Nguyen Van A",
      "soDienThoai": "0901234567",
      "gioiTinh": "Nam",
      "diaChi": "Ha Noi",
      "vaiTro": "NguoiThue",
      "trangThai": "HoatDong",
      "ngayTao": "2025-01-01T00:00:00.000Z",
      "ngayCapNhat": "2025-01-01T00:00:00.000Z"
    }
  ]
}
```

---

### GET /users/search?keyword=nguyen

Search users by keyword (matches name or email).

**Query Parameters:**

| Param | Required | Description |
|---|---|---|
| keyword | Optional | Search keyword |

**Response:** Same format as GET /users.

---

### GET /users/:id

Get a single user by TaiKhoanID.

**Response (200):**

```json
{
  "user": {
    "taiKhoanId": 1,
    "tenDangNhap": "nguyenvana",
    "email": "nguyenvana@email.com",
    "hoTen": "Nguyen Van A",
    "soDienThoai": "0901234567",
    "gioiTinh": "Nam",
    "diaChi": "Ha Noi",
    "vaiTro": "NguoiThue",
    "trangThai": "HoatDong",
    "ngayTao": "2025-01-01T00:00:00.000Z",
    "ngayCapNhat": "2025-01-01T00:00:00.000Z"
  }
}
```

**Error Codes:**
- `404` - User not found

---

### GET /users/:id/profile

Get user profile with role-specific supplementary data.

**Response (200) - Example for NguoiThue:**

```json
{
  "user": {
    "taiKhoanId": 1,
    "tenDangNhap": "nguyenvana",
    "email": "nguyenvana@email.com",
    "hoTen": "Nguyen Van A",
    "soDienThoai": "0901234567",
    "gioiTinh": "Nam",
    "diaChi": "Ha Noi",
    "vaiTro": "NguoiThue",
    "trangThai": "HoatDong",
    "ngayTao": "2025-01-01T00:00:00.000Z",
    "ngayCapNhat": "2025-01-01T00:00:00.000Z"
  },
  "profile": {
    "role": "NguoiThue",
    "nguoiThue": {
      "nguoiThueId": 1,
      "congTy": "ABC Corp",
      "moTa": "Looking for developers",
      "diemTinCay": "4.5",
      "tongYeuCau": 10,
      "tyLeHoanThanh": "80.00"
    }
  }
}
```

**Response (200) - Example for Freelancer:**

```json
{
  "user": { "..." : "..." },
  "profile": {
    "role": "Freelancer",
    "freelancer": {
      "freelancerId": 1,
      "kinhNghiem": 5,
      "chuyenGia": "Web Development",
      "kyNang": "React, Node.js",
      "xepHang": "4.8",
      "soDu": "5000000",
      "xacThucEmail": true,
      "xacThucSDT": true,
      "tongCongViec": 15,
      "tyLeHoanThanh": "93.33"
    }
  }
}
```

**Error Codes:**
- `404` - User not found

---

### GET /users/:id/jobs

Get all jobs created by a user (by TaiKhoanID).

**Response:** Same format as GET /jobs.

---

### GET /users/:id/contracts

Get all contracts for a user (as freelancer or client).

**Response:** Same format as GET /contracts.

---

### GET /users/:id/conversations

Get all chat conversations for a user.

**Response:** Same format as conversation list.

---

### PUT /users/:id

Update user information.

**Request Body:**

| Field | Required | Description |
|---|---|---|
| tenDangNhap | Optional | Username |
| email | Optional | Email |
| hoTen | Optional | Full name |
| soDienThoai | Optional | Phone number |
| gioiTinh | Optional | Gender: `Nam`, `Nu`, `Khac` |
| diaChi | Optional | Address |
| trangThai | Optional | Status: `HoatDong`, `Khoa` |

**Response (200):**

```json
{
  "message": "Cap nhat thanh cong",
  "user": { "...": "same as UserDto" }
}
```

**Error Codes:**
- `400` - No valid fields to update
- `404` - User not found

---

### DELETE /users/:id

Soft-delete (ban) a user account.

**Response (200):**

```json
{
  "message": "Xoa tai khoan thanh cong",
  "userId": 1,
  "trangThai": "Khoa"
}
```

**Error Codes:**
- `404` - User not found

---

## 3. Jobs

### GET /jobs

Get all jobs.

**Response (200):**

```json
{
  "total": 3,
  "jobs": [
    {
      "yeuCauId": 1,
      "nguoiThueId": 1,
      "loaiDichVuId": 2,
      "tieuDe": "Build a React website",
      "moTa": "Need a responsive website...",
      "nganSachMin": "5000000",
      "nganSachMax": "10000000",
      "thoiHan": "2025-03-01T00:00:00.000Z",
      "trangThai": "DangMo",
      "soLuongBaoGia": 3,
      "yeuCauGiamSat": false,
      "giamSatId": null,
      "ngayTao": "2025-01-15T00:00:00.000Z",
      "ngayCapNhat": "2025-01-15T00:00:00.000Z",
      "nguoiThue": {
        "taiKhoanId": 1,
        "hoTen": "Nguyen Van A",
        "email": "nguyenvana@email.com"
      },
      "loaiDichVu": {
        "loaiDichVuId": 2,
        "tenLoai": "Web Development"
      },
      "giamSat": null,
      "kyNangs": [
        { "kyNangId": 1, "tenKyNang": "React" },
        { "kyNangId": 2, "tenKyNang": "TypeScript" }
      ]
    }
  ]
}
```

---

### GET /jobs/search

Search jobs with filters.

**Query Parameters:**

| Param | Required | Description |
|---|---|---|
| keyword | Optional | Search in title and description |
| category | Optional | Category ID (LoaiDichVuID) |
| budget | Optional | Budget amount (finds jobs where min <= budget <= max) |
| skills | Optional | Comma-separated skill IDs (e.g. "1,2,3") |

**Response:** Same format as GET /jobs.

---

### GET /jobs/:id

Get a single job by ID.

**Response (200):**

```json
{
  "job": { "...": "same as job object above" }
}
```

**Error Codes:**
- `404` - Job not found

---

### GET /jobs/:id/proposals

Get all proposals for a specific job.

**Response:** Same format as proposals list.

---

### GET /jobs/:id/skills

Get skills required for a job.

**Response (200):**

```json
{
  "message": "Lay danh sach ky nang thanh cong",
  "kyNangs": [
    { "kyNangId": 1, "tenKyNang": "React" },
    { "kyNangId": 2, "tenKyNang": "Node.js" }
  ]
}
```

---

### POST /jobs

Create a new job. **IMPORTANT: `nguoiThueId` is the TaiKhoanID of the creator.**

**Request Body:**

| Field | Required | Description |
|---|---|---|
| nguoiThueId | Yes | **TaiKhoanID** of the job creator (NOT NguoiThue table ID) |
| loaiDichVuId | Yes | Category ID |
| tieuDe | Yes | Job title |
| moTa | Yes | Job description |
| nganSachMin | Yes | Minimum budget (>= 0) |
| nganSachMax | Yes | Maximum budget (>= nganSachMin) |
| thoiHan | Yes | Deadline (ISO date string) |
| yeuCauGiamSat | Optional | Whether supervision is required (boolean) |
| giamSatId | Optional | Supervisor TaiKhoanID (auto-sets yeuCauGiamSat=true) |
| kyNangIds | Optional | Array of skill IDs required |

**Response (201):**

```json
{
  "message": "Tao yeu cau thanh cong",
  "job": { "...": "full job object with details" }
}
```

**Error Codes:**
- `400` - Invalid input / User not found / Category not found / Budget validation failed / Invalid skills

---

### PUT /jobs/:id

Update a job.

**Request Body:**

| Field | Required | Description |
|---|---|---|
| loaiDichVuId | Optional | Category ID |
| tieuDe | Optional | Job title |
| moTa | Optional | Job description |
| nganSachMin | Optional | Minimum budget |
| nganSachMax | Optional | Maximum budget |
| thoiHan | Optional | Deadline (ISO date string) |
| trangThai | Optional | Status: `MoDau`, `DangMo`, `DaDong`, `DaHuy`, `HoanThanh` |
| yeuCauGiamSat | Optional | Whether supervision is required |

**Response (200):**

```json
{
  "message": "Cap nhat yeu cau thanh cong",
  "job": { "...": "full job object" }
}
```

**Error Codes:**
- `400` - No valid fields / Invalid status / Budget validation
- `404` - Job not found

---

### PUT /jobs/:id/skills

Replace all skills for a job (bulk set).

**Request Body:**

| Field | Required | Description |
|---|---|---|
| kyNangIds | Yes | Array of skill IDs (empty array removes all) |

**Response (200):**

```json
{
  "message": "Cap nhat ky nang yeu cau thanh cong",
  "kyNangs": [
    { "kyNangId": 1, "tenKyNang": "React" }
  ]
}
```

**Error Codes:**
- `400` - Invalid skill IDs
- `404` - Job not found

---

### POST /jobs/:id/skills/:kyNangId

Add a single skill to a job.

**Response (200):**

```json
{
  "message": "Lay danh sach ky nang thanh cong",
  "kyNangs": [
    { "kyNangId": 1, "tenKyNang": "React" },
    { "kyNangId": 3, "tenKyNang": "Docker" }
  ]
}
```

**Error Codes:**
- `400` - Invalid skill ID
- `404` - Job not found

---

### DELETE /jobs/:id/skills/:kyNangId

Remove a single skill from a job.

**Response:** Same format as POST /jobs/:id/skills/:kyNangId.

---

### DELETE /jobs/:id

Soft-delete a job (sets status to `DaHuy`).

**Response (200):**

```json
{
  "message": "Xoa yeu cau thanh cong",
  "jobId": 1
}
```

**Error Codes:**
- `404` - Job not found

---

## 4. Proposals

### GET /proposals/:id

Get a single proposal by ID.

**Response (200):**

```json
{
  "proposal": {
    "baoGiaId": 1,
    "yeuCauId": 1,
    "freelancerId": 2,
    "giaDeXuat": "7000000",
    "thoiGianThucHien": 30,
    "noiDung": "I can build this in 30 days...",
    "trangThai": "DaGui",
    "ngayTao": "2025-01-16T00:00:00.000Z",
    "ngayCapNhat": "2025-01-16T00:00:00.000Z",
    "freelancer": {
      "freelancerId": 1,
      "taiKhoanId": 2,
      "hoTen": "Tran Van B",
      "email": "tranvanb@email.com",
      "kinhNghiem": 5,
      "kyNang": "React, Node.js",
      "kyNangs": [
        { "kyNangId": 1, "tenKyNang": "React" }
      ],
      "xepHang": "4.8"
    },
    "yeuCau": {
      "yeuCauId": 1,
      "tieuDe": "Build a React website",
      "nguoiThueId": 1
    }
  }
}
```

**Error Codes:**
- `404` - Proposal not found

---

### POST /proposals

Create a new proposal. **IMPORTANT: `freelancerId` is the TaiKhoanID of the freelancer.**

**Request Body:**

| Field | Required | Description |
|---|---|---|
| yeuCauId | Yes | Job ID to submit proposal for |
| freelancerId | Yes | **TaiKhoanID** of the freelancer (NOT Freelancer table ID) |
| giaDeXuat | Yes | Proposed price |
| thoiGianThucHien | Yes | Estimated days to complete |
| noiDung | Optional | Proposal description/cover letter |

**Response (201):**

```json
{
  "message": "Tao bao gia thanh cong",
  "proposal": { "...": "full proposal object with details" }
}
```

**Error Codes:**
- `400` - Invalid input / Job not found / Freelancer not found / Already submitted
- `404` - Job not found

---

### PUT /proposals/:id

Update a proposal.

**Request Body:**

| Field | Required | Description |
|---|---|---|
| giaDeXuat | Optional | Updated price |
| thoiGianThucHien | Optional | Updated timeline (days) |
| noiDung | Optional | Updated description |
| trangThai | Optional | Status: `DaGui`, `DuocChon`, `TuChoi`, `RutLai` |

**Response (200):**

```json
{
  "message": "Cap nhat bao gia thanh cong",
  "proposal": { "...": "full proposal object" }
}
```

**Error Codes:**
- `400` - No valid fields to update
- `404` - Proposal not found

---

### DELETE /proposals/:id

Delete a proposal.

**Response (200):**

```json
{
  "message": "Xoa bao gia thanh cong",
  "proposalId": 1
}
```

**Error Codes:**
- `404` - Proposal not found

---

## 5. Contracts

### GET /contracts

Get all contracts.

**Response (200):**

```json
{
  "total": 2,
  "contracts": [
    {
      "congViecId": 1,
      "yeuCauId": 1,
      "freelancerId": 2,
      "nguoiThueId": 1,
      "giaThoa": "7000000",
      "thoiGianThoa": 30,
      "trangThai": "DangThucHien",
      "ngayBatDau": "2025-01-20T00:00:00.000Z",
      "ngayKetThuc": null,
      "giamSatId": null,
      "trangThaiGiamSat": "KhongCo",
      "phiGiamSat": "0",
      "ngayTao": "2025-01-20T00:00:00.000Z",
      "yeuCau": {
        "yeuCauId": 1,
        "tieuDe": "Build a React website",
        "moTa": "Need a responsive website..."
      },
      "freelancer": {
        "freelancerId": 2,
        "taiKhoanId": 2,
        "hoTen": "Tran Van B",
        "email": "tranvanb@email.com"
      },
      "nguoiThue": {
        "nguoiThueId": 1,
        "taiKhoanId": 1,
        "hoTen": "Nguyen Van A",
        "email": "nguyenvana@email.com"
      },
      "giamSat": null
    }
  ]
}
```

**Note:** `freelancerId` and `nguoiThueId` in the contract ARE TaiKhoanIDs.

---

### GET /contracts/:id

Get a single contract.

**Response:** Same as single contract object wrapped in `{ "contract": {...} }`.

**Error Codes:**
- `404` - Contract not found

---

### GET /contracts/:id/detail

Get contract with full details (same as GET /contracts/:id but may include more nested data).

**Response:** Same format as GET /contracts/:id.

---

### GET /contracts/:id/progress

Get all progress reports for a contract.

**Response:** Same format as progress list.

---

### GET /contracts/:id/conversations

Get all chat conversations for a contract.

**Response:** Same format as conversation list.

---

### POST /contracts

Create a contract manually.

**Request Body:**

| Field | Required | Description |
|---|---|---|
| yeuCauId | Yes | Job ID |
| freelancerId | Yes | Freelancer's **TaiKhoanID** |
| nguoiThueId | Yes | Client's **TaiKhoanID** |
| giaThoa | Yes | Agreed price |
| thoiGianThoa | Yes | Agreed timeline (days) |

**Response (201):**

```json
{
  "message": "Tao hop dong thanh cong",
  "contract": { "...": "full contract object" }
}
```

**Error Codes:**
- `400` - Invalid input / Users not found

---

### PUT /contracts/:id/status

Update contract status.

**Request Body:**

| Field | Required | Description |
|---|---|---|
| trangThai | Yes | Status: `ChoXacNhan`, `DangThucHien`, `HoanThanh`, `DaHuy`, `TranhChap` |

**Response (200):**

```json
{
  "message": "Cap nhat trang thai thanh cong",
  "contract": { "...": "full contract object" }
}
```

**Error Codes:**
- `400` - Invalid status
- `404` - Contract not found

---

### POST /contracts/:id/supervisor

Select a supervisor for a contract.

**Request Body:**

| Field | Required | Description |
|---|---|---|
| giamSatId | Yes | Supervisor's **TaiKhoanID** |
| phiGiamSat | Yes | Supervision fee amount |

**Response (200):**

```json
{
  "message": "Chon giam sat thanh cong",
  "yeuCauGiamSatId": 1,
  "trangThai": "ChoDuyet"
}
```

**Error Codes:**
- `400` - Supervisor not found / Contract already has supervisor
- `404` - Contract not found

---

### PUT /contracts/:id/supervisor/accept

Supervisor accepts the supervision request.

**Response (200):**

```json
{
  "message": "Giam sat da chap nhan",
  "yeuCauGiamSatId": 1,
  "trangThai": "DaDuyet"
}
```

---

### PUT /contracts/:id/supervisor/reject

Supervisor rejects the supervision request.

**Response (200):**

```json
{
  "message": "Giam sat da tu choi",
  "yeuCauGiamSatId": 1,
  "trangThai": "TuChoi"
}
```

---

## 6. Contract Flow

This section describes the complete flow from accepting a proposal to completing a contract with escrow payment.

### Flow Overview

1. **Client accepts proposal** -> Contract created + Escrow payment held
2. **Work is done** -> Progress reports submitted
3. **Confirm completion** -> Each party confirms (Freelancer -> Supervisor -> Client)
4. **All confirmed** -> Escrow released (Freelancer gets 95%, System takes 5% fee)

---

### POST /contracts/accept-proposal

Accept a proposal and create a contract with escrow payment.

**What happens internally:**
1. Creates a contract (CongViec) with status `DangThucHien`
2. Creates an escrow payment (100% agreed price + supervisor fee)
3. Updates the accepted proposal status to `DuocChon`
4. Rejects all other proposals for the same job (`TuChoi`)
5. Closes the job (status -> `DaDong`)

**Request Body:**

| Field | Required | Description |
|---|---|---|
| baoGiaId | Yes | Proposal ID to accept |
| nguoiThueId | Yes | Client's **TaiKhoanID** (must own the job) |
| giamSatId | Optional | Supervisor's TaiKhoanID (if supervision needed) |
| phiGiamSat | Optional | Supervisor fee (default: 0) |

**Response (200):**

```json
{
  "message": "Chap nhan bao gia thanh cong. Tien da duoc giu boi he thong (escrow).",
  "congViecId": 1,
  "escrow": {
    "giaThoa": "7000000",
    "phiGiamSat": "500000",
    "tongThanhToan": "7500000",
    "thanhToanId": 1
  }
}
```

**Error Codes:**
- `400` - Proposal already processed / User doesn't own the job / Invalid user
- `404` - Proposal not found

---

### PUT /contracts/:id/confirm-completion

Confirm contract completion (called by each party separately).

**Confirmation Order:**
1. Freelancer confirms first
2. Supervisor confirms (if contract has supervisor)
3. Client confirms last -> triggers payment release

**Request Body:**

| Field | Required | Description |
|---|---|---|
| role | Yes | Who is confirming: `Freelancer`, `GiamSat`, or `NguoiThue` |
| userId | Yes | **TaiKhoanID** of the person confirming |

**Response (200) - Partial confirmation:**

```json
{
  "message": "Freelancer da xac nhan hoan thanh.",
  "congViecId": 1,
  "freelancerXacNhan": true,
  "giamSatXacNhan": false,
  "nguoiThueXacNhan": false,
  "released": false
}
```

**Response (200) - All confirmed (payment released):**

```json
{
  "message": "Tat ca cac ben da xac nhan. Tien da duoc giai ngan.",
  "congViecId": 1,
  "freelancerXacNhan": true,
  "giamSatXacNhan": true,
  "nguoiThueXacNhan": true,
  "released": true,
  "disbursement": {
    "freelancerNhan": "6650000",
    "giamSatNhan": "500000",
    "phiHeThong": "350000"
  }
}
```

**Payment Release Logic:**
- Freelancer receives: `giaThoa - (giaThoa * 5%)` = 95% of agreed price
- Supervisor receives: `phiGiamSat` (full amount)
- System fee: `giaThoa * 5%`
- Contract status changes to `HoanThanh`
- Job status changes to `HoanThanh`

**Error Codes:**
- `400` - Wrong role/userId / Already confirmed / Prerequisites not met / No escrow
- `404` - Contract not found

---

## 7. Progress

### GET /progress/:id

Get a single progress report.

**Response (200):**

```json
{
  "progress": {
    "tienDoId": 1,
    "congViecId": 1,
    "freelancerId": 2,
    "tieuDe": "Completed homepage design",
    "moTa": "Finished the responsive layout",
    "phanTram": 30,
    "tepDinhKem": "https://example.com/file.pdf",
    "xacNhanBoi": null,
    "trangThaiXacNhan": "ChoXacNhan",
    "ngayTao": "2025-01-25T00:00:00.000Z",
    "congViec": {
      "congViecId": 1,
      "yeuCauId": 1,
      "giaThoa": "7000000"
    },
    "freelancer": {
      "freelancerId": 2,
      "taiKhoanId": 2,
      "hoTen": "Tran Van B",
      "email": "tranvanb@email.com"
    },
    "donViGiamSat": null
  }
}
```

**Error Codes:**
- `404` - Progress report not found

---

### POST /progress

Create a progress report.

**Request Body:**

| Field | Required | Description |
|---|---|---|
| congViecId | Yes | Contract ID |
| freelancerId | Yes | Freelancer's **TaiKhoanID** |
| tieuDe | Yes | Progress title |
| moTa | Optional | Description |
| phanTram | Yes | Completion percentage (0-100) |
| tepDinhKem | Optional | Attachment URL |

**Response (201):**

```json
{
  "message": "Tao tien do thanh cong",
  "progress": { "...": "full progress object" }
}
```

**Error Codes:**
- `400` - Invalid input / Contract not found / Freelancer mismatch

---

### PUT /progress/:id

Update a progress report.

**Request Body:**

| Field | Required | Description |
|---|---|---|
| tieuDe | Optional | Title |
| moTa | Optional | Description |
| phanTram | Optional | Percentage (0-100) |
| tepDinhKem | Optional | Attachment URL |
| trangThaiXacNhan | Optional | Status: `ChoXacNhan`, `DaXacNhan`, `TuChoi` |

**Response (200):**

```json
{
  "message": "Cap nhat tien do thanh cong",
  "progress": { "...": "full progress object" }
}
```

**Error Codes:**
- `400` - No valid fields
- `404` - Progress not found

---

### DELETE /progress/:id

Delete a progress report.

**Response (200):**

```json
{
  "message": "Xoa tien do thanh cong",
  "progressId": 1
}
```

**Error Codes:**
- `404` - Progress not found

---

## 8. Freelancers

### GET /freelancers/:id/proposals

Get all proposals submitted by a freelancer (by TaiKhoanID).

**Response:** Same format as proposals list.

---

### GET /freelancers/:id/skills

Get skills of a freelancer.

**Response (200):**

```json
{
  "message": "Lay danh sach ky nang thanh cong",
  "freelancerId": 2,
  "kyNangs": [
    { "kyNangId": 1, "tenKyNang": "React" },
    { "kyNangId": 2, "tenKyNang": "Node.js" }
  ]
}
```

---

### PUT /freelancers/:id/skills

Replace all skills for a freelancer (bulk set).

**Request Body:**

| Field | Required | Description |
|---|---|---|
| kyNangIds | Yes | Array of skill IDs |

**Response:** Same format as GET /freelancers/:id/skills.

---

### POST /freelancers/:id/skills/:kyNangId

Add a single skill to a freelancer.

**Response:** Same format as skills response.

---

### DELETE /freelancers/:id/skills/:kyNangId

Remove a single skill from a freelancer.

**Response:** Same format as skills response.

---

## 9. Skills

### GET /skills

Get all skills.

**Response (200):**

```json
{
  "total": 10,
  "skills": [
    { "kyNangId": 1, "tenKyNang": "React", "moTa": "React.js framework" },
    { "kyNangId": 2, "tenKyNang": "Node.js", "moTa": "Server-side JavaScript" }
  ]
}
```

---

### GET /skills/:id

Get a single skill.

**Response (200):**

```json
{
  "skill": { "kyNangId": 1, "tenKyNang": "React", "moTa": "React.js framework" }
}
```

**Error Codes:**
- `404` - Skill not found

---

### POST /skills

Create a new skill.

**Request Body:**

| Field | Required | Description |
|---|---|---|
| tenKyNang | Yes | Skill name |
| moTa | Optional | Description |

**Response (201):**

```json
{
  "message": "Tao ky nang thanh cong",
  "skill": { "kyNangId": 3, "tenKyNang": "Docker", "moTa": "Containerization" }
}
```

**Error Codes:**
- `400` - Missing name / Skill already exists

---

### PUT /skills/:id

Update a skill.

**Request Body:**

| Field | Required | Description |
|---|---|---|
| tenKyNang | Optional | Skill name |
| moTa | Optional | Description |

**Response (200):**

```json
{
  "message": "Cap nhat ky nang thanh cong",
  "skill": { "kyNangId": 1, "tenKyNang": "React.js", "moTa": "Updated description" }
}
```

**Error Codes:**
- `404` - Skill not found

---

### DELETE /skills/:id

Delete a skill.

**Response (200):**

```json
{
  "message": "Xoa ky nang thanh cong",
  "skillId": 1
}
```

**Error Codes:**
- `404` - Skill not found

---

## 10. Categories

### GET /categories

Get all service categories.

**Response (200):**

```json
{
  "total": 5,
  "categories": [
    { "loaiDichVuId": 1, "tenLoai": "Web Development", "moTa": "Website building" },
    { "loaiDichVuId": 2, "tenLoai": "Mobile App", "moTa": "iOS and Android apps" }
  ]
}
```

---

### GET /categories/:id

Get a single category.

**Response (200):**

```json
{
  "category": { "loaiDichVuId": 1, "tenLoai": "Web Development", "moTa": "Website building" }
}
```

**Error Codes:**
- `404` - Category not found

---

### POST /categories

Create a new category.

**Request Body:**

| Field | Required | Description |
|---|---|---|
| tenLoai | Yes | Category name |
| moTa | Optional | Description |

**Response (201):**

```json
{
  "message": "Tao loai dich vu thanh cong",
  "category": { "loaiDichVuId": 6, "tenLoai": "AI/ML", "moTa": "Machine learning services" }
}
```

**Error Codes:**
- `400` - Missing name / Already exists

---

### PUT /categories/:id

Update a category.

**Request Body:**

| Field | Required | Description |
|---|---|---|
| tenLoai | Optional | Category name |
| moTa | Optional | Description |

**Response (200):**

```json
{
  "message": "Cap nhat loai dich vu thanh cong",
  "category": { "loaiDichVuId": 1, "tenLoai": "Full-Stack Web", "moTa": "Updated" }
}
```

**Error Codes:**
- `404` - Category not found

---

### DELETE /categories/:id

Delete a category.

**Response (200):**

```json
{
  "message": "Xoa loai dich vu thanh cong",
  "categoryId": 1
}
```

**Error Codes:**
- `404` - Category not found

---

## 11. Supervisors

### GET /supervisors

Get all supervisors.

**Response (200):**

```json
{
  "total": 2,
  "supervisors": [
    {
      "giamSatId": 1,
      "taiKhoanId": 5,
      "tenDonVi": "QA Solutions",
      "moTa": "Professional QA services",
      "nangLuc": "Software testing, Code review",
      "chungChi": "ISTQB Certified",
      "phiGiamSat": "500000",
      "xepHang": "4.5",
      "tongCongViecGS": 10,
      "trangThai": "HoatDong",
      "ngayDangKy": "2025-01-01T00:00:00.000Z",
      "taiKhoan": {
        "taiKhoanId": 5,
        "hoTen": "Le Van E",
        "email": "levane@email.com",
        "soDienThoai": "0905555555"
      }
    }
  ]
}
```

---

### GET /supervisors/search?keyword=QA

Search supervisors by keyword.

**Query Parameters:**

| Param | Required | Description |
|---|---|---|
| keyword | Optional | Search in name/description |

**Response:** Same format as GET /supervisors.

---

### GET /supervisors/:id

Get a single supervisor.

**Response (200):**

```json
{
  "supervisor": { "...": "same as supervisor object above" }
}
```

**Error Codes:**
- `404` - Supervisor not found

---

### POST /supervisors

Create/register a supervisor profile.

**Request Body:**

| Field | Required | Description |
|---|---|---|
| taiKhoanId | Yes | **TaiKhoanID** of the user |
| tenDonVi | Yes | Organization/unit name |
| moTa | Optional | Description |
| nangLuc | Optional | Capabilities |
| chungChi | Optional | Certifications |
| phiGiamSat | Yes | Supervision fee |

**Response (201):**

```json
{
  "message": "Tao don vi giam sat thanh cong",
  "supervisor": { "...": "full supervisor object" }
}
```

**Error Codes:**
- `400` - User not found / Already registered

---

### PUT /supervisors/:id

Update supervisor profile.

**Request Body:**

| Field | Required | Description |
|---|---|---|
| tenDonVi | Optional | Organization name |
| moTa | Optional | Description |
| nangLuc | Optional | Capabilities |
| chungChi | Optional | Certifications |
| phiGiamSat | Optional | Fee |
| trangThai | Optional | Status: `HoatDong`, `TamNgung`, `ChoDuyet` |

**Response (200):**

```json
{
  "message": "Cap nhat don vi giam sat thanh cong",
  "supervisor": { "...": "full supervisor object" }
}
```

**Error Codes:**
- `404` - Supervisor not found

---

### DELETE /supervisors/:id

Delete a supervisor profile.

**Response (200):**

```json
{
  "message": "Xoa don vi giam sat thanh cong",
  "supervisorId": 1
}
```

**Error Codes:**
- `404` - Supervisor not found

---

## 12. Chat

### POST /chat

Create a new conversation.

**Request Body:**

| Field | Required | Description |
|---|---|---|
| thanhVien1Id | Yes | First member's **TaiKhoanID** |
| thanhVien2Id | Yes | Second member's **TaiKhoanID** |
| congViecId | Optional | Associated contract ID |

**Response (201):**

```json
{
  "message": "Tao cuoc hoi thoai thanh cong",
  "conversation": {
    "cuocHoiThoaiId": 1,
    "congViecId": 1,
    "thanhVien1": {
      "taiKhoanId": 1,
      "hoTen": "Nguyen Van A",
      "email": "nguyenvana@email.com"
    },
    "thanhVien2": {
      "taiKhoanId": 2,
      "hoTen": "Tran Van B",
      "email": "tranvanb@email.com"
    },
    "tinNhanCuoi": null,
    "trangThai": "MoiTao",
    "ngayTao": "2025-01-20T00:00:00.000Z"
  }
}
```

**Error Codes:**
- `400` - Users not found / Same user / Conversation already exists

---

### GET /chat/:id

Get a conversation by ID.

**Response (200):**

```json
{
  "conversation": { "...": "same as conversation object above" }
}
```

**Error Codes:**
- `404` - Conversation not found

---

### PUT /chat/:id/close

Close a conversation.

**Response (200):**

```json
{
  "message": "Dong cuoc hoi thoai thanh cong",
  "conversation": { "...": "conversation with trangThai: DaDong" }
}
```

---

### GET /chat/:id/messages

Get all messages in a conversation.

**Response (200):**

```json
{
  "total": 5,
  "messages": [
    {
      "tinNhanId": 1,
      "cuocHoiThoaiId": 1,
      "nguoiGui": {
        "taiKhoanId": 1,
        "hoTen": "Nguyen Van A",
        "email": "nguyenvana@email.com"
      },
      "noiDung": "Hello, I want to discuss the project",
      "loaiTin": "VanBan",
      "daDoc": true,
      "ngayTao": "2025-01-20T10:00:00.000Z"
    }
  ]
}
```

---

### POST /chat/:id/messages

Send a message in a conversation.

**Request Body:**

| Field | Required | Description |
|---|---|---|
| nguoiGuiId | Yes | Sender's **TaiKhoanID** |
| noiDung | Yes | Message content |
| loaiTin | Optional | Message type: `VanBan`, `HinhAnh`, `TepTin` (default: `VanBan`) |

**Note:** `cuocHoiThoaiId` is taken from the URL parameter.

**Response (201):**

```json
{
  "message": "Gui tin nhan thanh cong",
  "data": {
    "tinNhanId": 6,
    "cuocHoiThoaiId": 1,
    "nguoiGui": {
      "taiKhoanId": 1,
      "hoTen": "Nguyen Van A",
      "email": "nguyenvana@email.com"
    },
    "noiDung": "Hello!",
    "loaiTin": "VanBan",
    "daDoc": false,
    "ngayTao": "2025-01-20T10:05:00.000Z"
  }
}
```

**Error Codes:**
- `400` - Empty content / Sender not in conversation
- `404` - Conversation not found

---

### PUT /chat/:id/read/:userId

Mark all messages as read for a user in a conversation.

**Response (200):**

```json
{
  "message": "Da doc tin nhan",
  "count": 3
}
```

---

## 13. WebSocket Chat Gateway

The chat system also supports real-time messaging via WebSocket using Socket.IO.

### Connection

**Namespace:** `/chat`

**Connection URL:** `ws://localhost:3000/chat?userId=<TaiKhoanID>`

```javascript
import { io } from 'socket.io-client';

const socket = io('http://localhost:3000/chat', {
  query: { userId: '1' }  // Your TaiKhoanID
});
```

### Client Events (Emit)

#### `joinConversation`

Join a conversation room to receive real-time messages.

```javascript
socket.emit('joinConversation', { cuocHoiThoaiId: 1 });
```

#### `leaveConversation`

Leave a conversation room.

```javascript
socket.emit('leaveConversation', { cuocHoiThoaiId: 1 });
```

#### `sendMessage`

Send a message via WebSocket (saves to DB and broadcasts).

```javascript
socket.emit('sendMessage', {
  cuocHoiThoaiId: 1,
  nguoiGuiId: 1,
  noiDung: 'Hello from WebSocket!',
  loaiTin: 'VanBan'  // Optional, default: 'VanBan'
});
```

#### `markAsRead`

Mark messages as read in a conversation.

```javascript
socket.emit('markAsRead', {
  cuocHoiThoaiId: 1,
  userId: 1
});
```

#### `typing`

Send typing indicator.

```javascript
socket.emit('typing', {
  cuocHoiThoaiId: 1,
  userId: 1,
  isTyping: true
});
```

### Server Events (Listen)

#### `newMessage`

Received when a new message is sent in a joined conversation room.

```javascript
socket.on('newMessage', (data) => {
  // data = MessageDto object
  console.log(data);
  // {
  //   tinNhanId: 7,
  //   cuocHoiThoaiId: 1,
  //   nguoiGui: { taiKhoanId: 2, hoTen: "Tran Van B", email: "..." },
  //   noiDung: "Hi there!",
  //   loaiTin: "VanBan",
  //   daDoc: false,
  //   ngayTao: "2025-01-20T10:10:00.000Z"
  // }
});
```

#### `messageNotification`

Received when you get a message but are NOT in the conversation room (for unread badges).

```javascript
socket.on('messageNotification', (data) => {
  // data = { cuocHoiThoaiId: 1, message: MessageDto }
});
```

#### `messagesRead`

Received when someone reads messages in a conversation you're in.

```javascript
socket.on('messagesRead', (data) => {
  // data = { cuocHoiThoaiId: 1, userId: 2, count: 3 }
});
```

#### `userTyping`

Received when another user is typing in a conversation.

```javascript
socket.on('userTyping', (data) => {
  // data = { cuocHoiThoaiId: 1, userId: 2, isTyping: true }
});
```

#### `error`

Received when a WebSocket operation fails.

```javascript
socket.on('error', (data) => {
  // data = { message: "Failed to send message" }
});
```

---

## 14. Recommendations

### GET /recommendations/freelancers/:yeuCauId

Get recommended freelancers for a specific job (based on skill matching).

**Response (200):**

```json
{
  "yeuCauId": 1,
  "recommendations": [
    {
      "taiKhoanId": 2,
      "hoTen": "Tran Van B",
      "email": "tranvanb@email.com",
      "kinhNghiem": 5,
      "xepHang": "4.8",
      "matchingSkills": [
        { "kyNangId": 1, "tenKyNang": "React" }
      ],
      "matchScore": 0.85
    }
  ]
}
```

**Error Codes:**
- `404` - Job not found

---

### GET /recommendations/supervisors

Get recommended supervisors (active, sorted by rating).

**Response (200):**

```json
{
  "recommendations": [
    {
      "giamSatId": 1,
      "taiKhoanId": 5,
      "tenDonVi": "QA Solutions",
      "phiGiamSat": "500000",
      "xepHang": "4.5",
      "tongCongViecGS": 10,
      "trangThai": "HoatDong"
    }
  ]
}
```

---

## 15. Payments

### POST /payments/deposit

Create an escrow deposit payment for a contract.

**Request Body:**

| Field | Required | Description |
|---|---|---|
| contractId | Yes | Contract ID (CongViecID) |
| amount | Yes | Deposit amount |
| paymentMethod | Yes | Method: `Vi`, `NganHang`, `MoMo`, `VNPay` |
| note | Optional | Payment note |

**Response (201):**

```json
{
  "message": "Dat coc thanh cong",
  "payment": {
    "thanhToanId": 1,
    "congViecId": 1,
    "nguoiThueId": 1,
    "soTien": "7000000",
    "loaiTT": "DatCoc",
    "phuongThuc": "Vi",
    "trangThai": "ThanhCong",
    "ghiChu": "Escrow deposit",
    "ngayTao": "2025-01-20T00:00:00.000Z"
  }
}
```

**Error Codes:**
- `400` - Invalid amount / Contract not found
- `404` - Contract not found

---

### GET /payments/:id

Get a single payment by ID.

**Response (200):**

```json
{
  "payment": { "...": "same as payment object above" }
}
```

**Error Codes:**
- `404` - Payment not found

---

### GET /contracts/:id/payments

Get all payments for a contract.

**Response (200):**

```json
{
  "total": 3,
  "payments": [
    { "...": "payment objects" }
  ]
}
```

---

### PUT /payments/:id/release

Release an escrow payment (admin/system action).

**Response (200):**

```json
{
  "message": "Giai ngan thanh cong",
  "payment": { "...": "payment with trangThai: ThanhCong" }
}
```

**Error Codes:**
- `400` - Payment not in releasable state
- `404` - Payment not found

---

### PUT /payments/:id/refund

Refund a payment.

**Response (200):**

```json
{
  "message": "Hoan tien thanh cong",
  "payment": { "...": "payment with trangThai: DaHoan" }
}
```

**Error Codes:**
- `400` - Payment not refundable
- `404` - Payment not found

---

## 16. Disputes

### POST /disputes

Create a dispute for a contract.

**Request Body:**

| Field | Required | Description |
|---|---|---|
| congViecId | Yes | Contract ID |
| nguoiGuiId | Yes | Reporter's **TaiKhoanID** |
| lyDo | Yes | Reason for dispute |
| moTa | Optional | Detailed description |
| yeuCauHoanTien | Yes | Requested refund amount |

**Response (201):**

```json
{
  "message": "Tao tranh chap thanh cong",
  "dispute": {
    "tranhChapId": 1,
    "congViecId": 1,
    "nguoiGuiId": 1,
    "giamSatId": null,
    "lyDo": "Work not delivered on time",
    "moTa": "Freelancer missed the deadline by 2 weeks",
    "trangThai": "DangMo",
    "yeuCauHoanTien": "3000000",
    "ngayMo": "2025-02-15T00:00:00.000Z",
    "ngayDong": null
  }
}
```

**Error Codes:**
- `400` - Contract not found / Already has open dispute
- `404` - Contract not found

---

### GET /disputes/:id

Get a single dispute.

**Response (200):**

```json
{
  "dispute": { "...": "same as dispute object" }
}
```

**Error Codes:**
- `404` - Dispute not found

---

### GET /contracts/:id/disputes

Get all disputes for a contract.

**Response (200):**

```json
{
  "total": 1,
  "disputes": [ { "...": "dispute objects" } ]
}
```

---

### PUT /disputes/:id/review

Assign a supervisor to review the dispute.

**Request Body:**

| Field | Required | Description |
|---|---|---|
| giamSatId | Yes | Supervisor's **TaiKhoanID** |

**Response (200):**

```json
{
  "message": "Giam sat da nhan xem xet tranh chap",
  "dispute": { "...": "dispute with giamSatId set, trangThai: DangXemXet" }
}
```

**Error Codes:**
- `400` - Supervisor not found / Dispute not in reviewable state
- `404` - Dispute not found

---

### PUT /disputes/:id/resolve

Resolve a dispute (by supervisor).

**Request Body:**

| Field | Required | Description |
|---|---|---|
| giamSatId | Yes | Supervisor's **TaiKhoanID** (must be assigned reviewer) |
| ketQua | Yes | Result: `HoanTienDayDu`, `HoanTienMotPhan`, `KhongHoanTien` |
| lyDo | Yes | Resolution reason |
| soTienHoan | Yes | Refund amount |
| benChiuPhi | Yes | Who pays fees: `NguoiThue`, `Freelancer`, `ChiaDeu` |

**Response (200):**

```json
{
  "message": "Giai quyet tranh chap thanh cong",
  "dispute": { "...": "dispute with trangThai: DaGiaiQuyet, ngayDong set" }
}
```

**Error Codes:**
- `400` - Not the assigned supervisor / Invalid state
- `404` - Dispute not found

---

## 17. Evidences

### POST /disputes/:id/evidences

Submit evidence for a dispute.

**Request Body:**

| Field | Required | Description |
|---|---|---|
| nguoiNopId | Yes | Submitter's **TaiKhoanID** |
| loaiBangChung | Yes | Type: `VanBan`, `HinhAnh`, `Video`, `TepTin`, `Khac` |
| noiDung | Optional | Text content/description |
| duongDanFile | Optional | File URL |

**Response (201):**

```json
{
  "message": "Nop bang chung thanh cong",
  "evidence": {
    "bangChungId": 1,
    "tranhChapId": 1,
    "nguoiNopId": 1,
    "loaiBangChung": "HinhAnh",
    "noiDung": "Screenshot of conversation",
    "duongDanFile": "https://example.com/evidence.png",
    "ngayNop": "2025-02-16T00:00:00.000Z"
  }
}
```

**Error Codes:**
- `400` - Dispute not open / User not involved
- `404` - Dispute not found

---

### GET /disputes/:id/evidences

Get all evidences for a dispute.

**Response (200):**

```json
{
  "total": 2,
  "evidences": [ { "...": "evidence objects" } ]
}
```

---

### DELETE /evidences/:id

Delete an evidence submission.

**Response (200):**

```json
{
  "message": "Xoa bang chung thanh cong",
  "evidence": null
}
```

**Error Codes:**
- `404` - Evidence not found

---

## 18. Reviews

### POST /reviews

Create a review for a completed contract.

**Request Body:**

| Field | Required | Description |
|---|---|---|
| congViecId | Yes | Contract ID (must be completed) |
| nguoiDanhGiaId | Yes | Reviewer's **TaiKhoanID** |
| nguoiDuocDGId | Yes | Reviewed person's **TaiKhoanID** |
| diemSo | Yes | Rating score (1-5) |
| binhLuan | Optional | Review comment |
| loaiDanhGia | Yes | Type: `NguoiThue_DanhGia_Freelancer`, `Freelancer_DanhGia_NguoiThue`, `GiamSat_DanhGia` |

**Response (201):**

```json
{
  "message": "Tao danh gia thanh cong",
  "review": {
    "danhGiaId": 1,
    "congViecId": 1,
    "nguoiDanhGiaId": 1,
    "nguoiDuocDGId": 2,
    "diemSo": 5,
    "binhLuan": "Excellent work, delivered on time!",
    "loaiDanhGia": "NguoiThue_DanhGia_Freelancer",
    "ngayTao": "2025-02-20T00:00:00.000Z"
  }
}
```

**Error Codes:**
- `400` - Contract not completed / Already reviewed / Invalid score
- `404` - Contract not found

---

### GET /reviews/:id

Get a single review.

**Response (200):**

```json
{
  "review": { "...": "same as review object" }
}
```

**Error Codes:**
- `404` - Review not found

---

### GET /users/:id/reviews

Get all reviews for a user (received reviews).

**Response (200):**

```json
{
  "total": 5,
  "reviews": [ { "...": "review objects" } ]
}
```

---

### GET /contracts/:id/reviews

Get all reviews for a contract.

**Response:** Same format as review list.

---

## 19. Notifications

### GET /notifications?userId=1

Get all notifications for a user.

**Query Parameters:**

| Param | Required | Description |
|---|---|---|
| userId | Yes | User's **TaiKhoanID** |

**Response (200):**

```json
{
  "total": 3,
  "notifications": [
    {
      "thongBaoId": 1,
      "taiKhoanId": 1,
      "tieuDe": "New proposal received",
      "noiDung": "You have a new proposal for your job",
      "loaiThongBao": "BaoGiaMoi",
      "daDoc": false,
      "ngayTao": "2025-01-16T00:00:00.000Z"
    }
  ]
}
```

---

### PUT /notifications/:id/read

Mark a notification as read.

**Response (200):**

```json
{
  "message": "Da doc thong bao",
  "notification": { "...": "notification with daDoc: true" }
}
```

**Error Codes:**
- `404` - Notification not found

---

### DELETE /notifications/:id

Delete a notification.

**Response (200):**

```json
{
  "message": "Xoa thong bao thanh cong"
}
```

**Error Codes:**
- `404` - Notification not found

---

## 20. Reports

### POST /reports

Create a user report (report another user for misconduct).

**Request Body:**

| Field | Required | Description |
|---|---|---|
| nguoiBaoCaoId | Yes | Reporter's **TaiKhoanID** |
| nguoiBiCaoId | Yes | Reported user's **TaiKhoanID** |
| lyDo | Yes | Reason for report |
| moTa | Optional | Detailed description |

**Response (201):**

```json
{
  "message": "Tao bao cao thanh cong",
  "report": {
    "baoCaoId": 1,
    "nguoiBaoCaoId": 1,
    "nguoiBiCaoId": 3,
    "lyDo": "Spam messages",
    "moTa": "User keeps sending unsolicited messages",
    "trangThai": "ChoXuLy",
    "ketQua": null,
    "adminXuLyId": null,
    "ngayTao": "2025-02-01T00:00:00.000Z",
    "ngayXuLy": null
  }
}
```

**Error Codes:**
- `400` - Cannot report yourself / Users not found

---

### GET /reports

Get all reports (admin endpoint).

**Response (200):**

```json
{
  "total": 5,
  "reports": [ { "...": "report objects" } ]
}
```

---

### PUT /reports/:id/resolve

Resolve a report (admin action).

**Request Body:**

| Field | Required | Description |
|---|---|---|
| adminId | Yes | Admin's **TaiKhoanID** |
| trangThai | Yes | Status: `DaXuLy`, `TuChoi` |
| ketQua | Yes | Resolution result description |

**Response (200):**

```json
{
  "message": "Xu ly bao cao thanh cong",
  "report": { "...": "report with trangThai updated, adminXuLyId set, ngayXuLy set" }
}
```

**Error Codes:**
- `400` - Invalid status / Admin not found
- `404` - Report not found

---

## 21. Admin

### GET /admin/users

Get all users (admin view with management info).

**Response (200):**

```json
{
  "total": 10,
  "users": [
    {
      "taiKhoanId": 1,
      "tenDangNhap": "nguyenvana",
      "email": "nguyenvana@email.com",
      "hoTen": "Nguyen Van A",
      "vaiTro": "NguoiThue",
      "trangThai": "HoatDong",
      "ngayTao": "2025-01-01T00:00:00.000Z"
    }
  ]
}
```

---

### PUT /admin/users/:id/ban

Ban a user account.

**Response (200):**

```json
{
  "message": "Da khoa tai khoan"
}
```

**Error Codes:**
- `404` - User not found

---

### GET /admin/supervisors

Get all supervisors (admin view).

**Response (200):**

```json
{
  "total": 3,
  "supervisors": [
    {
      "giamSatId": 1,
      "taiKhoanId": 5,
      "tenDonVi": "QA Solutions",
      "phiGiamSat": "500000",
      "trangThai": "ChoDuyet",
      "ngayDangKy": "2025-01-01T00:00:00.000Z",
      "hoTen": "Le Van E",
      "email": "levane@email.com"
    }
  ]
}
```

---

### PUT /admin/supervisors/:id/approve

Approve a supervisor registration.

**Response (200):**

```json
{
  "message": "Da duyet don vi giam sat"
}
```

**Error Codes:**
- `404` - Supervisor not found

---

### GET /admin/statistics

Get platform statistics.

**Response (200):**

```json
{
  "statistics": {
    "totalUsers": 150,
    "totalContracts": 45,
    "activeContracts": 12,
    "pendingDisputes": 3,
    "pendingReports": 5
  }
}
```

---

## Enum Reference

### User Roles (VaiTroTaiKhoan)
- `NguoiThue` - Client/Employer
- `Freelancer` - Freelancer
- `DonViGiamSat` - Supervisor
- `Admin` - Administrator
- `KhachVangLai` - Guest

### Account Status (TrangThaiTaiKhoan)
- `HoatDong` - Active
- `Khoa` - Banned/Locked

### Job Status (TrangThaiYeuCau)
- `MoDau` - Draft
- `DangMo` - Open (accepting proposals)
- `DaDong` - Closed (contract created)
- `DaHuy` - Cancelled
- `HoanThanh` - Completed

### Proposal Status (TrangThaiBaoGia)
- `DaGui` - Submitted
- `DuocChon` - Accepted/Selected
- `TuChoi` - Rejected
- `RutLai` - Withdrawn

### Contract Status (TrangThaiCongViec)
- `ChoXacNhan` - Pending confirmation
- `DangThucHien` - In progress
- `HoanThanh` - Completed
- `DaHuy` - Cancelled
- `TranhChap` - In dispute

### Supervisor Status (TrangThaiGiamSatCongViec)
- `KhongCo` - No supervisor
- `ChoDuyet` - Pending approval
- `DaDuyet` - Approved
- `TuChoi` - Rejected

### Payment Type (LoaiThanhToan)
- `DatCoc` - Escrow deposit
- `ThanhToanCuoi` - Final payment (to freelancer)
- `PhiGiamSat` - Supervisor fee
- `PhiHeThong` - System fee
- `HoanTien` - Refund

### Payment Method (PhuongThucThanhToan)
- `Vi` - Wallet
- `NganHang` - Bank transfer
- `MoMo` - MoMo
- `VNPay` - VNPay

### Payment Status (TrangThaiThanhToan)
- `ChoXuLy` - Pending
- `ThanhCong` - Successful
- `ThatBai` - Failed
- `DaHoan` - Refunded

### Dispute Status (TrangThaiTranhChap)
- `DangMo` - Open
- `DangXemXet` - Under review
- `DaGiaiQuyet` - Resolved
- `DaDong` - Closed

### Dispute Result (KetQuaTranhChap)
- `HoanTienDayDu` - Full refund
- `HoanTienMotPhan` - Partial refund
- `KhongHoanTien` - No refund

### Evidence Type (LoaiBangChung)
- `VanBan` - Text
- `HinhAnh` - Image
- `Video` - Video
- `TepTin` - File
- `Khac` - Other

### Review Type (LoaiDanhGia)
- `NguoiThue_DanhGia_Freelancer` - Client reviews Freelancer
- `Freelancer_DanhGia_NguoiThue` - Freelancer reviews Client
- `GiamSat_DanhGia` - Supervisor review

### Message Type (LoaiTinNhan)
- `VanBan` - Text
- `HinhAnh` - Image
- `TepTin` - File

### Gender (GioiTinh)
- `Nam` - Male
- `Nu` - Female
- `Khac` - Other

### Supervisor Organization Status (TrangThaiDonViGiamSat)
- `HoatDong` - Active
- `TamNgung` - Suspended
- `ChoDuyet` - Pending approval

### Notification Type (LoaiThongBao)
- `BaoGiaMoi` - New proposal
- `BaoGiaDuocChon` - Proposal accepted
- `HopDongMoi` - New contract
- `TienDoMoi` - New progress report
- `TranhChapMoi` - New dispute
- `ThanhToanMoi` - New payment
- `HeThong` - System notification

### Report Status (TrangThaiBaoCao)
- `ChoXuLy` - Pending
- `DaXuLy` - Processed
- `TuChoi` - Rejected

### Progress Confirmation Status (TrangThaiXacNhanTienDo)
- `ChoXacNhan` - Pending confirmation
- `DaXacNhan` - Confirmed
- `TuChoi` - Rejected

---

## Common Error Response Format

All error responses follow this format:

```json
{
  "statusCode": 400,
  "message": "Error description",
  "error": "Bad Request"
}
```

Common HTTP status codes:
- `400` - Bad Request (validation errors, business logic errors)
- `401` - Unauthorized (not authenticated)
- `403` - Forbidden (insufficient permissions)
- `404` - Not Found (resource doesn't exist)
- `500` - Internal Server Error
