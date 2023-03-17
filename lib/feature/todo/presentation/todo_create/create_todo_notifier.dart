import 'package:dart3_sample/feature/todo/domain/usecase/add_todo_usecase.dart';
import 'package:dart3_sample/feature/todo/domain/value/todo.dart';
import 'package:dart3_sample/feature/todo/domain/value/todo_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createTodoNotifierProvider = AutoDisposeStateNotifierProvider<CreateTodoNotifier, Todo>((ref) {
  return CreateTodoNotifier(
    ref.watch(addTodoUsecaseProvider),
  );
});

final class CreateTodoNotifier extends StateNotifier<Todo> {
  CreateTodoNotifier(
    this._addTodoUsecase,
  ): super(
    Todo(
    id: -1, // 登録時に再度割り当てるため、この値は使用しない
    title: '', 
    content: '', 
    progressStatus: NotStarted(), 
    updatedAt: DateTime.now(),
    )
    );

  final AddTodoUsecase _addTodoUsecase;

  final titleController = TextEditingController(text: '');
  final contentController = TextEditingController(text: '');

  void updateTitle(String value) {
    state = state.copyWith(title: value);
  }

  void updateContent(String value) {
    state = state.copyWith(content: value);
  }

  void updateProgressStatus(TodoStatus value) {
    state = state.copyWith(progressStatus: value);
  }

  void addTodo() {
    _addTodoUsecase.execute(state);
  }
}
