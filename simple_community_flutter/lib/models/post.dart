import 'auth_response.dart';

class Post {
  final int id;
  final String title;
  final String body;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserInfo? user;

  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      userId: json['userId'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      user: json['user'] != null
          ? UserInfo.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }
}

class PostListResponse {
  final List<Post> items;
  final int total;
  final int page;
  final int perPage;
  final int totalPages;

  PostListResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.perPage,
    required this.totalPages,
  });

  factory PostListResponse.fromJson(Map<String, dynamic> json) {
    return PostListResponse(
      items: (json['items'] as List)
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      perPage: json['perPage'] as int,
      totalPages: json['totalPages'] as int,
    );
  }
}
