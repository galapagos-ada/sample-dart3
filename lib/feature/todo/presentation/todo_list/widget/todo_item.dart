import 'package:dart3_sample/feature/todo/domain/value/todo_status.dart';
import 'package:flutter/material.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({
    super.key,
    required this.id,
    required this.title,
    required this.content,
    required this.status,
    required this.updatedAt,
    required this.onClickEdit,
    required this.onClickDelete,
  });

  final int id;
  final String title;
  final String content;
  final TodoStatus status;
  final DateTime updatedAt;
  final void Function(int) onClickEdit;
  final void Function(int) onClickDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        switch(status) {
          NotStarted() => Icons.radio_button_unchecked,
          InProgress() => Icons.more_horiz,
          Finished() => Icons.radio_button_checked,
        }, 
        color: Colors.grey,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        content,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => onClickEdit(id),
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () => onClickDelete(id),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      isThreeLine: true,
      dense: true,
      tileColor: switch(status) {
        NotStarted() => Colors.transparent,
        InProgress() => const Color.fromARGB(255, 207, 253, 209),
        Finished() => const Color.fromARGB(255, 207, 207, 207),
      },
    );
  }
}
