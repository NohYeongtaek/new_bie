class UserEntity {
  final String id;
  final String? profile_image;
  final String? nick_name;
  final String? introduction;
  final String created_at;
  final String? unregister_at;
  final int following_count;
  final int follower_count;
  final String? email;
  final bool is_blocked;

  String? profileImage;

  UserEntity({
    required this.id,
    required this.profile_image,
    required this.nick_name,
    required this.introduction,
    required this.created_at,
    required this.unregister_at,
    required this.following_count,
    required this.follower_count,
    required this.email,
    required this.is_blocked,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'] as String,
      profile_image: json['profile_image'] as String?,
      nick_name: json['nick_name'] as String?,
      introduction: json['introduction'] as String?,
      created_at: json['created_at'] as String,
      unregister_at: json['unregister_at'] as String?,
      following_count: json['following_count'] as int,
      follower_count: json['follower_count'] as int,
      email: json['email'] as String?,
      is_blocked: json['is_blocked'] as bool,
    );
  }

  operator [](int other) {}
}
