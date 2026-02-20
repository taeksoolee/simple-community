class AuthResponse {
  final String accessToken;
  final UserInfo user;

  AuthResponse({required this.accessToken, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'] as String,
      user: UserInfo.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class UserInfo {
  final int id;
  final String emailAddress;

  UserInfo({required this.id, required this.emailAddress});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] as int,
      emailAddress: json['emailAddress'] as String,
    );
  }
}
