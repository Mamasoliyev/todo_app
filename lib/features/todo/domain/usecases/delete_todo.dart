import 'package:todo_app/features/todo/domain/repo/todo_repo.dart';

class DeleteTodoUseCase {
  final TodoRepository repository;
  DeleteTodoUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.deleteTodo(id);
  }
}
