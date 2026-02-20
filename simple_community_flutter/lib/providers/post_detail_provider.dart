import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post.dart';
import 'api_provider.dart';

final postDetailProvider =
    FutureProvider.family<Post, int>((ref, postId) async {
  final client = ref.watch(apiClientProvider);
  final token = ref.watch(tokenProvider).valueOrNull;
  if (token != null) client.setAccessToken(token);
  final res = await client.api.postsControllerFindOne(id: postId);
  if (res.statusCode != 200) {
    throw Exception('게시글을 불러올 수 없습니다');
  }
  return Post.fromJson(res.data as Map<String, dynamic>);
});
