import 'package:dart3_sample/feature/todo/repository/todo_repository.dart';
import 'package:riverpod/riverpod.dart';

final deleteTodoUsecaseProvider = Provider<DeleteTodoUsecase>((ref) {
  return DeleteTodoUsecase(ref.watch(todoRepositoryProvider));
});

final class DeleteTodoUsecase {
  DeleteTodoUsecase(
    this._todoRepository,
  );
  final TodoRepository _todoRepository;

  Future<void> execute(int id) => _todoRepository.delete(id);
}