import 'package:todo_app/features/categories/data/models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<void> addCategory(CategoryModel category, String userId);
  Future<void> updateCategory(CategoryModel category, String userId);
  Future<void> deleteCategory(String categoryId, String userId);
  Stream<List<CategoryModel>> getCategories(String userId);
}
