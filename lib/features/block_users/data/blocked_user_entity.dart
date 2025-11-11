class BlockedUserEntity {
  final int id;
  final String user_id;
  final String blocked_user_id;
  final String created_at;

  BlockedUserEntity({
    required this.id,
    required this.user_id,
    required this.blocked_user_id,
    required this.created_at,
  });

  factory BlockedUserEntity.fromJson(Map<String, dynamic> json) {
    return BlockedUserEntity(
      id: json['id'] as int,
      user_id: json['user_id'] as String,
      blocked_user_id: json['blocked_user_id'] as String,
      created_at: json['created_at'] as String,
    );
  }
}
