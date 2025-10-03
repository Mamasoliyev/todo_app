import 'package:todo_app/features/categories/domain/repo/categories_repo.dart';

import '../entities/category.dart';

class AddCategory {
  final CategoryRepository repository;

  AddCategory(this.repository);

  Future<void> call(Category category, String userId) {
    return repository.addCategory(category, userId);
  }
}
