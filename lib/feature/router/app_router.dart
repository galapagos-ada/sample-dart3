import 'package:dart3_sample/const/app_theme.dart';
import 'package:dart3_sample/feature/todo/presentation/todo_create/todo_create_screen.dart';
import 'package:dart3_sample/feature/todo/presentation/todo_edit/todo_edit_screen.dart';
import 'package:dart3_sample/feature/todo/presentation/todo_list/todo_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppRouter extends ConsumerWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      theme: ref.read(lightThemeProvider).theme,
      darkTheme: ref.read(darkThemeProvider).theme,
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const TodoListScreen(),
      routes: [
        GoRoute(
          path: 'create',
          builder: (context, state) => TodoCreateScreen(),
        ),
        GoRoute(
          path: 'edit/:todoId',
          builder: (context, state) => TodoEditScreen(
            todoId: int.parse(state.params['todoId']!),
          ),
        ),
      ],
    ),
  ],
);
