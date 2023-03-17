import 'package:dart3_sample/feature/todo/domain/value/todo.dart';
import 'package:flutter/material.dart';

final class TodoContentForm extends StatelessWidget {
  const TodoContentForm({
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
      maxLines: 5,
      decoration: const InputDecoration(
        labelText: '内容',
      ),
      maxLength: 500,
      onChanged: onChanged,
      validator: Todo.validateContent,
    );
  }
}
