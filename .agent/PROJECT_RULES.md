# BookNest Project Rules

Tài liệu này định nghĩa quy ước code cho dự án BookNest (NestJS + Prisma + PostgreSQL).
Mục tiêu: code dễ đọc, dễ mở rộng, và thống nhất giữa các module.

## 1) Cấu trúc thư mục

```text
src/
  common/
    config/           # cấu hình cloudinary, redis, supabase...
    decorator/        # custom decorators dùng chung
    filters/          # global/custom exception filters
    guards/           # auth/roles guards
    interceptors/     # cache, clear-cache, rate-limit
  modules/
    <feature>/
      <feature>.module.ts
      <feature>.controller.ts
      <feature>.service.ts
      dto/            # request/response dto của feature
      guards/         # nếu guard chỉ dùng nội bộ feature
      strategy/       # nếu feature có passport strategy
  generated/prisma/   # code generate từ Prisma (KHONG sua tay)

prisma/
  schema.prisma
  migrations/

test/
  *.e2e-spec.ts
```

Quy tắc:

- Mỗi domain tách thành 1 module trong `src/modules`.
- Logic dùng chung đặt ở `src/common`, không copy/paste giữa modules.
- Không chỉnh sửa file trong `src/generated/prisma`.
- File templates email đặt tại `src/modules/email/templates`.

## 2) Quy ước đặt tên

### 2.1 Tên file/folder

- Dùng `kebab-case` cho tên file.
- Hậu tố bắt buộc theo vai trò:
  - `*.module.ts`
  - `*.controller.ts`
  - `*.service.ts`
  - `*.guard.ts`
  - `*.interceptor.ts`
  - `*.filter.ts`
  - `*.strategy.ts`
  - `*.decorator.ts`
  - `*.dto.ts`
- Folder DTO CHUAN cho code moi: `dto` (lowercase).
- Hien trang co ca `Dto` va `dto`; khi refactor thi uu tien doi ve `dto` de dong bo.

### 2.2 Tên symbol trong code

- Class/Enum: `PascalCase`.
  - Vi du: `AuthService`, `JwtStrategy`, `CreateBookDto`, `Role`.
- Bien/ham/property: `camelCase`.
  - Vi du: `createBookDto`, `getAllBooks`, `verificationToken`.
- Hang so: `UPPER_SNAKE_CASE`.
  - Vi du: `CACHE_PREFIX`, `CACHE_TTL`, `MAX_HISTORY`.
- Ten ENV: `UPPER_SNAKE_CASE`.
  - Vi du: `JWT_SECRET`, `DATABASE_URL`, `EMAIL_MODE`.

### 2.3 API fields

- Mac dinh dung `camelCase` cho field trong DTO/API.
- Neu bat buoc tuong thich client cu co the dung `snake_case` (vi du `refresh_token`), nhung can ghi ro ly do.

## 3) Quy ước import

- Thu tu import:
  1. Third-party packages (`@nestjs/*`, `class-validator`, ...)
  2. Internal imports
- Uu tien absolute import `src/...` cho code dung chung/cross-module.
- Dung relative import `./` hoac `../` cho file cung module.
- Uu tien `import type` cho type-only imports.

## 4) Quy ước cho Controller

- Controller chi xu ly HTTP layer:
  - validate input
  - parse params/query
  - delegate business logic cho service
- Khong viet business logic lon trong controller.
- Route naming:
  - Hien tai co 2 style (REST va action-based).
  - Code moi uu tien REST style (`POST /resource`, `PUT /resource/:id`, `DELETE /resource/:id`).
  - Neu sua module cu, giu backward compatibility endpoint dang su dung.
- Public endpoint phai gan `@IsPublic()`.
- Endpoint can role phai dung `@UseGuards(RolesGuard)` + `@Roles(...)`.
- Param so nguyen: uu tien `ParseIntPipe`; truong hop cu co the `Number(id)`.

## 5) Quy ước cho Service

- Service chua business logic, controller khong duoc thay the vai tro nay.
- Tra loi bang exception phu hop (`NotFoundException`, `ForbiddenException`, ...).
- Truy van Prisma nen co `select` hoac `include` ro rang, tranh tra ve du lieu du thua.
- Neu co nhieu truy van doc doc lap, uu tien `Promise.all` de toi uu hieu nang.

## 6) Quy ước DTO + Validation

- Tat ca input tu request body/query/param can qua DTO neu phuc tap.
- DTO bat buoc dung `class-validator`.
  - Dung `@IsOptional()` cho field optional.
  - Dung `@Type(() => Number)` + `@IsNumber()` cho field so.
- Moi module nen co `dto/index.ts` de re-export cac DTO.

## 7) Quy ước Prisma

- Prisma schema dat tai `prisma/schema.prisma`.
- Model/enum dung `PascalCase`; field dung `camelCase`.
- Moi thay doi schema phai tao migration moi trong `prisma/migrations`.
- Khong sua migration da apply tren moi truong dung chung.

## 8) Cache & Invalidation

- Endpoint GET can cache phai dung `@IsCache(key, ttl)`.
- Endpoint thay doi du lieu (POST/PUT/PATCH/DELETE) phai co `@ClearCache(...)`.
- Quy uoc key cache:
  - `<domain>:all`
  - `<domain>:detail`
  - `<domain>:by-*`
  - Vi du: `books:all`, `ratings:by-book`, `search:trending`.

## 9) Format, lint, quality

- Prettier:
  - `singleQuote: true`
  - `trailingComma: all`
- ESLint + TypeScript ESLint la bat buoc truoc khi merge.
- Han che `any`; neu bat buoc phai co ly do ro rang trong code review.

Lenh kiem tra truoc khi tao PR:

```bash
npm run lint
npm run test
npm run build
```

## 10) Testing

- Unit test dat canh file theo pattern `*.spec.ts`.
- E2E test dat trong thu muc `test/`.
- Khi them endpoint quan trong, can them it nhat 1 test (unit hoac e2e).

## 11) Pull Request checklist

- [ ] Dung dung convention dat ten
- [ ] Khong sua file generate (`src/generated/prisma`)
- [ ] DTO co validation day du
- [ ] Endpoint mutate co clear cache
- [ ] Da chay lint/test/build thanh cong
- [ ] Neu thay doi API contract: cap nhat tai lieu (`API_ENDPOINTS.md`)

## 12) Ghi chú migration convention

- Co mot so phan legacy chua dong nhat (vi du folder `Dto`, route action-based).
- Rule cho code moi la theo chuan trong tai lieu nay.
- Refactor convention cu can lam dan theo tung module, uu tien module hay thay doi.
