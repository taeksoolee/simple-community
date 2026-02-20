import { PrismaClient } from "@prisma/client";
import bcrypt from "bcryptjs";

const prisma = new PrismaClient();

async function main() {
  console.log("🗑️  기존 데이터 삭제 중...");
  await prisma.comment.deleteMany();
  await prisma.post.deleteMany();
  await prisma.session.deleteMany();
  await prisma.user.deleteMany();

  console.log("👤 사용자 생성 중...");
  const users = await Promise.all([
    prisma.user.create({ data: { emailAddress: "admin@test.com", passwordDigest: await bcrypt.hash("password123", 10) } }),
    prisma.user.create({ data: { emailAddress: "user1@test.com", passwordDigest: await bcrypt.hash("password123", 10) } }),
    prisma.user.create({ data: { emailAddress: "user2@test.com", passwordDigest: await bcrypt.hash("password123", 10) } }),
    prisma.user.create({ data: { emailAddress: "user3@test.com", passwordDigest: await bcrypt.hash("password123", 10) } }),
  ]);
  console.log(`✅ ${users.length}명의 사용자 생성 완료`);

  console.log("📝 게시글 생성 중...");
  const postContents = [
    ["Rails 8 커뮤니티에 오신 것을 환영합니다!", "안녕하세요! 이곳은 Next.js로 만든 커뮤니티 게시판입니다.\n\n자유롭게 글을 작성하고 댓글과 대댓글로 소통해보세요."],
    ["Next.js 16 + React 19", "App Router와 Server Components가 정말 편하네요.\n\nRSC로 데이터 페칭이 깔끔해졌어요."],
    ["Tailwind CSS 너무 좋아요", "Tailwind로 스타일링하니 개발 속도가 빨라져요."],
    ["대댓글 기능이 신기해요", "댓글에 댓글을 달 수 있다니 정말 신기하네요!\n\n깊이 있는 대화가 가능할 것 같아요."],
    ["Server Components vs Client", "RSC가 기본이라 데이터 페칭이 깔끔해요.\n\n'use client'는 필요한 곳에만 쓰면 됩니다."],
    ["Prisma + SQLite 조합", "로컬 개발에 SQLite만으로도 충분하네요.\n\n나중에 PostgreSQL로 전환도 쉽다고 하던데요."],
    ["페이지네이션 구현", "offset/limit으로 간단하게 넣었어요."],
    ["쿠키 기반 세션", "서버 액션에서 getSession()으로 현재 유저 확인.\n\nNext.js 15부터 cookies()가 async라 주의!"],
    ["플래시 알림", "쿠키로 메시지 전달 후 API에서 읽고 삭제하는 방식이에요."],
    ["Tailwind v4", "CSS 변수 기반이 되면서 더 유연해졌네요."],
    ["Server Actions 활용", "form action에 Server Action 연결하니 boilerplate가 줄었어요."],
    ["useActionState 패턴", "에러 반환 시 클라이언트에서 state로 표시할 수 있어요."],
    ["재사용 컴포넌트", "PostForm, CommentSection처럼 분리해두니 관리가 쉬워요."],
    ["타입 안전성", "Prisma가 생성해주는 타입으로 런타임 에러를 줄일 수 있어요."],
    ["빌드 속도", "Turbopack으로 개발 서버가 빨라졌어요."],
    ["배포 고민", "Vercel, Railway, Fly.io... Next.js 호스팅 선택지가 많네요."],
    ["Edge vs Node", "Edge 런타임은 Prisma 지원이 제한적이라 Node로 가는 중이에요."],
    ["인증 구현", "NextAuth 말고 커스텀 세션으로 해봤어요.\n\n필요한 기능만 있어서 가벼워요."],
    ["bcrypt 해싱", "비밀번호는 Server Action에서만 처리하도록 했어요."],
    ["CSRF", "Server Actions는 자동으로 CSRF 보호가 된다고 하네요."],
    ["히드레이션", "Server Component로 초기 HTML 생성 후 클라이언트에서 인터랙션 추가."],
    ["폰트 제거", "Geist 폰트가 빌드 에러 나서 시스템 폰트로 바꿨어요."],
    ["모바일 대응", "Tailwind 반응형 클래스로 대부분 커버돼요."],
    ["접근성", "버튼에 aria-label, 폼에 label 연결해두었어요."],
    ["에러 처리", "notFound(), redirect() 활용하고 있어요."],
    ["시드 데이터", "Prisma seed로 개발용 데이터 채워넣기."],
    ["마이그레이션", "prisma migrate dev로 스키마 변경해요."],
    ["관계 설정", "Comment의 parentId로 대댓글 트리 구조."],
    ["N+1 방지", "include로 user, replies 한 번에 조회."],
    ["정렬", "createdAt desc로 최신순."],
  ];

  const posts = [];
  for (let i = 0; i < 30; i++) {
    const [title, body] = postContents[i % postContents.length];
    posts.push(
      await prisma.post.create({
        data: {
          title: i < postContents.length ? title : `${title} (${i + 1})`,
          body,
          userId: users[i % users.length].id,
        },
      })
    );
  }
  console.log(`✅ ${posts.length}개의 게시글 생성 완료`);

  console.log("💬 댓글 생성 중...");
  const c1 = await prisma.comment.create({ data: { body: "환영합니다!", userId: users[1].id, postId: posts[0].id } });
  const c1_1 = await prisma.comment.create({ data: { body: "감사합니다!", userId: users[0].id, postId: posts[0].id, parentId: c1.id } });
  await prisma.comment.create({ data: { body: "대댓글도 잘 되네요 👍", userId: users[2].id, postId: posts[0].id, parentId: c1_1.id } });
  await prisma.comment.create({ data: { body: "Server Components 좋죠!", userId: users[2].id, postId: posts[1].id } });
  await prisma.comment.create({ data: { body: "Prisma 쓰기 편해요", userId: users[3].id, postId: posts[5].id } });
  await prisma.comment.create({ data: { body: "저도 Tailwind v4 써보고 싶어요", userId: users[1].id, postId: posts[9].id } });
  console.log("✅ 댓글/대댓글 생성 완료");

  console.log("\n✨ 시드 완료! (admin@test.com / password123)");
}

main()
  .catch(console.error)
  .finally(() => prisma.$disconnect());
