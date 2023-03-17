import 'package:dart3_sample/feature/common_widget/message_alert_dialog.dart';
import 'package:dart3_sample/feature/router/route_path.dart';
import 'package:dart3_sample/feature/todo/domain/usecase/delete_todo_usecase.dart';
import 'package:dart3_sample/feature/todo/domain/usecase/observe_todo_usecase.dart';
import 'package:dart3_sample/feature/todo/presentation/todo_list/widget/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TodoList'),
      ),
      body: Center(
        child: ref.watch(observeTodoUsecaseProvider).when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Center(child: Text('ERROR!')),
            data: (todos) {
              if (todos.isEmpty) {
                return const Center(child: Text('TODO is Empty'));
              }

              return ListView.separated(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 8,
                  top: 4,
                  bottom: 80,
                ),
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return TodoItem(
                    id: todo.id,
                    title: todo.title,
                    content: todo.content,
                    status: todo.progressStatus,
                    updatedAt: todo.updatedAt,
                    onClickEdit: (id) {
                      context.push(RouteTodoEdit(id: id).path);
                    },
                    onClickDelete: (id) {
                      showDialog(
                        context: context,
                        builder: (_) => MessageAlertDialog(
                          title: 'Todoを削除',
                          message: '${todo.title} を削除してもよろしいですか？',
                          onCancel: () => Navigator.of(context).pop(),
                          onApprove: () {
                            ref.read(deleteTodoUsecaseProvider).execute(id);
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  );
                },
                separatorBuilder: (_, __) => const Divider(),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(RouteTodoCreate().path),
        child: const Icon(Icons.add),
      ),
    );
  }
}
