# 보안 검토 및 권장사항

## ✅ 이미 잘 적용된 사항

- **비밀번호 해싱**: bcrypt 사용 (rounds: 10)
- **JWT 인증**: Bearer 토큰, 7일 만료
- **권한 검증**: 게시글/댓글 수정·삭제 시 작성자 확인 (403 Forbidden)
- **입력 검증**: ValidationPipe (whitelist, transform)
- **SQL injection 방지**: Prisma ORM 사용 (파라미터화된 쿼리)
- **.env 제외**: .gitignore로 환경변수 파일 커밋 방지

---

## 🔴 조치 완료 (코드 수정됨)

### 1. JWT_SECRET 프로덕션 필수화
- **이슈**: `JWT_SECRET` 미설정 시 기본값 사용 → 토큰 위조 가능
- **조치**: `NODE_ENV=production`에서 기본값 사용 시 앱 시작 차단
- **파일**: `simple-community-api/src/auth/auth.module.ts`

### 2. CORS 설정
- **이슈**: `enableCors()` 무제한 허용 → 임의 도메인에서 API 호출 가능
- **조치**: `CORS_ORIGIN` 환경변수로 허용 오리진 제한 가능
- **파일**: `simple-community-api/src/main.ts`

---

## 🟡 권장 개선사항

### 1. Flutter: 토큰 저장 보안
- **현재**: `SharedPreferences`에 JWT 저장 (암호화 없음)
- **리스크**: 루팅/탈옥 기기에서 토큰 추출 가능
- **권장**: `flutter_secure_storage`로 마이그레이션 (Keychain/Keystore 사용)

### 2. Flutter: API Base URL
- **현재**: `api_config.dart`에 `http://localhost:3001` 하드코딩
- **권장**: 빌드 시 `--dart-define` 또는 `flutter_dotenv`로 주입

### 3. NestJS: Rate Limiting
- **권장**: `@nestjs/throttler` 추가로 로그인/회원가입 등 브루트포스 방지

### 4. NestJS: Helmet
- **권장**: `helmet` 미들웨어로 보안 헤더 추가 (X-Content-Type-Options 등)

### 5. 프로덕션 체크리스트
- [ ] `JWT_SECRET` 32자 이상 랜덤 문자열 설정
- [ ] `CORS_ORIGIN`에 실제 프론트엔드 도메인만 설정
- [ ] HTTPS 사용
- [ ] `NODE_ENV=production` 설정
