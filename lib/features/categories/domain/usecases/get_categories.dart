import 'package:todo_app/features/categories/domain/repo/categories_repo.dart';

import '../entities/category.dart';

class GetCategories {
  final CategoryRepository repository;

  GetCategories(this.repository);

  Stream<List<Category>> call(String userId) {
    return repository.getCategories(userId);
  }
}
