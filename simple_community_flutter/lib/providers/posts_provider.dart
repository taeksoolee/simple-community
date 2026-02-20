import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api_client.dart';
import '../models/post.dart';
import 'api_provider.dart';

final postsListProvider =
    StateNotifierProvider<PostsListNotifier, AsyncValue<PostListResponse>>(
        (ref) {
  final client = ref.watch(apiClientProvider);
  return PostsListNotifier(client, ref);
});

class PostsListNotifier extends StateNotifier<AsyncValue<PostListResponse>> {
  bool _mounted = true;

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
  PostsListNotifier(this._client, this._ref)
      : super(const AsyncValue.loading()) {
    load();
  }

  final ApiClient _client;
  final Ref _ref;
  int _page = 1;

  Future<void> load() async {
    state = const AsyncValue.loading();
    _page = 1;
    await _fetch();
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null) return;
    if (_page >= current.totalPages) return;
    _page++;
    await _fetch();
  }

  Future<void> _fetch() async {
    try {
      final token = _ref.read(tokenProvider).valueOrNull;
      if (token != null) {
        _client.setAccessToken(token);
      }
      final res = await _client.api.postsControllerFindAll(
        page: _page.toString(),
        perPage: '10',
      );
      if (!_mounted) return;
      if (res.statusCode != 200) {
        throw Exception('게시글 목록을 불러올 수 없습니다');
      }
      final data = res.data as Map<String, dynamic>;
      final result = PostListResponse.fromJson(data);
      final prev = state.valueOrNull;
      if (prev != null && _page > 1) {
        state = AsyncValue.data(PostListResponse(
          items: [...prev.items, ...result.items],
          total: result.total,
          page: result.page,
          perPage: result.perPage,
          totalPages: result.totalPages,
        ));
      } else {
        state = AsyncValue.data(result);
      }
    } catch (e, st) {
      if (_mounted) state = AsyncValue.error(e, st);
    }
  }
}
