import 'package:dart3_sample/feature/local_data/todo_database.dart';
import 'package:dart3_sample/feature/todo/domain/value/todo.dart' as domain;
import 'package:dart3_sample/feature/todo/repository/extension/domain_todo_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  return TodoRepositoryImpl(ref.watch(todosDatabaseProvider));
});

interface class TodoRepository {
  Future<int> add(domain.Todo todo) => throw UnimplementedError();
  Future<int> update(domain.Todo todo) => throw UnimplementedError();
  Future<void> delete(int id) => throw UnimplementedError();
  Stream<List<domain.Todo>> watchAll() => throw UnimplementedError();
  Future<domain.Todo> fetch(int id) => throw UnimplementedError();
}

final class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl(this._database);

  final TodosDatabase _database;

  @override
  Future<int> add(domain.Todo todo) => _database.upsert(todo.toDTO());

  @override
  Future<int> update(domain.Todo todo) => _database.upsert(todo.toUniqueDTO());

  @override
  Future<void> delete(int id) => _database.deleteSingle(id);

  @override
  Stream<List<domain.Todo>> watchAll() => _database.watchAll()
    .map((event) => event.map((e) => DomainTodoExtension.fromDTO(e)).toList());

  @override
  Future<domain.Todo> fetch(int id) async => DomainTodoExtension.fromDTO(await _database.fetchSingle(id));
}
