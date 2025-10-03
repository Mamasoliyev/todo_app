import 'package:equatable/equatable.dart';
import '../../domain/entities/category.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {
  final String userId;

  const LoadCategories(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddCategoryEvent extends CategoryEvent {
  final Category category;
  final String userId;

  const AddCategoryEvent(this.category, this.userId);

  @override
  List<Object?> get props => [category, userId];
}

class UpdateCategoryEvent extends CategoryEvent {
  final Category category;
  final String userId;

  const UpdateCategoryEvent(this.category, this.userId);

  @override
  List<Object?> get props => [category, userId];
}

class DeleteCategoryEvent extends CategoryEvent {
  final String categoryId;
  final String userId;

  const DeleteCategoryEvent(this.categoryId, this.userId);

  @override
  List<Object?> get props => [categoryId, userId];
}
