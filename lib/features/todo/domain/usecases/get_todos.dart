import 'package:todo_app/features/todo/domain/repo/todo_repo.dart';

import '../entities/todo_entity.dart';

class GetTodosUseCase {
  final TodoRepository repository;
  GetTodosUseCase(this.repository);

  Future<List<TodoEntity>> call() async {
    return repository.getTodos();
  }
}
