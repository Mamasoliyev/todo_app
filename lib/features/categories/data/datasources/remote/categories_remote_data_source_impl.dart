
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/features/categories/data/datasources/remote/categories_remote_data_source.dart';
import 'package:todo_app/features/categories/data/models/category_model.dart';

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final FirebaseFirestore firestore;

  CategoryRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> addCategory(CategoryModel category, String userId) async {
    final docRef = firestore
        .collection('profiles')
        .doc(userId)
        .collection('categories')
        .doc();
    await docRef.set(category.toFirestore()..addAll({'id': docRef.id}));
  }

  @override
  Future<void> updateCategory(CategoryModel category, String userId) async {
    await firestore
        .collection('profiles')
        .doc(userId)
        .collection('categories')
        .doc(category.id)
        .update(category.toFirestore());
  }

  @override
  Future<void> deleteCategory(String categoryId, String userId) async {
    await firestore
        .collection('profiles')
        .doc(userId)
        .collection('categories')
        .doc(categoryId)
        .delete();
  }

  @override
  Stream<List<CategoryModel>> getCategories(String userId) {
    return firestore
        .collection('profiles')
        .doc(userId)
        .collection('categories')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CategoryModel.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }
}
