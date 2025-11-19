import 'post_with_profile_entity.dart';

class CommentWithProfileEntity {
  final int id;
  final int postId;
  final String? authorId;
  String? content;
  final String? deleted_at;
  final String createdAt;
  final bool is_block;
  final PostUserEntity user;

  CommentWithProfileEntity({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.content,
    required this.deleted_at,
    required this.createdAt,
    required this.is_block,
    required this.user,
  });

  factory CommentWithProfileEntity.fromJson(Map<String, dynamic> json) {
    return CommentWithProfileEntity(
      id: json['id'] as int,
      postId: json['post_id'] as int,
      authorId: json['author_id'] as String?,
      content: json['content'] as String?,
      deleted_at: json['deleted_at'] as String?,
      createdAt: json['created_at'] as String,
      is_block: json['is_block'] as bool,
      user: PostUserEntity.fromJson(json['users']),
    );
  }
}
