import 'package:flutter/material.dart';

final class MessageAlertDialog extends StatelessWidget {
  const MessageAlertDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onCancel,
    required this.onApprove,
  });

  final String title;
  final String message;
  final void Function() onCancel;
  final void Function() onApprove;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: onApprove,
          child: const Text('OK'),
        ),
      ],
    );
  }
}
