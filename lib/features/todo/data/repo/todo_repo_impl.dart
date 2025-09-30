import 'package:todo_app/features/todo/data/datasources/remote/todo_remote_data_source.dart';
import 'package:todo_app/features/todo/domain/repo/todo_repo.dart';

import '../../domain/entities/todo_entity.dart';
import '../models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;
  TodoRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addTodo(TodoEntity todo) => remoteDataSource.addTodo(
    TodoModel(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      isDone: todo.isDone,
      createdAt: todo.createdAt,
    ),
  );

  @override
  Future<void> deleteTodo(String id) => remoteDataSource.deleteTodo(id);

  @override
  Future<List<TodoEntity>> getTodos() async {
    final models = await remoteDataSource.getTodos();
    return models.map((m) => m as TodoEntity).toList();
  }

  @override
  Future<void> updateTodo(TodoEntity todo) => remoteDataSource.updateTodo(
    TodoModel(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      isDone: todo.isDone,
      createdAt: todo.createdAt,
    ),
  );
}
