import 'package:flutter_bloc/flutter_bloc.dart';
import 'todo_event.dart';
import 'todo_state.dart';
import '../../domain/usecases/add_todo.dart';
import '../../domain/usecases/get_todos.dart';
import '../../domain/usecases/update_todo.dart';
import '../../domain/usecases/delete_todo.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodosUseCase getTodos;
  final AddTodoUseCase addTodo;
  final UpdateTodoUseCase updateTodo;
  final DeleteTodoUseCase deleteTodo;

  TodoBloc({
    required this.getTodos,
    required this.addTodo,
    required this.updateTodo,
    required this.deleteTodo,
  }) : super(TodoInitial()) {
    on<LoadTodosEvent>(_onLoad);
    on<AddTodoEvent>(_onAdd);
    on<UpdateTodoEvent>(_onUpdate);
    on<DeleteTodoEvent>(_onDelete);
  }

  Future<void> _onLoad(LoadTodosEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todosList = await getTodos();
      emit(TodoLoaded(todosList));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onAdd(AddTodoEvent event, Emitter<TodoState> emit) async {
    try {
      await addTodo(event.todo);
      add(LoadTodosEvent());
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onUpdate(UpdateTodoEvent event, Emitter<TodoState> emit) async {
    try {
      await updateTodo(event.todo);
      add(LoadTodosEvent());
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onDelete(DeleteTodoEvent event, Emitter<TodoState> emit) async {
    try {
      await deleteTodo(event.id);
      add(LoadTodosEvent());
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }
}
