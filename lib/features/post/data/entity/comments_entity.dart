class CommentEntity {
  final int id;
  final int postId;
  final String authorId;
  final String content;
  final String createdAt;

  CommentEntity({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.content,
    required this.createdAt,
  });

  factory CommentEntity.fromJson(Map<String, dynamic> json) {
    return CommentEntity(
      id: json['id'] as int,
      postId: json['post_id'] as int,
      authorId: json['author_id'] as String,
      content: json['content'] as String,
      createdAt: json['created_at'] as String,
    );
  }
}
