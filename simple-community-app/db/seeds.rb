# 기존 데이터 삭제 (개발 환경에서만)
puts "🗑️  기존 데이터 삭제 중..."
Comment.destroy_all
Post.destroy_all
Session.destroy_all
User.destroy_all

# 사용자 생성
puts "👤 사용자 생성 중..."
users = []

users << User.create!(
  email_address: "admin@test.com",
  password: "password123",
  password_confirmation: "password123"
)

users << User.create!(
  email_address: "user1@test.com",
  password: "password123",
  password_confirmation: "password123"
)

users << User.create!(
  email_address: "user2@test.com",
  password: "password123",
  password_confirmation: "password123"
)

users << User.create!(
  email_address: "user3@test.com",
  password: "password123",
  password_confirmation: "password123"
)

puts "✅ #{users.count}명의 사용자 생성 완료"

# 게시글 생성
puts "📝 게시글 생성 중..."
posts = []

post_contents = [
  ["Rails 8 커뮤니티에 오신 것을 환영합니다!", "안녕하세요! 이곳은 Rails 8로 만든 커뮤니티 게시판입니다.\n\n자유롭게 글을 작성하고 댓글과 대댓글로 소통해보세요.\n\n즐거운 시간 되세요! 😊"],
  ["Rails 8의 새로운 기능들", "Rails 8에서 추가된 주요 기능들:\n\n1. 내장 인증 시스템\n2. Solid Queue, Solid Cache, Solid Cable\n3. Kamal 2 배포 도구\n4. Propshaft 에셋 파이프라인\n\n정말 강력하고 편리한 기능들이 많이 추가되었네요!"],
  ["Tailwind CSS 너무 좋아요", "Tailwind CSS를 사용하니 정말 편하네요.\n\nutility-first 방식이 처음엔 낯설었지만, 익숙해지니 개발 속도가 엄청 빨라졌어요.\n\n여러분도 한번 써보세요!"],
  ["대댓글 기능이 신기해요", "댓글에 댓글을 달 수 있다니 정말 신기하네요!\n\n무한 depth로 대댓글을 달 수 있어서 깊이 있는 대화가 가능할 것 같아요."],
  ["Ruby 3.2 vs 3.3 성능 비교", "Ruby 3.3을 사용해보니 3.2에 비해 성능이 많이 개선된 것 같아요.\n\n특히 메모리 사용량이 줄어든 게 체감됩니다.\n\n여러분은 어떤 버전 쓰시나요?"],
  ["Hotwire로 SPA 없이 인터랙티브하게", "Turbo와 Stimulus만으로도 충분히 동적인 UX를 만들 수 있어요.\n\nJavaScript 프레임워크 없이도 멋진 앱을 만들 수 있다니 Rails 정말 대단해요."],
  ["SQLite로 프로덕션 배포?", "Rails 8부터 SQLite가 기본 DB로 설정되더라구요.\n\n소규모 서비스에는 SQLite만으로도 충분할 것 같아요. LiteFS로 복제도 가능하고요!"],
  ["페이지네이션 구현하기", "Kaminari로 페이지네이션 넣었는데 정말 간단하네요.\n\n한 줄이면 끝! Rails 생태계가 너무 좋아요."],
  ["Rails 인증 패턴 정리", "authenticate_by, has_secure_password 조합이 정말 깔끔해요.\n\n복잡한 gem 없이도 안전한 로그인 구현이 가능하네요."],
  ["Turbo Frames 활용 팁", "Turbo Frames로 페이지 일부만 업데이트하는 게 정말 편해요.\n\n전체 새로고침 없이 부드러운 UX 구현 가능!"],
  ["Stimulus 컨트롤러 작성법", "Stimulus는 가볍고 직관적이에요.\n\ndata-controller, data-action만 알면 금방 익숙해집니다."],
  ["Rails 8 인증 vs Devise", "Rails 8 내장 인증이 Devise보다 가볍고 단순해요.\n\n필요한 기능만 골라 쓰기 좋습니다."],
  ["Propshaft 에셋 관리", "Sprockets 대신 Propshaft 쓰니 빌드가 더 빨라졌어요.\n\nESBuild, Tailwind와 잘 맞는 것 같아요."],
  ["테스트 작성 습관화하기", "Minitest나 RSpec으로 테스트 작성하는 습관을 들여야겠어요.\n\n리팩토링할 때 안심이 됩니다."],
  ["커뮤니티 운영 노하우", "건전한 커뮤니티를 위해선 가이드라인이 중요할 것 같아요.\n\n자유와 질서의 균형을 맞추는 게 어렵네요."],
  ["좋은 코드 리뷰 문화", "코드 리뷰할 때 건설적인 피드백을 주는 게 중요해요.\n\n함께 성장하는 팀이 되고 싶습니다."],
  ["오픈소스 기여 경험", "처음으로 PR을 넣어봤어요!\n\n작은 typo 수정이었지만 기여하는 즐거움을 느꼈습니다."],
  ["워킹 메모리 늘리기", "복잡한 문제를 풀 때는 작게 나눠서 생각하는 게 중요해요.\n\n한 번에 하나씩 해결해나가요."],
  ["저녁 코딩 루틴", "하루 일과 마치고 저녁에 1시간씩 코딩하는 루틴을 들였어요.\n\n꾸준함이 정말 중요하네요."],
  ["새해 개발 목표", "올해는 사이드 프로젝트를 꼭 배포해보고 싶어요.\n\n지금 만드는 이 커뮤니티 앱도 완성해보겠습니다!"],
  ["채팅 기능 추가 고민", "실시간 채팅을 추가하려는데 Action Cable vs Hotwire Stream 고민이에요.\n\n어떤 게 나을까요?"],
  ["배포 플랫폼 선택", "Railway, Render, Fly.io, Kamal... 선택지가 너무 많아요.\n\n비용 대비 성능 좋은 곳 추천 부탁해요!"],
  ["다크 모드 구현", "Tailwind의 dark: variant로 다크 모드 넣어봤어요.\n\nprefers-color-scheme 자동 감지도 되고 좋네요."],
  ["접근성(A11y) 고려하기", "웹 접근성 표준을 지키려고 노력하고 있어요.\n\n스크린 리더 사용자도 고려한 마크업이 중요하죠."],
  ["모바일 퍼스트 디자인", "모바일 화면 먼저 설계하고 데스크톱으로 확장하는 게 효율적이에요.\n\nTailwind의 sm:, md: breakpoint가 도움이 됩니다."],
  ["API 버저닝 전략", "REST API를 만들 때 버전 관리를 어떻게 하시나요?\n\nURL path vs 헤더 방식 각각 장단점이 있네요."],
  ["에러 핸들링 베스트 프랙티스", "rescue_from으로 공통 에러 처리하는 패턴 좋아요.\n\n사용자에게 친절한 에러 메시지가 중요해요."],
  ["쿼리 최적화 경험", "N+1 문제를 includes로 해결했어요.\n\nBullet gem으로 디버깅하니 금방 찾았습니다."],
  ["부트캠프 수료 후기", "3개월 집중 학습 끝에 드디어 첫 앱을 만들었어요.\n\n앞으로도 꾸준히 성장하겠습니다!"],
  ["커피와 코딩", "아메리카노 한 잔과 함께 하는 새벽 코딩.\n\n주변에서 조용할 때 집중이 잘 됩니다."],
]

30.times do |i|
  title, body = post_contents[i % post_contents.size]
  posts << Post.create!(
    user: users[i % users.size],
    title: i < post_contents.size ? title : "#{title} (#{i + 1})",
    body: body
  )
end

puts "✅ #{posts.count}개의 게시글 생성 완료"

# 댓글 생성
puts "💬 댓글 생성 중..."
comments_count = 0

# 첫 번째 게시글에 댓글들
comment1 = Comment.create!(
  user: users[1],
  commentable: posts[0],
  body: "환영해주셔서 감사합니다! 잘 사용하겠습니다 😊"
)
comments_count += 1

comment1_1 = Comment.create!(
  user: users[0],
  commentable: comment1,
  body: "천만에요! 궁금한 점 있으면 언제든 물어보세요."
)
comments_count += 1

comment1_1_1 = Comment.create!(
  user: users[2],
  commentable: comment1_1,
  body: "대댓글도 잘 작동하네요 👍"
)
comments_count += 1

# 두 번째 게시글에 댓글들
comment2 = Comment.create!(
  user: users[2],
  commentable: posts[1],
  body: "Solid Queue가 정말 좋더라고요. Redis 없이도 백그라운드 작업을 처리할 수 있어서 편해요."
)
comments_count += 1

comment2_1 = Comment.create!(
  user: users[1],
  commentable: comment2,
  body: "오! 그럼 추가 의존성 없이도 사용 가능하다는 거네요?"
)
comments_count += 1

comment2_1_1 = Comment.create!(
  user: users[2],
  commentable: comment2_1,
  body: "네 맞아요! SQLite나 PostgreSQL만 있으면 됩니다."
)
comments_count += 1

comment2_2 = Comment.create!(
  user: users[3],
  commentable: comment2,
  body: "Solid Cache도 써봤는데 정말 좋더라구요!"
)
comments_count += 1

# 세 번째 게시글에 댓글들
comment3 = Comment.create!(
  user: users[0],
  commentable: posts[2],
  body: "Tailwind 정말 좋죠! 저도 애용하고 있습니다."
)
comments_count += 1

comment3_1 = Comment.create!(
  user: users[3],
  commentable: posts[2],
  body: "처음 배울 때 팁 있나요? 클래스가 너무 많아서 헷갈려요 😅"
)
comments_count += 1

comment3_1_1 = Comment.create!(
  user: users[2],
  commentable: comment3_1,
  body: "공식 문서를 옆에 켜두고 검색하면서 하면 금방 익숙해져요!"
)
comments_count += 1

comment3_1_1_1 = Comment.create!(
  user: users[3],
  commentable: comment3_1_1,
  body: "감사합니다! 한번 그렇게 해볼게요 🙏"
)
comments_count += 1

# 네 번째 게시글에 댓글들
comment4 = Comment.create!(
  user: users[0],
  commentable: posts[3],
  body: "대댓글 기능 마음에 드셨다니 다행이네요!"
)
comments_count += 1

comment4_1 = Comment.create!(
  user: users[1],
  commentable: posts[3],
  body: "polymorphic association으로 구현하셨나요?"
)
comments_count += 1

comment4_1_1 = Comment.create!(
  user: users[0],
  commentable: comment4_1,
  body: "네 맞아요! commentable이 Post일 수도 있고 Comment일 수도 있게 했습니다."
)
comments_count += 1

# 다섯 번째 게시글에 댓글들
comment5 = Comment.create!(
  user: users[1],
  commentable: posts[4],
  body: "저는 3.2.7 쓰고 있어요. 안정적이고 좋더라구요."
)
comments_count += 1

comment5_1 = Comment.create!(
  user: users[2],
  commentable: posts[4],
  body: "3.3은 YJIT 성능이 더 좋아졌다고 들었어요!"
)
comments_count += 1

comment5_1_1 = Comment.create!(
  user: users[0],
  commentable: comment5_1,
  body: "맞아요! 벤치마크 결과가 인상적이더라구요."
)
comments_count += 1

puts "✅ #{comments_count}개의 댓글/대댓글 생성 완료"

# 결과 요약
puts "\n" + "="*50
puts "✨ 시드 데이터 생성 완료!"
puts "="*50
puts "👤 사용자: #{User.count}명"
puts "📝 게시글: #{Post.count}개"
puts "💬 댓글: #{Comment.count}개"
puts "\n💡 테스트 계정:"
puts "   - admin@test.com / password123"
puts "   - user1@test.com / password123"
puts "   - user2@test.com / password123"
puts "   - user3@test.com / password123"
puts "="*50
