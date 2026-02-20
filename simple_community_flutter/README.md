# Simple Community Flutter

모바일 최적화 Flutter 앱. NestJS API (simple-community-api)와 연동.

## 실행

```bash
# 1. API 서버 실행 (다른 터미널)
cd ../simple-community-api && pnpm run start:dev

# 2. Flutter 앱 실행 (웹)
flutter run -d chrome
```

## API 코드 재생성

API 스펙이 변경되면:

```bash
# API 실행 중인 상태에서
curl -s http://localhost:3001/api-json -o openapi.json

# OpenAPI Generator로 재생성
npx @openapitools/openapi-generator-cli generate \
  -i openapi.json -g dart-dio -o lib/src/api \
  --additional-properties=pubName=simple_community_api,pubAuthor=SimpleCommunity

# built_value 코드 생성
cd lib/src/api && dart run build_runner build --delete-conflicting-outputs
```

## 구조

- **lib/core/** - API 클라이언트, 라우터
- **lib/models/** - 응답 모델 (Auth, Post, Comment)
- **lib/providers/** - Riverpod (auth, posts, comments)
- **lib/screens/** - 화면 (목록, 상세, 작성, 로그인, 회원가입)
- **lib/src/api/** - OpenAPI로 생성한 API 패키지
