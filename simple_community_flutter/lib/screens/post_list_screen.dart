import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../models/post.dart';
import '../providers/api_provider.dart';
import '../providers/posts_provider.dart';

class PostListScreen extends ConsumerStatefulWidget {
  const PostListScreen({super.key});

  @override
  ConsumerState<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends ConsumerState<PostListScreen> {
  Future<void> _logout() async {
    await ref.read(tokenProvider.notifier).clear();
    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(postsListProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        border: null,
        middle: const Text('Simple Community', style: AppTheme.navBarTitleStyle),
        trailing: _NavBarActions(
          onLogin: () => context.push('/login'),
          onLogout: _logout,
          onWrite: () => context.push('/posts/new'),
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                ref.invalidate(postsListProvider);
              },
            ),
            SliverFillRemaining(
              child: postsAsync.when(
                loading: () => const Center(
                  child: CupertinoActivityIndicator(radius: 12),
                ),
                error: (e, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.wifi_slash, size: 48, color: CupertinoColors.systemGrey),
                        const SizedBox(height: 16),
                        Text(
                          '연결할 수 없어요',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.label.resolveFrom(context),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$e',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: CupertinoColors.secondaryLabel.resolveFrom(context),
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 24),
                        CupertinoButton.filled(
                          onPressed: () => ref.invalidate(postsListProvider),
                          child: const Text('다시 시도'),
                        ),
                      ],
                    ),
                  ),
                ),
                data: (res) {
                  if (res.items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.doc_text,
                            size: 56,
                            color: CupertinoColors.systemGrey2,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '아직 게시글이 없어요',
                            style: TextStyle(
                              color: CupertinoColors.secondaryLabel.resolveFrom(context),
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: res.items.length + (res.page < res.totalPages ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == res.items.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: CupertinoButton(
                              onPressed: () {
                                ref.read(postsListProvider.notifier).loadMore();
                              },
                              child: const Text('더 보기'),
                            ),
                          ),
                        );
                      }
                      final post = res.items[index];
                      return _PostCell(post: post);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarActions extends ConsumerWidget {
  final VoidCallback onLogin;
  final VoidCallback onLogout;
  final VoidCallback onWrite;

  const _NavBarActions({
    required this.onLogin,
    required this.onLogout,
    required this.onWrite,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final token = ref.watch(tokenProvider).valueOrNull;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (token != null)
          AppTheme.navBarIconButton(
            icon: CupertinoIcons.add,
            onPressed: onWrite,
          ),
        AppTheme.navBarIconButton(
          icon: token != null ? CupertinoIcons.square_arrow_right : CupertinoIcons.person_circle,
          onPressed: token != null ? onLogout : onLogin,
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final String initial;

  const _Avatar({required this.initial});

  @override
  Widget build(BuildContext context) {
    const size = 24.0;
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

class _PostCell extends StatelessWidget {
  final Post post;

  const _PostCell({required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push('/posts/${post.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17,
                color: CupertinoColors.label,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              post.body,
              style: TextStyle(
                fontSize: 15,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _Avatar(initial: (post.user?.emailAddress ?? '?')[0].toUpperCase()),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    post.user?.emailAddress ?? '알 수 없음',
                    style: TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  DateFormat('MM/dd HH:mm').format(post.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
