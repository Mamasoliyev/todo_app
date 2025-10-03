import '../entities/category.dart';

abstract class CategoryRepository {
  Future<void> addCategory(Category category, String userId);
  Future<void> updateCategory(Category category, String userId);
  Future<void> deleteCategory(String categoryId, String userId);
  Stream<List<Category>> getCategories(String userId);
}
