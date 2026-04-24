1. AUTH MODULE
   POST /auth/register
   POST /auth/login
2. USER MODULE
   GET /users
   GET /users/{id}
   GET /users/search?keyword=
   PUT /users/{id}
   DELETE /users/{id}
   GET /users/{id}/profile
3. CATEGORY MODULE
   GET /categories
   GET /categories/{id}
   POST /categories
   PUT /categories/{id}
   DELETE /categories/{id}
4. JOB (YÊU CẦU THUÊ)
   POST /jobs
   GET /jobs
   GET /jobs/{id}
   GET /jobs/search?keyword=&category=&budget=
   PUT /jobs/{id}
   DELETE /jobs/{id}

GET /users/{id}/jobs 5. PROPOSAL (BÁO GIÁ)
POST /proposals
GET /proposals/{id}
PUT /proposals/{id}
DELETE /proposals/{id}
GET /jobs/{jobId}/proposals
GET /freelancers/{id}/proposals

6. CONTRACT (TRUNG TÂM HỆ THỐNG)
   POST /contracts
   GET /contracts
   GET /contracts/{id}
   GET /users/{id}/contracts
   PUT /contracts/{id}/status
   GET /contracts/{id}/detail

7. SUPERVISOR
   GET /supervisors
   GET /supervisors/{id}
   GET /supervisors/search?keyword=
   POST /supervisors
   PUT /supervisors/{id}
   DELETE /supervisors/{id}

8. SUPERVISOR SELECTION (CHỌN GIÁM SÁT)
   POST /contracts/{id}/supervisor
   → Client chọn supervisor
   PUT /contracts/{id}/supervisor/accept
   → Freelancer accept
   PUT /contracts/{id}/supervisor/reject
   → Freelancer reject
9. PROGRESS
   POST /contracts/{id}/progress
   GET /contracts/{id}/progress
   GET /progress/{id}
   PUT /progress/{id}
   DELETE /progress/{id}

tiếp từ phần này============================================================= 10. PAYMENT (ESCROW)
POST /payments/deposit
→ Thanh toán đặt cọc
GET /payments/{id}
GET /contracts/{id}/payments
PUT /payments/{id}/release
→ Thanh toán cho freelancer + supervisor
PUT /payments/{id}/refund
→ Hoàn tiền

11. DISPUTE
    POST /disputes
    GET /disputes/{id}
    GET /contracts/{id}/disputes
    PUT /disputes/{id}/review
    → Supervisor xử lý
    PUT /disputes/{id}/resolve
    → Kết luận (refund / continue / cancel)

12. EVIDENCE
    POST /disputes/{id}/evidences
    GET /disputes/{id}/evidences
    DELETE /evidences/{id}

13. REVIEW (ĐÁNH GIÁ 3 CHIỀU)
    POST /reviews
    GET /reviews/{id}
    GET /users/{id}/reviews
    GET /contracts/{id}/reviews

14. CHAT
    POST /conversations
    GET /conversations/{id}
    GET /contracts/{id}/conversations
    POST /messages
    GET /conversations/{id}/messages

15. NOTIFICATION
    GET /notifications
    PUT /notifications/{id}/read
    DELETE /notifications/{id}

16. REPORT & ADMIN
    POST /reports
    GET /reports
    PUT /reports/{id}/resolve
    GET /admin/users
    PUT /admin/users/{id}/ban
    GET /admin/supervisors
    PUT /admin/supervisors/{id}/approve
    GET /admin/statistics
