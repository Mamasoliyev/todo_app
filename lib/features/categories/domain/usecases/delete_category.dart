import 'package:todo_app/features/categories/domain/repo/categories_repo.dart';

class DeleteCategory {
  final CategoryRepository repository;

  DeleteCategory(this.repository);

  Future<void> call(String categoryId, String userId) {
    return repository.deleteCategory(categoryId, userId);
  }
}
