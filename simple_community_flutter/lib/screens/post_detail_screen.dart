import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:simple_community_api/simple_community_api.dart';

import '../models/comment.dart';
import '../providers/api_provider.dart';
import '../providers/post_detail_provider.dart';
import '../providers/comments_provider.dart';

class PostDetailScreen extends ConsumerWidget {
  final int postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(postDetailProvider(postId));
    final commentsAsync = ref.watch(commentsListProvider(postId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('게시글'),
        actions: [
          postAsync.whenOrNull(
                data: (post) => ref.watch(tokenProvider).whenOrNull(
                      data: (token) {
                        if (token == null) return null;
                        // TODO: check if current user is owner
                        return IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => context.push('/posts/$postId/edit'),
                        );
                      },
                    ),
              ) ??
              const SizedBox.shrink(),
        ],
      ),
      body: postAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('오류: $e', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(postDetailProvider(postId)),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
        data: (post) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(postDetailProvider(postId));
            ref.invalidate(commentsListProvider(postId));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      post.user?.emailAddress ?? '알 수 없음',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      DateFormat('yyyy.MM.dd HH:mm').format(post.createdAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  post.body,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  '댓글',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 16),
                commentsAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('댓글 로드 실패: $e'),
                  ),
                  data: (res) => Column(
                    children: [
                      ...res.items.expand((c) => [
                            _CommentTile(comment: c, postId: postId),
                            ...c.replies.map(
                                (r) => _CommentTile(comment: r, postId: postId, isReply: true)),
                          ]),
                      if (res.page < res.totalPages)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: TextButton(
                              onPressed: () {
                                ref.read(commentsListProvider(postId).notifier).loadMore();
                              },
                              child: const Text('더 보기'),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: ref.watch(tokenProvider).whenOrNull(
            data: (token) => token != null ? _CommentInput(postId: postId) : null,
          ),
    );
  }
}

class _CommentTile extends ConsumerWidget {
  final Comment comment;
  final int postId;
  final bool isReply;

  const _CommentTile({
    required this.comment,
    required this.postId,
    this.isReply = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(left: isReply ? 24 : 0, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                comment.user?.emailAddress ?? '알 수 없음',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: isReply ? 13 : 14,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('MM/dd HH:mm').format(comment.createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              ref.watch(tokenProvider).whenOrNull(
                    data: (token) => token != null
                        ? IconButton(
                            icon: Icon(Icons.delete_outline, size: 18, color: Colors.grey[600]),
                            onPressed: () => _deleteComment(ref),
                          )
                        : null,
                  ) ?? const SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            comment.body,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Future<void> _deleteComment(WidgetRef ref) async {
    // TODO: implement delete - need to add provider method
  }
}

class _CommentInput extends ConsumerStatefulWidget {
  final int postId;

  const _CommentInput({required this.postId});

  @override
  ConsumerState<_CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends ConsumerState<_CommentInput> {
  final _controller = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final body = _controller.text.trim();
    if (body.isEmpty || _isLoading) return;
    setState(() => _isLoading = true);
    try {
      final client = ref.read(apiClientProvider);
      await client.api.commentsControllerCreate(
        postId: widget.postId,
        createCommentDto: CreateCommentDto((b) => b..body = body),
      );
      _controller.clear();
      ref.invalidate(commentsListProvider(widget.postId));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('댓글 작성 실패: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                minLines: 1,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _submit(),
                decoration: const InputDecoration(
                  hintText: '댓글을 입력하세요',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _isLoading ? null : _submit,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
