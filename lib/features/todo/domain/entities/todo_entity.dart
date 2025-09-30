class TodoEntity {
  final String id;
  final String title;
  final String? description;
  final bool isDone;
  final DateTime createdAt;

  const TodoEntity({
    required this.id,
    required this.title,
    this.description,
    required this.isDone,
    required this.createdAt,
  });

  TodoEntity copyWith({
    String? id,
    String? title,
    String? description,
    bool? isDone,
    DateTime? createdAt,
  }) {
    return TodoEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
