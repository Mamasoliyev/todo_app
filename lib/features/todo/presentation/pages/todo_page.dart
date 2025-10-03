
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/core/bloc/theme_bloc/app_theme_cubit.dart';
import 'package:todo_app/core/bloc/theme_bloc/app_theme_state.dart';
import 'package:todo_app/core/style/app_color.dart';
import 'package:todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_event.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_state.dart';
import 'package:todo_app/gen/fonts.gen.dart';
import 'package:todo_app/generated/locale_keys.g.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {

  void _openTodoDialog(BuildContext context, {TodoEntity? todo}) {
    final controller = TextEditingController(text: todo?.title ?? '');
    final isEdit = todo != null;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          isEdit ? LocaleKeys.edit_todo.tr() : LocaleKeys.add_todo.tr(),
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: LocaleKeys.enter_task.tr(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(LocaleKeys.cancel.tr()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
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
            child: Text(
              isEdit ? LocaleKeys.save.tr() : LocaleKeys.add_todo.tr(),
            ),
          ),
        ],
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    context.read<TodoBloc>().add(LoadTodosEvent());
  }


  @override
  Widget build(BuildContext context) {
  String _selectedLang = context.savedLocale!.languageCode.toString();

    context.read<TodoBloc>().add(LoadTodosEvent());
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 88.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: DropdownButton<String>(
                dropdownColor: AppColors.primary,
                focusColor: AppColors.primary,
                value: _selectedLang,
                underline: const SizedBox(),
                borderRadius: BorderRadius.circular(12.r),
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                alignment: AlignmentDirectional.topEnd,
                selectedItemBuilder: (context) {
                  return [
                    const CircleAvatar(
                      backgroundColor: AppColors.productDark,
                      child: Text("🇺🇿"),
                    ),
                    const CircleAvatar(
                      backgroundColor: AppColors.productDark,
                      child: Text("🇬🇧"),
                    ),
                    const CircleAvatar(
                      backgroundColor: AppColors.productDark,
                      child: Text("🇷🇺"),
                    ),
                  ];
                },
                items: const [
                  DropdownMenuItem(
                    value: "uz",
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: [
                          Text("🇺🇿 "),
                          SizedBox(width: 6),
                          Text(
                            "Uzbek",
                            style: TextStyle(fontFamily: FontFamily.comfortaa),
                          ),
                        ],
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "en",
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: [
                          Text("🇬🇧 "),
                          SizedBox(width: 6),
                          Text(
                            "English",
                            style: TextStyle(fontFamily: FontFamily.comfortaa),
                          ),
                        ],
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "ru",
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: [
                          Text("🇷🇺 "),
                          SizedBox(width: 6),
                          Text(
                            "Русский",
                            style: TextStyle(fontFamily: FontFamily.comfortaa),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                onChanged: (value) async {
                  setState(() {
                    _selectedLang = value!;
                  });

                  if (value == "en") {
                    await context.setLocale(const Locale("en", "US"));
                  } else if (value == "ru") {
                    await context.setLocale(const Locale("ru", "RU"));
                  } else if (value == "uz") {
                    await context.setLocale(const Locale("uz", "UZ"));
                  }
                },
              ),
            ),
          ),
        ),
        title: Text(
          LocaleKeys.my_todos.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              final isDark = state.themeMode == ThemeMode.dark;
              return IconButton(
                onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) =>
                      RotationTransition(turns: anim, child: child),
                  child: Icon(
                    isDark
                        ? Icons.wb_sunny_rounded
                        : Icons.nightlight_round_rounded,
                    key: ValueKey(isDark),
                    color: AppColors.primary,
                  ),
                ),
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
              return Center(
                child: Text(
                  LocaleKeys.no_tasks.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                ),
              );
            }
            return ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: state.todos.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
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
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: todo.isDone
                          ? AppColors.primary.withOpacity(0.1)
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Theme.of(context).brightness == Brightness.dark
                          ? Border.all(color: Colors.white.withOpacity(0.08))
                          : null,
                      boxShadow:
                          Theme.of(context).brightness == Brightness.light
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          value: todo.isDone,
                          activeColor: AppColors.primary,
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
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              decoration: todo.isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: todo.isDone ? AppColors.primary : null,
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
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        onPressed: () => _openTodoDialog(context),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
