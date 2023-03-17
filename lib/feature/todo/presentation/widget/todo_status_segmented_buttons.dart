import 'package:dart3_sample/feature/todo/domain/value/todo_status.dart';
import 'package:flutter/material.dart';

class TodoStatusSegmentedButtons extends StatelessWidget {
  const TodoStatusSegmentedButtons({
    super.key,
    required this.selectedStatus,
    required this.onSelectSelection,
  });

  final TodoStatus selectedStatus;
  final void Function(TodoStatus) onSelectSelection;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<String>(
      segments: [
        ButtonSegment(
          value: NotStarted().statusString,
          label: const Text('NotStarted'),
          icon: const Icon(Icons.radio_button_unchecked),
        ),
        ButtonSegment(
          value: InProgress().statusString,
          label: const Text('InProgress'),
          icon: const Icon(Icons.more_horiz),
        ),
        ButtonSegment(
          value: Finished().statusString,
          label: const Text('Finished'),
          icon: const Icon(Icons.radio_button_checked),
        ),
      ],
      selected: {selectedStatus.statusString},
      onSelectionChanged: (value) {
        onSelectSelection(TodoStatus.from(value.first));
      },
    );
  }
}
