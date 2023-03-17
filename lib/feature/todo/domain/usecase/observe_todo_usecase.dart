import 'package:dart3_sample/feature/todo/domain/value/todo.dart';
import 'package:dart3_sample/feature/todo/repository/todo_repository.dart';
import 'package:riverpod/riverpod.dart';

final observeTodoUsecaseProvider = StreamProvider<List<Todo>>((ref) async* {
  final observeTodoUseCase = ObserveTodoUsecase(ref.watch(todoRepositoryProvider));
  await for (final todos in observeTodoUseCase.execute()) {
    yield todos;
  }
});

final class ObserveTodoUsecase {
  ObserveTodoUsecase(
    this._todoRepository,
  );

  final TodoRepository _todoRepository;

  Stream<List<Todo>> execute() {
    return _todoRepository.watchAll();
  }
}
