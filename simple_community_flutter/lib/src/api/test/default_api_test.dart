import 'package:test/test.dart';
import 'package:simple_community_api/simple_community_api.dart';


/// tests for DefaultApi
void main() {
  final instance = SimpleCommunityApi().getDefaultApi();

  group(DefaultApi, () {
    // 헬스 체크
    //
    //Future appControllerHealth() async
    test('test appControllerHealth', () async {
      // TODO
    });

    // 로그인
    //
    //Future authControllerLogin(LoginDto loginDto) async
    test('test authControllerLogin', () async {
      // TODO
    });

    // 회원가입
    //
    //Future authControllerRegister(RegisterDto registerDto) async
    test('test authControllerRegister', () async {
      // TODO
    });

    // 댓글 작성
    //
    //Future commentsControllerCreate(num postId, CreateCommentDto createCommentDto) async
    test('test commentsControllerCreate', () async {
      // TODO
    });

    // 댓글 목록 (페이지네이션)
    //
    //Future commentsControllerFindAll(num postId, String page, String perPage) async
    test('test commentsControllerFindAll', () async {
      // TODO
    });

    // 댓글 삭제
    //
    //Future commentsControllerRemove(num postId, num id) async
    test('test commentsControllerRemove', () async {
      // TODO
    });

    // 게시글 작성
    //
    //Future postsControllerCreate(CreatePostDto createPostDto) async
    test('test postsControllerCreate', () async {
      // TODO
    });

    // 게시글 목록 (페이지네이션)
    //
    //Future postsControllerFindAll(String page, String perPage) async
    test('test postsControllerFindAll', () async {
      // TODO
    });

    // 게시글 상세
    //
    //Future postsControllerFindOne(num id) async
    test('test postsControllerFindOne', () async {
      // TODO
    });

    // 게시글 삭제
    //
    //Future postsControllerRemove(num id) async
    test('test postsControllerRemove', () async {
      // TODO
    });

    // 게시글 수정
    //
    //Future postsControllerUpdate(num id, UpdatePostDto updatePostDto) async
    test('test postsControllerUpdate', () async {
      // TODO
    });

  });
}
