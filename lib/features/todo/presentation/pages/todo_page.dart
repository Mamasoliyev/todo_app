import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/bloc/theme_bloc/app_theme_cubit.dart';
import 'package:todo_app/core/bloc/theme_bloc/app_theme_state.dart';
import 'package:todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_event.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_state.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  void _openTodoDialog(BuildContext context, {TodoEntity? todo}) {
    final controller = TextEditingController(text: todo?.title ?? '');
    final isEdit = todo != null;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isEdit ? "Edit Todo" : "Add Todo"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Enter task...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              final title = controller.text.trim();
              if (title.isNotEmpty) {
                if (isEdit) {
                  context.read<TodoBloc>().add(
                    UpdateTodoEvent(todo.copyWith(title: title)),
                  );
                } else {
                  final newTodo = TodoEntity(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: title,
                    description: null,
                    isDone: false,
                    createdAt: DateTime.now(),
                  );
                  context.read<TodoBloc>().add(AddTodoEvent(newTodo));
                }
                Navigator.pop(context);
              }
            },

            child: Text(isEdit ? "Save" : "Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xfff6f8fb),
      appBar: AppBar(
        title: const Text(
          "My Todos",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        // backgroundColor: Colors.white,
        // foregroundColor: Colors.black,
        actions: [
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return Switch(
                value: state.themeMode == ThemeMode.dark,
                onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
              );
            },
          ),
        ],
      ),

      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded) {
            if (state.todos.isEmpty) {
              return const Center(
                child: Text(
                  "No tasks yet.\nTap + to add one!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.todos.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final todo = state.todos[index];
                return Dismissible(
                  key: Key(todo.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    context.read<TodoBloc>().add(DeleteTodoEvent(todo.id));
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          value: todo.isDone,
                          onChanged: (_) {
                            context.read<TodoBloc>().add(
                              UpdateTodoEvent(
                                todo.copyWith(isDone: !todo.isDone),
                              ),
                            );
                          },
                        ),
                        Expanded(
                          child: Text(
                            todo.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              decoration: todo.isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: todo.isDone ? Colors.grey : Colors.black87,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () => _openTodoDialog(context, todo: todo),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is TodoError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => _openTodoDialog(context),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
