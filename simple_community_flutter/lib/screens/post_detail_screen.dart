import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:simple_community_api/simple_community_api.dart';

import '../models/comment.dart';
import '../providers/api_provider.dart';
import '../providers/comments_provider.dart';
import '../providers/post_detail_provider.dart';

class PostDetailScreen extends ConsumerWidget {
  final int postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(postDetailProvider(postId));
    final commentsAsync = ref.watch(commentsListProvider(postId));
    final token = ref.watch(tokenProvider).valueOrNull;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => context.pop(),
          child: const Icon(CupertinoIcons.back),
        ),
        middle: const Text(
          '게시글',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        trailing: postAsync.valueOrNull != null && token != null
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => context.push('/posts/$postId/edit'),
                child: const Icon(CupertinoIcons.pencil),
              )
            : null,
      ),
      child: postAsync.when(
        loading: () => const Center(child: CupertinoActivityIndicator(radius: 14)),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.wifi_slash, size: 48, color: CupertinoColors.systemGrey),
                const SizedBox(height: 16),
                Text(
                  '오류: $e',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context), fontSize: 15),
                ),
                const SizedBox(height: 24),
                CupertinoButton.filled(
                  onPressed: () => ref.invalidate(postDetailProvider(postId)),
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          ),
        ),
        data: (post) => Column(
          children: [
            Expanded(
              child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                ref.invalidate(postDetailProvider(postId));
                ref.invalidate(commentsListProvider(postId));
              },
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: CupertinoColors.label.resolveFrom(context),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _Avatar(initial: (post.user?.emailAddress ?? '?')[0].toUpperCase(), size: 28),
                            const SizedBox(width: 10),
                            Text(
                              post.user?.emailAddress ?? '알 수 없음',
                              style: TextStyle(
                                fontSize: 14,
                                color: CupertinoColors.secondaryLabel.resolveFrom(context),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              DateFormat('yyyy.MM.dd HH:mm').format(post.createdAt),
                              style: TextStyle(
                                fontSize: 13,
                                color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          post.body,
                          style: TextStyle(
                            fontSize: 16,
                            color: CupertinoColors.label.resolveFrom(context),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          '댓글',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.label.resolveFrom(context),
                          ),
                        ),
                        const SizedBox(width: 8),
                        commentsAsync.whenOrNull(
                              data: (res) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: CupertinoColors.activeBlue.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${res.total}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: CupertinoColors.activeBlue,
                                  ),
                                ),
                              ),
                            ) ??
                            const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  commentsAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(child: CupertinoActivityIndicator(radius: 12)),
                    ),
                    error: (e, _) => Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        '댓글 로드 실패: $e',
                        style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                      ),
                    ),
                    data: (res) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          ...res.items.expand((c) => [
                                _CommentTile(comment: c, postId: postId),
                                ...c.replies.map(
                                    (r) => _CommentTile(comment: r, postId: postId, isReply: true)),
                              ]),
                          if (res.page < res.totalPages)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: CupertinoButton(
                                  onPressed: () => ref.read(commentsListProvider(postId).notifier).loadMore(),
                                  child: const Text('더 보기'),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: token != null ? 100 : 32),
                ],
              ),
            ),
          ],
        ),
            ),
            if (token != null) _CommentInput(postId: postId),
          ],
        ),
      ),
    );
  }
}

class _CommentTile extends ConsumerWidget {
  final Comment comment;
  final int postId;
  final bool isReply;

  const _CommentTile({required this.comment, required this.postId, this.isReply = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final token = ref.watch(tokenProvider).valueOrNull;

    return Padding(
      padding: EdgeInsets.only(left: isReply ? 28 : 0, bottom: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _Avatar(initial: (comment.user?.emailAddress ?? '?')[0].toUpperCase(), size: 24),
                const SizedBox(width: 10),
                Text(
                  comment.user?.emailAddress ?? '알 수 없음',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: isReply ? 13 : 14,
                    color: CupertinoColors.label.resolveFrom(context),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MM/dd HH:mm').format(comment.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                  ),
                ),
                const Spacer(),
                if (token != null)
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => _deleteComment(ref),
                    child: Icon(CupertinoIcons.delete, size: 18, color: CupertinoColors.systemGrey),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              comment.body,
              style: TextStyle(
                fontSize: 15,
                color: CupertinoColors.label.resolveFrom(context),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteComment(WidgetRef ref) async {
    // TODO
  }
}

class _Avatar extends StatelessWidget {
  final String initial;
  final double size;

  const _Avatar({required this.initial, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: CupertinoColors.activeBlue.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initial.toUpperCase(),
        style: TextStyle(
          fontSize: size * 0.5,
          fontWeight: FontWeight.w600,
          color: CupertinoColors.activeBlue,
        ),
      ),
    );
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
        showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
            title: const Text('오류'),
            content: Text('댓글 작성 실패: $e'),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.systemBackground.resolveFrom(context),
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: CupertinoTextField(
                controller: _controller,
                maxLines: 4,
                minLines: 1,
                placeholder: '댓글을 입력하세요',
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _submit(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            CupertinoButton(
              padding: const EdgeInsets.all(12),
              color: CupertinoColors.activeBlue,
              borderRadius: BorderRadius.circular(20),
              onPressed: _isLoading ? null : _submit,
              child: _isLoading
                  ? const CupertinoActivityIndicator(color: CupertinoColors.white, radius: 10)
                  : const Icon(CupertinoIcons.paperplane_fill, color: CupertinoColors.white, size: 22),
            ),
          ],
        ),
      ),
    );
  }
}
