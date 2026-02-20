import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api_client.dart';
import '../core/api_error.dart';
import '../models/comment.dart';
import 'api_provider.dart';

final commentsListProvider =
    StateNotifierProvider.family<CommentsListNotifier, AsyncValue<CommentListResponse>, int>(
        (ref, postId) {
  final client = ref.watch(apiClientProvider);
  return CommentsListNotifier(client, ref, postId);
});

class CommentsListNotifier
    extends StateNotifier<AsyncValue<CommentListResponse>> {
  CommentsListNotifier(this._client, this._ref, this._postId)
      : super(const AsyncValue.loading()) {
    load();
  }

  final ApiClient _client;
  final Ref _ref;
  final int _postId;
  int _page = 1;
  bool _mounted = true;

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

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
      if (token != null) _client.setAccessToken(token);
      final res = await _client.api.commentsControllerFindAll(
        postId: _postId,
        page: _page.toString(),
        perPage: '10',
      );
      if (!_mounted) return;
      if (res.statusCode != 200) {
        throw Exception('댓글을 불러올 수 없습니다');
      }
      final data = res.data as Map<String, dynamic>;
      final result = CommentListResponse.fromJson(data);
      final prev = state.valueOrNull;
      if (prev != null && _page > 1) {
        if (!_mounted) return;
        state = AsyncValue.data(CommentListResponse(
          items: [...prev.items, ...result.items],
          total: result.total,
          page: result.page,
          perPage: result.perPage,
          totalPages: result.totalPages,
        ));
      } else {
        if (!_mounted) return;
        state = AsyncValue.data(result);
      }
    } catch (e, st) {
      if (_mounted) state = AsyncValue.error(parseApiError(e), st);
    }
  }
}
