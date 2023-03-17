import 'package:dart3_sample/feature/todo/domain/value/todo.dart';
import 'package:dart3_sample/feature/todo/repository/todo_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateTodoUsecaseProvider = Provider<UpdateTodoUsecase>((ref) {
  return UpdateTodoUsecase(ref.watch(todoRepositoryProvider));
});

final class UpdateTodoUsecase {
  UpdateTodoUsecase(
    this._todoRepository,
  );
  final TodoRepository _todoRepository;

  Future<void> execute(Todo todo) => _todoRepository.update(todo);
}
