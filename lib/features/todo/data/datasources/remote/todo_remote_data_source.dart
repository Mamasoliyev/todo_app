
import 'package:todo_app/features/todo/data/models/todo_model.dart';

abstract class TodoRemoteDataSource {
  Future<void> addTodo(TodoModel todo);
  Future<List<TodoModel>> getTodos();
  Future<void> updateTodo(TodoModel todo);
  Future<void> deleteTodo(String id);
}

