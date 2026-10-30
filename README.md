# TOPSA Fellowship Management System

Phase 1 (Foundation, backend): Prisma schema for all core entities, Argon2id authentication with
server-side sessions, CSRF protection, rate limiting, account lockout, password reset, department-scoped RBAC,
user/role administration and audit logging. The React app comes next.

## Local setup
```bash
cp apps/api/.env.example apps/api/.env     # set SEED_ADMIN_EMAIL / SEED_ADMIN_PASSWORD (12+ chars)
docker compose up -d                       # local Postgres (dev credentials only)
npm install
cd apps/api
npx prisma migrate dev --name init         # creates the first migration from schema.prisma
npm run prisma:seed                        # permissions, default roles, first admin
npm test
npm run dev                                # http://localhost:4000/api/health
```
After seeding, delete `SEED_ADMIN_*` from `.env`.

## API (Phase 1)
- `POST /api/auth/login`, `GET /api/auth/me` (returns `csrfToken`), `POST /api/auth/logout`
- `POST /api/auth/change-password`, `POST /api/auth/password-reset/request|confirm`
- `GET|POST /api/users`, `PATCH /api/users/:id/status`, `PUT /api/users/:id/roles`, `GET /api/roles`

All state-changing requests after login must send `X-CSRF-Token` and the session cookie.

## Security notes
- Permissions are enforced by `requirePermission` on each route, never by the UI.
- Department-scoped roles: a grant with a `departmentId` only satisfies checks for that department.
- Reset/invite emails print to the console in development. Configure real SMTP before production.
- Dependency versions were chosen without network access; run `npm audit` and update after installing.
