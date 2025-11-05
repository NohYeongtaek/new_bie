class ReportPostEntity {
  final int id;
  final int postId;
  final String reporterId;
  final String reason;
  final String createdAt;
  final String? reviewedAt;

  ReportPostEntity({
    required this.id,
    required this.postId,
    required this.reporterId,
    required this.reason,
    required this.createdAt,
    this.reviewedAt,
  });

  factory ReportPostEntity.fromJson(Map<String, dynamic> json) {
    return ReportPostEntity(
      id: json['id'] as int,
      postId: json['post_id'] as int,
      reporterId: json['reporter_id'] as String,
      reason: json['reason'] as String,
      createdAt: json['created_at'] as String,
      reviewedAt: json['reviewed_at'] as String?,
    );
  }
}
