class FollowEntity {
  final int id;
  final String following_user_id;
  final String follower_user_id;
  final String created_at;

  FollowEntity({
    required this.id,
    required this.created_at,
    required this.follower_user_id,
    required this.following_user_id,
  });

  factory FollowEntity.fromJson(Map<String, dynamic> json) {
    return FollowEntity(
      id: json['id'] as int,
      created_at: json['created_at'] as String,
      follower_user_id: json['follower_user_id'] as String,
      following_user_id: json['following_user_id'] as String,
    );
  }
}
