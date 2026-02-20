import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(postsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Community'),
        centerTitle: true,
        actions: [
          ref.watch(tokenProvider).whenOrNull(
                data: (token) => token != null
                    ? IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () async {
                          await ref.read(tokenProvider.notifier).clear();
                          if (mounted) context.go('/login');
                        },
                      )
                    : IconButton(
                        icon: const Icon(Icons.login),
                        onPressed: () => context.push('/login'),
                      ),
              ) ??
              IconButton(
                icon: const Icon(Icons.login),
                onPressed: () => context.push('/login'),
              ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(postsListProvider);
        },
        child: postsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('오류: $e', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(postsListProvider),
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          ),
          data: (res) {
            if (res.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.post_add, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      '아직 게시글이 없어요',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: res.items.length + (res.page < res.totalPages ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == res.items.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          ref.read(postsListProvider.notifier).loadMore();
                        },
                        child: const Text('더 보기'),
                      ),
                    ),
                  );
                }
                final post = res.items[index];
                return _PostCard(post: post);
              },
            );
          },
        ),
      ),
      floatingActionButton: ref.watch(tokenProvider).whenOrNull(
            data: (token) => token != null
                ? FloatingActionButton.extended(
                    onPressed: () => context.push('/posts/new'),
                    icon: const Icon(Icons.add),
                    label: const Text('글쓰기'),
                  )
                : null,
          ) ??
          null,
    );
  }
}

class _PostCard extends StatelessWidget {
  final Post post;

  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/posts/${post.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                post.body,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.person_outline, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    post.user?.emailAddress ?? '알 수 없음',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    DateFormat('MM/dd HH:mm').format(post.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
