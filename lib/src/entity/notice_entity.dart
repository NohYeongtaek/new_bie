class NoticeEntity {
  final int id;
  final String? title;
  final String? content;
  final String? published_at;
  final String created_at;

  NoticeEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.published_at,
    required this.created_at,
  });

  factory NoticeEntity.fromJson(Map<String, dynamic> json) {
    return NoticeEntity(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      published_at: json['published_at'] as String,
      created_at: json['created_at'] as String,
    );
  }
}
