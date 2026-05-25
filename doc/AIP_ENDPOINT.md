# API ENDPOINT TONG HOP

## Thong tin chung

- Port mac dinh: `3000`
- Base URL local: `http://localhost:3000`
- Content-Type: `application/json`
- Auth: Khong dung token, khong hash password (dev mode)

---

## Danh sach endpoint (88 endpoints)

### Health
| Method | Path | Mo ta |
|--------|------|-------|
| GET | /health | Kiem tra app con song |

### Auth
| Method | Path | Mo ta |
|--------|------|-------|
| POST | /auth/register | Dang ky tai khoan |
| POST | /auth/login | Dang nhap |

### Users
| Method | Path | Mo ta |
|--------|------|-------|
| GET | /users | Lay danh sach nguoi dung |
| GET | /users/search | Tim kiem nguoi dung (?keyword=) |
| GET | /users/:id | Lay thong tin nguoi dung |
| GET | /users/:id/profile | Lay profile chi tiet theo vai tro |
| GET | /users/:id/jobs | Lay yeu cau cua nguoi thue |
| GET | /users/:id/contracts | Lay hop dong cua user |
| GET | /users/:id/conversations | Lay cuoc hoi thoai cua user |
| GET | /users/:id/reviews | Lay danh gia cua user |
| PUT | /users/:id | Cap nhat thong tin |
| DELETE | /users/:id | Xoa (soft delete) |

### Categories
| Method | Path | Mo ta |
|--------|------|-------|
| GET | /categories | Lay danh sach loai dich vu |
| GET | /categories/:id | Lay chi tiet loai dich vu |
| POST | /categories | Tao loai dich vu |
| PUT | /categories/:id | Cap nhat loai dich vu |
| DELETE | /categories/:id | Xoa loai dich vu |

### Skills
| Method | Path | Mo ta |
|--------|------|-------|
| GET | /skills | Lay danh sach ky nang |
| GET | /skills/:id | Lay chi tiet ky nang |
| POST | /skills | Tao ky nang |
| PUT | /skills/:id | Cap nhat ky nang |
| DELETE | /skills/:id | Xoa ky nang |

### Jobs (Yeu cau)
| Method | Path | Mo ta |
|--------|------|-------|
| GET | /jobs | Lay danh sach yeu cau |
| GET | /jobs/search | Tim kiem (?keyword, ?category, ?budget, ?skills) |
| GET | /jobs/:id | Lay chi tiet yeu cau |
| GET | /jobs/:id/proposals | Lay bao gia cua yeu cau |
| GET | /jobs/:id/skills | Lay ky nang yeu cau |
| POST | /jobs | Tao yeu cau moi |
| PUT | /jobs/:id | Cap nhat yeu cau |
| PUT | /jobs/:id/skills | Thay the toan bo ky nang yeu cau |
| POST | /jobs/:id/skills/:kyNangId | Them 1 ky nang vao yeu cau |
| DELETE | /jobs/:id/skills/:kyNangId | Xoa 1 ky nang khoi yeu cau |
| DELETE | /jobs/:id | Xoa yeu cau (soft delete) |

### Proposals (Bao gia)
| Method | Path | Mo ta |
|--------|------|-------|
| GET | /proposals/:id | Lay chi tiet bao gia |
| POST | /proposals | Tao bao gia |
| PUT | /proposals/:id | Cap nhat bao gia |
| DELETE | /proposals/:id | Xoa bao gia |

### Freelancers
| Method | Path | Mo ta |
|--------|------|-------|
| GET | /freelancers/:id/proposals | Lay bao gia cua freelancer |
| GET | /freelancers/:id/skills | Lay ky nang cua freelancer |
| PUT | /freelancers/:id/skills | Thay the toan bo ky nang |
| POST | /freelancers/:id/skills/:kyNangId | Them 1 ky nang |
| DELETE | /freelancers/:id/skills/:kyNangId | Xoa 1 ky nang |

### Contracts (Hop dong)
| Method | Path | Mo ta |
|--------|------|-------|
| GET | /contracts | Lay danh sach hop dong |
| GET | /contracts/:id | Lay chi tiet hop dong |
| GET | /contracts/:id/detail | Lay chi tiet hop dong (mo rong) |
| GET | /contracts/:id/progress | Lay tien do cua hop dong |
| GET | /contracts/:id/conversations | Lay cuoc hoi thoai cua hop dong |
| GET | /contracts/:id/payments | Lay thanh toan cua hop dong |
| GET | /contracts/:id/disputes | Lay tranh chap cua hop dong |
| GET | /contracts/:id/reviews | Lay danh gia cua hop dong |
| POST | /contracts | Khong dung truc tiep; cong viec duoc tao khi chot bao gia |
| PUT | /contracts/:id/status | Cap nhat trang thai hop dong |
| POST | /contracts/:id/supervisor | Chon don vi giam sat |
| PUT | /contracts/:id/supervisor/accept | Chap nhan giam sat |
| PUT | /contracts/:id/supervisor/reject | Tu choi giam sat |

### Supervisors (Don vi giam sat)
| Method | Path | Mo ta |
|--------|------|-------|
| GET | /supervisors | Lay danh sach |
| GET | /supervisors/search | Tim kiem (?keyword=) |
| GET | /supervisors/:id | Lay chi tiet |
| POST | /supervisors | Tao don vi giam sat |
| PUT | /supervisors/:id | Cap nhat |
| DELETE | /supervisors/:id | Xoa (soft delete) |

### Progress (Tien do)
| Method | Path | Mo ta |
|--------|------|-------|
| GET | /progress/:id | Lay chi tiet tien do |
| POST | /progress | Tao tien do moi |
| PUT | /progress/:id | Cap nhat tien do |
| DELETE | /progress/:id | Xoa tien do |

### Chat (Tin nhan)
| Method | Path | Mo ta |
|--------|------|-------|
| POST | /chat | Tao cuoc hoi thoai |
| GET | /chat/:id | Lay chi tiet cuoc hoi thoai |
| PUT | /chat/:id/close | Dong cuoc hoi thoai |
| GET | /chat/:id/messages | Lay tin nhan |
| POST | /chat/:id/messages | Gui tin nhan |
| PUT | /chat/:id/read/:userId | Danh dau da doc |

### Payments (Thanh toan)
| Method | Path | Mo ta |
|--------|------|-------|
| POST | /payments/deposit | Tao thanh toan dat coc |
| GET | /payments/:id | Lay chi tiet thanh toan |
| PUT | /payments/:id/release | Giai ngan |
| PUT | /payments/:id/refund | Hoan tien |

### Disputes (Tranh chap)
| Method | Path | Mo ta |
|--------|------|-------|
| POST | /disputes | Tao tranh chap |
| GET | /disputes/:id | Lay chi tiet tranh chap |
| PUT | /disputes/:id/review | Giam sat xem xet |
| PUT | /disputes/:id/resolve | Giam sat giai quyet |

### Evidences (Bang chung)
| Method | Path | Mo ta |
|--------|------|-------|
| POST | /disputes/:id/evidences | Nop bang chung |
| GET | /disputes/:id/evidences | Lay bang chung cua tranh chap |
| DELETE | /evidences/:id | Xoa bang chung |

### Reviews (Danh gia)
| Method | Path | Mo ta |
|--------|------|-------|
| POST | /reviews | Tao danh gia |
| GET | /reviews/:id | Lay chi tiet danh gia |

### Notifications (Thong bao)
| Method | Path | Mo ta |
|--------|------|-------|
| GET | /notifications?userId= | Lay thong bao cua user |
| PUT | /notifications/:id/read | Danh dau da doc |
| DELETE | /notifications/:id | Xoa thong bao |

### Reports (Bao cao vi pham)
| Method | Path | Mo ta |
|--------|------|-------|
| POST | /reports | Tao bao cao |
| GET | /reports | Lay danh sach bao cao |
| PUT | /reports/:id/resolve | Admin xu ly bao cao |

### Admin
| Method | Path | Mo ta |
|--------|------|-------|
| GET | /admin/users | Lay danh sach user |
| PUT | /admin/users/:id/ban | Khoa tai khoan |
| GET | /admin/supervisors | Lay danh sach giam sat |
| PUT | /admin/supervisors/:id/approve | Duyet don vi giam sat |
| GET | /admin/statistics | Lay thong ke he thong |


### Contract Flow (Escrow)
| Method | Path | Mo ta |
|--------|------|-------|
| POST | /contracts/accept-proposal | Chot freelancer (`DaChot`) + tao cong viec + escrow |
| PUT | /contracts/:id/confirm-completion | Xac nhan hoan thanh (tung ben) |

### WebSocket - Realtime Chat
| Event | Direction | Mo ta |
|-------|-----------|-------|
| joinConversation | Client->Server | Join room cuoc hoi thoai |
| leaveConversation | Client->Server | Leave room |
| sendMessage | Client->Server | Gui tin nhan (luu DB + broadcast) |
| markAsRead | Client->Server | Danh dau da doc |
| typing | Client->Server | Typing indicator |
| newMessage | Server->Client | Tin nhan moi trong room |
| messageNotification | Server->Client | Thong bao tin nhan cho user ngoai room |
| messagesRead | Server->Client | Ai do da doc tin nhan |
| userTyping | Server->Client | Ai do dang go |

WebSocket URL: `http://localhost:3000/chat?userId=1`
