import 'package:dart3_sample/feature/todo/domain/usecase/update_todo_usecase.dart';
import 'package:dart3_sample/feature/todo/domain/value/todo.dart';
import 'package:dart3_sample/feature/todo/domain/value/todo_status.dart';
import 'package:dart3_sample/feature/todo/presentation/todo_edit/fetch_todo_notifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final editTodoNotifierProvider = AutoDisposeStateNotifierProviderFamily<
    EditTodoNotifier, AsyncValue<Todo>, int>((ref, id) {
  return EditTodoNotifier(
    ref.watch(fetchTodoNotifierProvider(id)),
    ref.watch(updateTodoUsecaseProvider),
  );
});

final class EditTodoNotifier extends StateNotifier<AsyncValue<Todo>> {
  EditTodoNotifier(
    AsyncValue<Todo> savedTodo,
    this._updateTodoUsecase,
  ) : super(savedTodo) {
    titleController.text = state.valueOrNull?.title ?? '';
    contentController.text = state.valueOrNull?.content ?? '';
  }

  final UpdateTodoUsecase _updateTodoUsecase;

  final titleController = TextEditingController(text: '');
  final contentController = TextEditingController(text: '');

  void updateTitle(String value) {
    if (!state.hasValue) return;

    state = AsyncData(state.requireValue.copyWith(title: value));
  }

  void updateContent(String value) {
    if (!state.hasValue) return;

    state = AsyncData(state.requireValue.copyWith(content: value));
  }

  void updateProgressStatus(TodoStatus value) {
    if (!state.hasValue) return;

    state = AsyncData(state.requireValue.copyWith(progressStatus: value));
  }

  void updateTodo() {
    if (!state.hasValue) return;

    _updateTodoUsecase.execute(state.requireValue);
  }
}
