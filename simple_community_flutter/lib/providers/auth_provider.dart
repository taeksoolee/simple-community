import 'package:simple_community_api/simple_community_api.dart';

import '../core/api_client.dart';
import '../models/auth_response.dart';

Future<AuthResponse> login(ApiClient client, String email, String password) async {
  final res = await client.api.authControllerLogin(
    loginDto: LoginDto((b) => b
      ..emailAddress = email
      ..password = password),
  );
  if (res.statusCode != 201) {
    throw Exception(res.statusMessage ?? '로그인 실패');
  }
  return AuthResponse.fromJson(res.data as Map<String, dynamic>);
}

Future<AuthResponse> register(
    ApiClient client, String email, String password) async {
  final res = await client.api.authControllerRegister(
    registerDto: RegisterDto((b) => b
      ..emailAddress = email
      ..password = password),
  );
  if (res.statusCode != 201) {
    final msg = (res.data as Map?)?['message'] ?? '회원가입 실패';
    throw Exception(msg.toString());
  }
  return AuthResponse.fromJson(res.data as Map<String, dynamic>);
}
