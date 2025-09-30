import '../../domain/entities/todo_entity.dart';

class TodoModel extends TodoEntity {
  TodoModel({
    required String id,
    required String title,
    String? description,
    required bool isDone,
    required DateTime createdAt,
  }) : super(
         id: id,
         title: title,
         description: description,
         isDone: isDone,
         createdAt: createdAt,
       );

  factory TodoModel.fromMap(String id, Map<String, dynamic> map) {
    return TodoModel(
      id: id,
      title: map['title'] as String? ?? '',
      description: map['description'] as String?,
      isDone: map['isDone'] as bool? ?? false,
      createdAt:
          (map['createdAt'] as TimestampWrapper?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isDone': isDone,
      'createdAt': createdAt.toIso8601String(), // store ISO string
    };
  }
}

// helper for typed cast if Firestore Timestamp not imported here; below in datasource we'll parse properly.
class TimestampWrapper {
  dynamic _t;
  TimestampWrapper(this._t);
  DateTime toDate() {
    try {
      // If real Firebase Timestamp
      return _t.toDate();
    } catch (_) {
      // If ISO string
      return DateTime.parse(_t as String);
    }
  }
}
