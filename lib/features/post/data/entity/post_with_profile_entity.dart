import 'category_type_entity.dart';

class PostWithProfileEntity {
  final int id;
  final String? title;
  final String? content;
  final String? image_url;
  final String? updated_at;
  final String? deleted_at;
  final String created_at;
  final bool is_block;
  int likes_count;
  int comments_count;
  bool? isLiked;
  final PostUserEntity user;
  final List<PostImageEntity> postImages;
  final List<CategoryEntity> categories;

  PostWithProfileEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.image_url,
    required this.updated_at,
    required this.deleted_at,
    required this.created_at,
    required this.is_block,
    required this.likes_count,
    required this.comments_count,
    required this.user,
    required this.postImages,
    required this.categories,
    required this.isLiked,
  });

  factory PostWithProfileEntity.fromJson(Map<String, dynamic> json) {
    return PostWithProfileEntity(
      id: json['id'] as int,
      title: json['title'] as String?,
      content: json['content'] as String?,
      image_url: json['image_url'] as String?,
      updated_at: json['updated_at'] as String?,
      deleted_at: json['deleted_at'] as String?,
      created_at: json['created_at'] as String,
      is_block: json['is_block'] as bool,
      likes_count: json['likes_count'] as int,
      comments_count: json['comments_count'] as int,
      user: PostUserEntity.fromJson(json['users']),
      postImages:
          (json['post_images'] as List<dynamic>?)
              ?.map((image) => PostImageEntity.fromJson(image))
              .toList() ??
          [],
      categories:
          (json['category'] as List<dynamic>?)
              ?.map((category) => CategoryEntity.fromJson(category))
              .toList() ??
          [],
      isLiked: json['is_liked'] as bool?,
    );
  }
}

class PostUserEntity {
  final String id;
  final String? nick_name;
  final String? profile_image;

  PostUserEntity({
    required this.id,
    required this.nick_name,
    required this.profile_image,
  });

  factory PostUserEntity.fromJson(Map<String, dynamic> json) {
    return PostUserEntity(
      id: json['id'] as String,
      nick_name: json['nick_name'] as String?,
      profile_image: json['profile_image'] as String?,
    );
  }
}

class PostImageEntity {
  final int id;
  final int index;
  final String image_url;
  final String created_at;

  PostImageEntity({
    required this.id,
    required this.index,
    required this.image_url,
    required this.created_at,
  });

  factory PostImageEntity.fromJson(Map<String, dynamic> json) {
    return PostImageEntity(
      id: json['id'] as int,
      index: json['index'] as int,
      image_url: json['image_url'] as String,
      created_at: json['created_at'] as String,
    );
  }
}

class CategoryEntity {
  final int id;
  final CategoryTypeEntity categoryType;

  CategoryEntity({required this.id, required this.categoryType});
  factory CategoryEntity.fromJson(Map<String, dynamic> json) {
    return CategoryEntity(
      id: json['id'] as int,
      categoryType: CategoryTypeEntity.fromJson(
        json['category_type'] as Map<String, dynamic>,
      ),
    );
  }
}
