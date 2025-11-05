class PostEntity {
  final int id;
  final String author_id;
  final String? title;
  final String? content;
  final String? image_url;
  final String? updated_at;
  final String? deleted_at;
  final String created_at;
  final bool is_block;
  final int likes_count;
  final int comments_count;

  PostEntity({
    required this.id,
    required this.author_id,
    required this.title,
    required this.content,
    required this.image_url,
    required this.updated_at,
    required this.deleted_at,
    required this.created_at,
    required this.is_block,
    required this.likes_count,
    required this.comments_count,
  });

  factory PostEntity.fromJson(Map<String, dynamic> json) {
    return PostEntity(
      id: json['id'] as int,
      author_id: json['author_id'] as String,
      title: json['title'] as String?,
      content: json['content'] as String?,
      image_url: json['image_url'] as String?,
      updated_at: json['updated_at'] as String?,
      deleted_at: json['deleted_at'] as String?,
      created_at: json['created_at'] as String,
      is_block: json['is_block'] as bool,
      likes_count: json['likes_count'] as int,
      comments_count: json['comments_count'] as int,
    );
  }
}
