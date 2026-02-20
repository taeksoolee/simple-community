import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../core/api_client.dart';

const _tokenKey = 'access_token';

final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient(baseUrl: ApiConfig.baseUrl);
  ref.listen(tokenProvider, (_, next) {
    next.whenData((token) {
      if (token != null) {
        client.setAccessToken(token);
      } else {
        client.clearAccessToken();
      }
    });
  });
  final token = ref.watch(tokenProvider).valueOrNull;
  if (token != null) client.setAccessToken(token);
  return client;
});

final tokenProvider = StateNotifierProvider<TokenNotifier, AsyncValue<String?>>((ref) {
  return TokenNotifier();
});

class TokenNotifier extends StateNotifier<AsyncValue<String?>> {
  TokenNotifier() : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = AsyncValue.data(prefs.getString(_tokenKey));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> setToken(String token) async {
    state = AsyncValue.data(token);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> clear() async {
    state = const AsyncValue.data(null);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
