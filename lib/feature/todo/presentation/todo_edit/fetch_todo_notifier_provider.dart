import 'package:dart3_sample/feature/todo/domain/usecase/fetch_todo_usecase.dart';
import 'package:dart3_sample/feature/todo/domain/value/todo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fetchTodoNotifierProvider = AutoDisposeFutureProviderFamily<Todo, int>((ref, id) async {
  return ref.read(fetchTodoUsecaseProvider).execute(id);
});
