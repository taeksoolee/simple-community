import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_community_api/simple_community_api.dart';

import '../models/post.dart';
import '../providers/api_provider.dart';
import '../providers/post_detail_provider.dart';

class PostFormScreen extends ConsumerStatefulWidget {
  final int? postId;

  const PostFormScreen({super.key, this.postId});

  @override
  ConsumerState<PostFormScreen> createState() => _PostFormScreenState();
}

class _PostFormScreenState extends ConsumerState<PostFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isLoading = false;
  String? _error;

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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
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
        context.go('/');
      }
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
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
      return Scaffold(
        appBar: AppBar(title: const Text('게시글 수정')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? '게시글 수정' : '글쓰기'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _submit,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(isEdit ? '저장' : '등록'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '제목',
                  hintText: '제목을 입력하세요',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? '제목을 입력해주세요' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bodyController,
                maxLines: 10,
                decoration: const InputDecoration(
                  labelText: '본문',
                  hintText: '본문을 입력하세요',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? '본문을 입력해주세요' : null,
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_error!, style: TextStyle(color: Colors.red[700])),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
