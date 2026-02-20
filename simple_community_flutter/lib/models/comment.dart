import 'auth_response.dart';

class Comment {
  final int id;
  final String body;
  final int userId;
  final int postId;
  final int? parentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserInfo? user;
  final List<Comment> replies;

  Comment({
    required this.id,
    required this.body,
    required this.userId,
    required this.postId,
    this.parentId,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.replies = const [],
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as int,
      body: json['body'] as String,
      userId: json['userId'] as int,
      postId: json['postId'] as int,
      parentId: json['parentId'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      user: json['user'] != null
          ? UserInfo.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      replies: (json['replies'] as List? ?? [])
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CommentListResponse {
  final List<Comment> items;
  final int total;
  final int page;
  final int perPage;
  final int totalPages;

  CommentListResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.perPage,
    required this.totalPages,
  });

  factory CommentListResponse.fromJson(Map<String, dynamic> json) {
    return CommentListResponse(
      items: (json['items'] as List)
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      perPage: json['perPage'] as int,
      totalPages: json['totalPages'] as int,
    );
  }
}
