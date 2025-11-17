class CategoryTypeEntity {
  final int id;
  final String type_title;

  CategoryTypeEntity({required this.id, required this.type_title});

  factory CategoryTypeEntity.fromJson(Map<String, dynamic> json) {
    return CategoryTypeEntity(
      id: json['id'] as int,
      type_title: json['type_title'] as String,
    );
  }
}
