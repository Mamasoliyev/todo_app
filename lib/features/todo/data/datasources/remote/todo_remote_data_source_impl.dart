import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/features/todo/data/datasources/remote/todo_remote_data_source.dart';
import 'package:todo_app/features/todo/data/models/todo_model.dart';

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final FirebaseFirestore firestore;
  final String collectionName;

  TodoRemoteDataSourceImpl({
    required this.firestore,
    this.collectionName = 'todos',
  });

  CollectionReference get _col => firestore.collection(collectionName);

  @override
  Future<void> addTodo(TodoModel todo) async {
    final docRef = _col.doc(todo.id);
    await docRef.set({
      'user_id': FirebaseAuth.instance.currentUser?.uid,
      'title': todo.title,
      'description': todo.description,
      'isDone': todo.isDone,
      'createdAt': Timestamp.fromDate(todo.createdAt),
    });
  }

  @override
  Future<void> deleteTodo(String id) async {
    await _col.doc(id).delete();
  }

  @override
  Future<List<TodoModel>> getTodos() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return [];

    // Composite index bo‘yicha query
    final snapshot = await _col
        .where('user_id', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((d) {
      final data = d.data() as Map<String, dynamic>;
      final createdAtField = data['createdAt'];
      DateTime createdAt;
      if (createdAtField is Timestamp) {
        createdAt = createdAtField.toDate();
      } else if (createdAtField is String) {
        createdAt = DateTime.tryParse(createdAtField) ?? DateTime.now();
      } else {
        createdAt = DateTime.now();
      }
      return TodoModel(
        id: d.id,
        title: data['title'] as String? ?? '',
        description: data['description'] as String?,
        isDone: data['isDone'] as bool? ?? false,
        createdAt: createdAt,
      );
    }).toList();
  }

  @override
  Future<void> updateTodo(TodoModel todo) async {
    await _col.doc(todo.id).update({
      'title': todo.title,
      'description': todo.description,
      'isDone': todo.isDone,
    });
  }
}
