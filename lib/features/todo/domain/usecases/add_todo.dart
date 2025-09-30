import 'package:todo_app/features/todo/domain/repo/todo_repo.dart';

import '../entities/todo_entity.dart';

class AddTodoUseCase {
  final TodoRepository repository;
  AddTodoUseCase(this.repository);

  Future<void> call(TodoEntity todo) async {
    await repository.addTodo(todo);
  }
}
