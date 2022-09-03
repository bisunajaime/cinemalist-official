import 'package:flutter/material.dart';

class ShowRemoveConfirmationDialog extends StatelessWidget {
  final String type;
  const ShowRemoveConfirmationDialog({Key? key, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Remove confirmation'),
      content: Text(
          'Are you sure you want to remove $type from your saved records?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('Yes'),
        ),
      ],
    );
  }
}
