import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/core/bloc/theme_bloc/app_theme_cubit.dart';
import 'package:todo_app/core/bloc/theme_bloc/app_theme_state.dart';
import 'package:todo_app/core/cache/cache_helper.dart';
import 'package:todo_app/core/style/app_color.dart';
import 'package:todo_app/core/utils/helper/app_toast.dart';
import 'package:todo_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_event.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_state.dart';
import 'package:todo_app/gen/fonts.gen.dart';
import 'package:todo_app/generated/locale_keys.g.dart';
import 'package:another_flushbar/flushbar.dart';

// class AppToast {
//   static void _show(
//     BuildContext context,
//     String message, {
//     Color backgroundColor = Colors.black87,
//     IconData? icon,
//     Duration duration = const Duration(seconds: 2),
//   }) {
//     Flushbar(
//       message: message,
//       backgroundColor: backgroundColor,
//       duration: duration,
//       borderRadius: BorderRadius.circular(12),
//       margin: const EdgeInsets.all(16),
//       flushbarPosition: FlushbarPosition.TOP,
//       icon: icon != null ? Icon(icon, color: Colors.white) : null,
//     ).show(context);
//   }

//   static void success(BuildContext context, String message) {
//     _show(
//       context,
//       message,
//       backgroundColor: Colors.green,
//       icon: Icons.check_circle,
//     );
//   }

//   static void error(BuildContext context, String message) {
//     _show(context, message, backgroundColor: Colors.red, icon: Icons.error);
//   }

//   static void info(BuildContext context, String message) {
//     _show(context, message, backgroundColor: Colors.blueGrey, icon: Icons.info);
//   }
// }

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
      builder: (dialogContext) => AlertDialog(
        // 👈 shu context muhim
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          isEdit ? LocaleKeys.edit_todo.tr() : LocaleKeys.add_todo.tr(),
          style: const TextStyle(fontFamily: FontFamily.comfortaa),
        ),
        content: TextField(
          controller: controller,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
          decoration: InputDecoration(
            hintText: LocaleKeys.enter_task.tr(),
            hintStyle: TextStyle(color: Theme.of(context).hintColor),
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white10
                : const Color(0xFFF2F5FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext), // ✅ to‘g‘ri context
            child: Text(LocaleKeys.cancel.tr()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: () {
              final title = controller.text.trim();
              if (title.isNotEmpty) {
                // ✅ Avval dialogni yopamiz
                Navigator.pop(dialogContext);

                if (isEdit) {
                  context.read<TodoBloc>().add(
                    UpdateTodoEvent(todo.copyWith(title: title)),
                  );
                  AppToast.success(
                    Navigator.of(context, rootNavigator: true).context,
                    LocaleKeys.todo_updated.tr(),
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
                  AppToast.success(
                    Navigator.of(context, rootNavigator: true).context,
                    LocaleKeys.todo_added.tr(),
                  );
                }
              } else {
                AppToast.error(context, LocaleKeys.enter_task.tr());
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

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          LocaleKeys.confirm_logout.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(LocaleKeys.logout_message.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(LocaleKeys.cancel.tr()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
              context.read<AuthBloc>().add(SignOutRequested());
              AppToast.error(context, LocaleKeys.logging_out.tr());
              await CacheHelper(
                await SharedPreferences.getInstance(),
              ).clearThemeMode();

              context.go('/sign-in');
            },
            child: Text(LocaleKeys.logout.tr()),
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
    String _selectedLang =
        context.savedLocale?.languageCode ??
        context.locale.languageCode ??
        "en";

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
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
          IconButton(
            onPressed: () => _confirmLogout(context),
            icon: const Icon(Icons.logout, color: Colors.redAccent),
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
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontSize: 16.sp,
                  ),
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
                    AppToast.error(context, LocaleKeys.todo_deleted.tr());
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
                          ? AppColors.primary.withOpacity(0.12)
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
                            AppToast.success(
                              Navigator.of(
                                context,
                                rootNavigator: true,
                              ).context,
                              todo.isDone
                                  ? LocaleKeys.todo_marked_pending.tr()
                                  : LocaleKeys.todo_marked_done.tr(),
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
                              color: todo.isDone
                                  ? AppColors.primary
                                  : Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.color,
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
            AppToast.error(context, state.message);
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
