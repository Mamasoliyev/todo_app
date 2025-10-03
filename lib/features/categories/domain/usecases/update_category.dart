import 'package:todo_app/features/categories/domain/repo/categories_repo.dart';
import '../entities/category.dart';

class UpdateCategory {
  final CategoryRepository repository;

  UpdateCategory(this.repository);

  Future<void> call(Category category, String userId) {
    return repository.updateCategory(category, userId);
  }
}
