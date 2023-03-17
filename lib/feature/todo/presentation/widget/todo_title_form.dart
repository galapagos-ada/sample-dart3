import 'package:dart3_sample/feature/todo/domain/value/todo.dart';
import 'package:flutter/material.dart';

final class TodoTitleForm extends StatelessWidget {
  const TodoTitleForm({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'タイトル',
      ),
      maxLength: 50,
      onChanged: onChanged,
      validator: Todo.validateTitle,
    );
  }
}
