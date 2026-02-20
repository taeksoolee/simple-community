# Simple Community API

NestJS + Prisma + SQLite 기반 REST API.

## 실행

```bash
pnpm install
pnpm prisma:push    # DB 스키마 적용
pnpm run start:dev  # 개발 서버 (포트 3001)
```

## Swagger 문서

- http://localhost:3001/api

## 엔드포인트

| 메서드 | 경로 | 설명 |
|--------|------|------|
| GET | / | 헬스 체크 |
| POST | /auth/register | 회원가입 |
| POST | /auth/login | 로그인 |
| GET | /posts | 게시글 목록 (page, perPage) |
| GET | /posts/:id | 게시글 상세 |
| POST | /posts | 게시글 작성 (인증) |
| PATCH | /posts/:id | 게시글 수정 (인증) |
| DELETE | /posts/:id | 게시글 삭제 (인증) |
| GET | /posts/:postId/comments | 댓글 목록 |
| POST | /posts/:postId/comments | 댓글 작성 (인증) |
| DELETE | /posts/:postId/comments/:id | 댓글 삭제 (인증) |

인증: `Authorization: Bearer <accessToken>`
