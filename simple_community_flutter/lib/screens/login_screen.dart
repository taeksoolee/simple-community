import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/app_theme.dart';
import 'package:go_router/go_router.dart';

import '../providers/api_provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validate() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    String? emailErr;
    String? passwordErr;
    if (email.isEmpty) {
      emailErr = '이메일을 입력해주세요';
    } else if (!email.contains('@')) {
      emailErr = '올바른 이메일 형식이 아닙니다';
    }
    if (password.isEmpty) passwordErr = '비밀번호를 입력해주세요';
    setState(() {
      _emailError = emailErr;
      _passwordError = passwordErr;
    });
    return emailErr == null && passwordErr == null;
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final client = ref.read(apiClientProvider);
      final res = await login(
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
        leading: AppTheme.navBarIconButton(
          icon: CupertinoIcons.back,
          onPressed: () => context.pop(),
        ),
        middle: const Text('로그인', style: AppTheme.navBarTitleStyle),
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
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: CupertinoColors.activeBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        CupertinoIcons.chat_bubble_2_fill,
                        size: 48,
                        color: CupertinoColors.activeBlue,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Simple Community에 오신 것을 환영합니다',
                      style: TextStyle(
                        fontSize: 15,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
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
                      Text(
                        _emailError!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: CupertinoColors.systemRed,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    CupertinoTextField(
                      controller: _passwordController,
                      placeholder: '비밀번호를 입력하세요',
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
                    if (_passwordError != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        _passwordError!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: CupertinoColors.systemRed,
                        ),
                      ),
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
                              child: Text(
                                _error!,
                                style: const TextStyle(color: CupertinoColors.systemRed, fontSize: 14),
                              ),
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
                          : const Text('로그인'),
                    ),
                    const SizedBox(height: 20),
                    CupertinoButton(
                      onPressed: () => context.push('/register'),
                      child: Text(
                        '계정이 없으신가요? 회원가입',
                        style: TextStyle(
                          fontSize: 15,
                          color: CupertinoColors.activeBlue,
                        ),
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
