import 'package:dart3_sample/feature/router/route_path.dart';
import 'package:dart3_sample/feature/todo/presentation/todo_edit/edit_todo_notifier.dart';
import 'package:dart3_sample/feature/todo/presentation/widget/todo_content_form.dart';
import 'package:dart3_sample/feature/todo/presentation/widget/todo_status_segmented_buttons.dart';
import 'package:dart3_sample/feature/todo/presentation/widget/todo_title_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TodoEditScreen extends ConsumerWidget {
  TodoEditScreen({
    super.key,
    required this.todoId,
  });

  final int todoId;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TodoEdit'),
        ),
        body: ref.watch(editTodoNotifierProvider(todoId)).when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => const Center(
                child: Text("ERROR!"),
              ),
              data: (data) => SingleChildScrollView(
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
                          controller: _todoNotifier(ref).titleController,
                          onChanged: _todoNotifier(ref).updateTitle,
                        ),
                        _spacer(),
                        TodoContentForm(
                          controller: _todoNotifier(ref).contentController,
                          onChanged: _todoNotifier(ref).updateContent,
                        ),
                        _spacer(),
                        TodoStatusSegmentedButtons(
                          selectedStatus: data.progressStatus,
                          onSelectSelection: ref
                              .read(editTodoNotifierProvider(todoId).notifier)
                              .updateProgressStatus,
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

                                _todoNotifier(ref).updateTodo();
                                context.go(RouteTodoList().path);
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text('Edit'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      ),
    );
  }

  Widget _spacer() => const SizedBox(height: 16);

  EditTodoNotifier _todoNotifier(WidgetRef ref) =>
      ref.watch(editTodoNotifierProvider(todoId).notifier);
}
