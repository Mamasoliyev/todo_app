import 'package:todo_app/features/todo/domain/repo/todo_repo.dart';

import '../entities/todo_entity.dart';

class UpdateTodoUseCase {
  final TodoRepository repository;
  UpdateTodoUseCase(this.repository);

  Future<void> call(TodoEntity todo) async {
    await repository.updateTodo(todo);
  }
}
