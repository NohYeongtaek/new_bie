class LikeEntity {
  final int id;
  final int postId;
  final String userId;
  final String createdAt;

  LikeEntity({
    required this.id,
    required this.postId,
    required this.userId,
    required this.createdAt,
  });

  factory LikeEntity.fromJson(Map<String, dynamic> json) {
    return LikeEntity(
      id: json['id'] as int,
      postId: json['post_id'] as int,
      userId: json['user_id'] as String,
      createdAt: json['created_at'] as String,
    );
  }
}
