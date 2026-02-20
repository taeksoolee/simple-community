import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api_error.dart';
import '../core/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_community_api/simple_community_api.dart';

import '../models/post.dart';
import '../providers/api_provider.dart';
import '../providers/post_detail_provider.dart';
import '../providers/posts_provider.dart';

class PostFormScreen extends ConsumerStatefulWidget {
  final int? postId;

  const PostFormScreen({super.key, this.postId});

  @override
  ConsumerState<PostFormScreen> createState() => _PostFormScreenState();
}

class _PostFormScreenState extends ConsumerState<PostFormScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  String? _titleError;
  String? _bodyError;
  bool _loaded = false;

  void _loadPost(Post post) {
    if (!_loaded) {
      _loaded = true;
      _titleController.text = post.title;
      _bodyController.text = post.body;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  bool _validate() {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    setState(() {
      _titleError = title.isEmpty ? '제목을 입력해주세요' : null;
      _bodyError = body.isEmpty ? '본문을 입력해주세요' : null;
    });
    return _titleError == null && _bodyError == null;
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final client = ref.read(apiClientProvider);
      if (widget.postId != null) {
        await client.api.postsControllerUpdate(
          id: widget.postId!,
          updatePostDto: UpdatePostDto((b) => b
            ..title = _titleController.text.trim()
            ..body = _bodyController.text.trim()),
        );
      } else {
        await client.api.postsControllerCreate(
          createPostDto: CreatePostDto((b) => b
            ..title = _titleController.text.trim()
            ..body = _bodyController.text.trim()),
        );
      }
      if (mounted) {
        ref.invalidate(postsListProvider);
        context.go('/');
      }
    } catch (e) {
      setState(() {
        _error = parseApiError(e);
        _isLoading = false;
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.postId != null;
    if (isEdit) {
      ref.listen(postDetailProvider(widget.postId!), (_, next) {
        next.whenData(_loadPost);
      });
    }

    final postAsync = isEdit ? ref.watch(postDetailProvider(widget.postId!)) : null;

    if (isEdit && postAsync != null && postAsync.isLoading) {
      return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          border: null,
          middle: Text('게시글 수정', style: AppTheme.navBarTitleStyle),
        ),
        child: const Center(child: CupertinoActivityIndicator(radius: 14)),
      );
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        border: null,
        leading: AppTheme.navBarIconButton(
          icon: CupertinoIcons.back,
          onPressed: () => context.pop(),
        ),
        middle: Text(
          isEdit ? '게시글 수정' : '글쓰기',
          style: AppTheme.navBarTitleStyle,
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          minimumSize: const Size(AppTheme.navBarButtonSize, AppTheme.navBarButtonSize),
          onPressed: _isLoading ? null : _submit,
          child: SizedBox(
            width: AppTheme.navBarButtonSize,
            height: AppTheme.navBarButtonSize,
            child: Center(
              child: _isLoading
                  ? const CupertinoActivityIndicator(radius: 10)
                  : Text(isEdit ? '저장' : '등록'),
            ),
          ),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CupertinoTextField(
                controller: _titleController,
                placeholder: '제목을 입력하세요',
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              if (_titleError != null) ...[
                const SizedBox(height: 6),
                Text(_titleError!, style: const TextStyle(fontSize: 13, color: CupertinoColors.systemRed)),
              ],
              const SizedBox(height: 20),
              CupertinoTextField(
                controller: _bodyController,
                placeholder: '본문을 입력하세요',
                maxLines: 12,
                minLines: 8,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              if (_bodyError != null) ...[
                const SizedBox(height: 6),
                Text(_bodyError!, style: const TextStyle(fontSize: 13, color: CupertinoColors.systemRed)),
              ],
              if (_error != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemRed.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.exclamationmark_circle_fill, color: CupertinoColors.systemRed, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(_error!, style: const TextStyle(color: CupertinoColors.systemRed, fontSize: 14)),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
