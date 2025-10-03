import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_category.dart';
import '../../domain/usecases/delete_category.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/update_category.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final AddCategory addCategory;
  final UpdateCategory updateCategory;
  final DeleteCategory deleteCategory;
  final GetCategories getCategories;

  CategoryBloc({
    required this.addCategory,
    required this.updateCategory,
    required this.deleteCategory,
    required this.getCategories,
  }) : super(CategoryInitial()) {
    on<LoadCategories>((event, emit) async {
      emit(CategoryLoading());
      try {
        await emit.forEach(
          getCategories(event.userId),
          onData: (categories) => CategoryLoaded(categories),
          onError: (_, __) => const CategoryError("Failed to load categories"),
        );
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });

    on<AddCategoryEvent>((event, emit) async {
      try {
        await addCategory(event.category, event.userId);
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });

    on<UpdateCategoryEvent>((event, emit) async {
      try {
        await updateCategory(event.category, event.userId);
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });

    on<DeleteCategoryEvent>((event, emit) async {
      try {
        await deleteCategory(event.categoryId, event.userId);
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });
  }
}
