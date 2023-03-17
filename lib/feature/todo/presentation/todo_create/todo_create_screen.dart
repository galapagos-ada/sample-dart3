import 'package:dart3_sample/feature/router/route_path.dart';
import 'package:dart3_sample/feature/todo/presentation/todo_create/create_todo_notifier.dart';
import 'package:dart3_sample/feature/todo/presentation/widget/todo_content_form.dart';
import 'package:dart3_sample/feature/todo/presentation/widget/todo_status_segmented_buttons.dart';
import 'package:dart3_sample/feature/todo/presentation/widget/todo_title_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TodoCreateScreen extends ConsumerWidget {
  TodoCreateScreen({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TodoCreate'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TodoTitleForm(
                    controller: _todoNotifire(ref).titleController,
                    onChanged: _todoNotifire(ref).updateTitle,
                  ),
                  _spacer(),
                  TodoContentForm(
                    controller: _todoNotifire(ref).contentController,
                    onChanged: _todoNotifire(ref).updateContent,
                  ),
                  _spacer(),
                  TodoStatusSegmentedButtons(
                    selectedStatus:
                        ref.watch(createTodoNotifierProvider).progressStatus,
                    onSelectSelection: _todoNotifire(ref).updateProgressStatus,
                  ),
                  _spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => context.go(RouteTodoList().path),
                        child: const Text('cancel'),
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          if (!formKey.currentState!.validate()) return;

                          _todoNotifire(ref).addTodo();
                          context.go(RouteTodoList().path);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Create'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _spacer() => const SizedBox(height: 16);

  CreateTodoNotifier _todoNotifire(WidgetRef ref) =>
      ref.watch(createTodoNotifierProvider.notifier);
}
