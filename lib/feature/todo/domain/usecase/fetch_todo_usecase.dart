import 'package:dart3_sample/feature/todo/domain/value/todo.dart';
import 'package:dart3_sample/feature/todo/repository/todo_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fetchTodoUsecaseProvider = Provider<FetchTodoUsecase>((ref) {
  return FetchTodoUsecase(ref.watch(todoRepositoryProvider));
});

class FetchTodoUsecase {
  FetchTodoUsecase(
    this._todoRepository,
  );
  final TodoRepository _todoRepository;

  Future<Todo> execute(int id) => _todoRepository.fetch(id);
}
