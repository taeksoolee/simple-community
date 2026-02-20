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

posts << Post.create!(
  user: users[0],
  title: "Rails 8 커뮤니티에 오신 것을 환영합니다!",
  body: "안녕하세요! 이곳은 Rails 8로 만든 커뮤니티 게시판입니다.\n\n자유롭게 글을 작성하고 댓글과 대댓글로 소통해보세요.\n\n즐거운 시간 되세요! 😊"
)

posts << Post.create!(
  user: users[1],
  title: "Rails 8의 새로운 기능들",
  body: "Rails 8에서 추가된 주요 기능들:\n\n1. 내장 인증 시스템\n2. Solid Queue, Solid Cache, Solid Cable\n3. Kamal 2 배포 도구\n4. Propshaft 에셋 파이프라인\n\n정말 강력하고 편리한 기능들이 많이 추가되었네요!"
)

posts << Post.create!(
  user: users[2],
  title: "Tailwind CSS 너무 좋아요",
  body: "Tailwind CSS를 사용하니 정말 편하네요.\n\nutility-first 방식이 처음엔 낯설었지만, 익숙해지니 개발 속도가 엄청 빨라졌어요.\n\n여러분도 한번 써보세요!"
)

posts << Post.create!(
  user: users[3],
  title: "대댓글 기능이 신기해요",
  body: "댓글에 댓글을 달 수 있다니 정말 신기하네요!\n\n무한 depth로 대댓글을 달 수 있어서 깊이 있는 대화가 가능할 것 같아요."
)

posts << Post.create!(
  user: users[0],
  title: "Ruby 3.2 vs 3.3 성능 비교",
  body: "Ruby 3.3을 사용해보니 3.2에 비해 성능이 많이 개선된 것 같아요.\n\n특히 메모리 사용량이 줄어든 게 체감됩니다.\n\n여러분은 어떤 버전 쓰시나요?"
)

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
