import 'package:todo_app/features/categories/data/datasources/remote/categories_remote_data_source.dart';
import 'package:todo_app/features/categories/domain/repo/categories_repo.dart';

import '../../domain/entities/category.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addCategory(Category category, String userId) {
    return remoteDataSource.addCategory(
      CategoryModel(
        id: category.id,
        name: category.name,
        createdAt: category.createdAt,
      ),
      userId,
    );
  }

  @override
  Future<void> updateCategory(Category category, String userId) {
    return remoteDataSource.updateCategory(
      CategoryModel(
        id: category.id,
        name: category.name,
        createdAt: category.createdAt,
      ),
      userId,
    );
  }

  @override
  Future<void> deleteCategory(String categoryId, String userId) {
    return remoteDataSource.deleteCategory(categoryId, userId);
  }

  @override
  Stream<List<Category>> getCategories(String userId) {
    return remoteDataSource.getCategories(userId);
  }
}
