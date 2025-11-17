class FollowEntity {
  final int id;
  final String follower_id;
  final String following_id;
  final String created_at;

  FollowEntity({
    required this.id,
    required this.created_at,
    required this.follower_id,
    required this.following_id,
  });

  factory FollowEntity.fromJson(Map<String, dynamic> json) {
    return FollowEntity(
      id: json['id'] as int,
      created_at: json['created_at'] as String,
      follower_id: json['follower_id'] as String,
      following_id: json['following_id'] as String,
    );
  }
}
