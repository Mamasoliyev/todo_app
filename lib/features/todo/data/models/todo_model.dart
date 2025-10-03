import 'package:cloud_firestore/cloud_firestore.dart';

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
    final createdAtField = map['createdAt'];
    DateTime createdAt;
    if (createdAtField is Timestamp) {
      createdAt = createdAtField.toDate();
    } else if (createdAtField is String) {
      createdAt = DateTime.tryParse(createdAtField) ?? DateTime.now();
    } else {
      createdAt = DateTime.now();
    }

    return TodoModel(
      id: id,
      title: map['title'] as String? ?? '',
      description: map['description'] as String?,
      isDone: map['isDone'] as bool? ?? false,
      createdAt: createdAt,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isDone': isDone,
      'createdAt': Timestamp.fromDate(createdAt),
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
