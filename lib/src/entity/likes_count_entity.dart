class LikesCountEntity {
  final int likes_count;

  LikesCountEntity({required this.likes_count});

  factory LikesCountEntity.fromJson(Map<String, dynamic> json) {
    return LikesCountEntity(likes_count: json['likes_count'] as int);
  }
}
