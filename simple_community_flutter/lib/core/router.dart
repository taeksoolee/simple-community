import 'package:go_router/go_router.dart';

import '../screens/login_screen.dart';
import '../screens/post_detail_screen.dart';
import '../screens/post_form_screen.dart';
import '../screens/post_list_screen.dart';
import '../screens/register_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const PostListScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (_, __) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/posts/new',
      builder: (_, __) => const PostFormScreen(),
    ),
    GoRoute(
      path: '/posts/:id',
      builder: (_, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
        return PostDetailScreen(postId: id);
      },
    ),
    GoRoute(
      path: '/posts/:id/edit',
      builder: (_, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
        return PostFormScreen(postId: id);
      },
    ),
  ],
);
