import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/api_provider.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  String? _emailError;
  String? _passwordError;
  String? _passwordConfirmError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  bool _validate() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _passwordConfirmController.text;
    String? emailErr;
    String? passwordErr;
    String? confirmErr;
    if (email.isEmpty) {
      emailErr = '이메일을 입력해주세요';
    } else if (!email.contains('@')) {
      emailErr = '올바른 이메일 형식이 아닙니다';
    }
    if (password.isEmpty) {
      passwordErr = '비밀번호를 입력해주세요';
    } else if (password.length < 6) {
      passwordErr = '비밀번호는 6자 이상이어야 합니다';
    }
    if (password != confirm) {
      confirmErr = '비밀번호가 일치하지 않습니다';
    }
    setState(() {
      _emailError = emailErr;
      _passwordError = passwordErr;
      _passwordConfirmError = confirmErr;
    });
    return emailErr == null && passwordErr == null && confirmErr == null;
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final client = ref.read(apiClientProvider);
      final res = await register(
        client,
        _emailController.text.trim().toLowerCase(),
        _passwordController.text,
      );
      await ref.read(tokenProvider.notifier).setToken(res.accessToken);
      if (mounted) context.go('/');
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => context.pop(),
          child: const Icon(CupertinoIcons.back),
        ),
        middle: const Text(
          '회원가입',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      '새로운 계정을 만들어보세요',
                      style: TextStyle(
                        fontSize: 15,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                    ),
                    const SizedBox(height: 32),
                    CupertinoTextField(
                      controller: _emailController,
                      placeholder: '이메일 주소를 입력하세요',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Icon(CupertinoIcons.mail_solid, size: 20, color: CupertinoColors.systemGrey),
                      ),
                    ),
                    if (_emailError != null) ...[
                      const SizedBox(height: 6),
                      Text(_emailError!, style: const TextStyle(fontSize: 13, color: CupertinoColors.systemRed)),
                    ],
                    const SizedBox(height: 16),
                    CupertinoTextField(
                      controller: _passwordController,
                      placeholder: '비밀번호 (6자 이상)',
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Icon(CupertinoIcons.lock_fill, size: 20, color: CupertinoColors.systemGrey),
                      ),
                    ),
                    if (_passwordError != null) ...[
                      const SizedBox(height: 6),
                      Text(_passwordError!, style: const TextStyle(fontSize: 13, color: CupertinoColors.systemRed)),
                    ],
                    const SizedBox(height: 16),
                    CupertinoTextField(
                      controller: _passwordConfirmController,
                      placeholder: '비밀번호를 다시 입력하세요',
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Icon(CupertinoIcons.lock_fill, size: 20, color: CupertinoColors.systemGrey),
                      ),
                    ),
                    if (_passwordConfirmError != null) ...[
                      const SizedBox(height: 6),
                      Text(_passwordConfirmError!, style: const TextStyle(fontSize: 13, color: CupertinoColors.systemRed)),
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
                    const SizedBox(height: 32),
                    CupertinoButton.filled(
                      onPressed: _isLoading ? null : _submit,
                      child: _isLoading
                          ? const CupertinoActivityIndicator(color: CupertinoColors.white, radius: 10)
                          : const Text('가입하기'),
                    ),
                    const SizedBox(height: 20),
                    CupertinoButton(
                      onPressed: () => context.pop(),
                      child: Text(
                        '이미 계정이 있으신가요? 로그인',
                        style: TextStyle(fontSize: 15, color: CupertinoColors.activeBlue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
