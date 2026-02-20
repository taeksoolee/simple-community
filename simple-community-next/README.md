# Simple Community (Next.js)

Rails 버전과 동일한 기능의 Next.js 커뮤니티 게시판입니다.

## 스택

- **Next.js 16** (App Router)
- **React 19**
- **Prisma 5** + SQLite
- **Tailwind CSS 4**
- **bcryptjs** (비밀번호 해싱)
- **Heroicons**

## 기능

- 로그인 / 회원가입 / 로그아웃 (이메일 + 비밀번호)
- 게시글 CRUD (비로그인 읽기 전용)
- 댓글 / 대댓글 (무한 depth)
- 페이지네이션 (게시글·댓글 10개/페이지)
- 플래시 알림 (성공/실패, 자동/수동 닫기)

## 실행

```bash
pnpm install
pnpm exec prisma migrate dev   # 마이그레이션 (이미 적용됨)
pnpm run db:seed               # 시드 데이터
pnpm dev
```

## 테스트 계정

- admin@test.com / password123
- user1@test.com / password123
- user2@test.com / password123
- user3@test.com / password123

## 디렉터리 구조

```
src/
├── app/
│   ├── (auth)/login, register
│   ├── posts/          # 게시글 목록, 상세, 작성, 수정
│   ├── actions/        # Server Actions (auth, post, comment)
│   └── api/flash       # 플래시 조회 API
├── components/
│   ├── Nav.tsx
│   ├── PostForm.tsx
│   ├── CommentSection.tsx
│   ├── FlashProvider.tsx
│   └── DeleteButton.tsx
└── lib/
    ├── db.ts           # Prisma 클라이언트
    ├── auth.ts         # 세션 관리
    └── flash.ts       # 플래시 리다이렉트
```
