# fras-tmdt-be

Basic NestJS backend skeleton aligned with PROJECT_RULES.

## Folder layout

```text
src/
  common/
    config/
    decorator/
    filters/
    guards/
    interceptors/
  modules/
    health/
      dto/
      health.controller.ts
      health.module.ts
      health.service.ts
  generated/prisma/
  app.module.ts
  main.ts

prisma/
  schema.prisma
  migrations/

test/
  app.e2e-spec.ts
```

## Quick start

```bash
npm install
npm run start:dev
```

## Prisma database init (PostgreSQL)

1. Create `.env` from `.env.example` and update `DATABASE_URL`.
2. Install dependencies:

```bash
npm install
```

3. Generate Prisma client:

```bash
npm run prisma:generate
```

4. Create and apply first migration:

```bash
npm run prisma:migrate -- --name init
```

5. Seed sample data:

```bash
npm run prisma:seed
```

Optional (open DB UI):

```bash
npm run prisma:studio
```

## Quality checks

```bash
npm run lint
npm run test
npm run build
```

## Example endpoint

- `GET /health` returns app health payload.
