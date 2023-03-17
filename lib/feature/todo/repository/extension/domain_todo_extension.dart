import 'package:dart3_sample/feature/local_data/todo_database.dart';
import 'package:dart3_sample/feature/todo/repository/extension/todo_status_extension.dart';
import 'package:dart3_sample/feature/todo/domain/value/todo.dart' as domain;
import 'package:drift/drift.dart';

extension DomainTodoExtension on domain.Todo {
  TodosCompanion toDTO() {
    return TodosCompanion(
      title: Value(title),
      content: Value(content),
      status: Value(progressStatus.toDatabaseObject()),
      updatedAt: Value(updatedAt),
    );
  }

  TodosCompanion toUniqueDTO() {
    return TodosCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      status: Value(progressStatus.toDatabaseObject()),
      updatedAt: Value(updatedAt),
    );
  }

  static domain.Todo fromDTO(Todo todo) {
    return domain.Todo(
      id: todo.id,
      title: todo.title,
      content: todo.content,
      progressStatus: TodoStatusExtension.fromDTO(todo.status),
      updatedAt: todo.updatedAt,
    );
  }
}
