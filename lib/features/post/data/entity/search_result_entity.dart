import 'package:new_bie/features/post/data/entity/post_with_profile_entity.dart';
import 'package:new_bie/features/post/data/entity/user_entity.dart';

class SearchResultEntity {
  final String keyword;
  final String type;
  final List<PostWithProfileEntity> posts;
  final List<UserEntity> users;
  final int total_count;

  SearchResultEntity({
    required this.keyword,
    required this.type,
    required this.posts,
    required this.users,
    required this.total_count,
  });

  factory SearchResultEntity.fromJson(Map<String, dynamic> json) {
    return SearchResultEntity(
      keyword: json['keyword'] as String,
      type: json['type'] as String,
      posts:
          (json['posts'] as List<dynamic>?)
              ?.map((category) => PostWithProfileEntity.fromJson(category))
              .toList() ??
          [],
      users:
          (json['users'] as List<dynamic>?)
              ?.map((category) => UserEntity.fromJson(category))
              .toList() ??
          [],
      total_count: json['total_count'] as int,
    );
  }
}
