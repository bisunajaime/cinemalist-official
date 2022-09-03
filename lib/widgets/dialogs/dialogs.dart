import 'package:flutter/material.dart';

class ShowRemoveConfirmationDialog extends StatelessWidget {
  final String type;
  final Function(bool confirm) onActionTap;
  const ShowRemoveConfirmationDialog(
      {Key? key, required this.type, required this.onActionTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Remove confirmation'),
      content: Text(
          'Are you sure you want to remove $type from your saved records?'),
      actions: [
        TextButton(
          onPressed: () => onActionTap(false),
          child: Text('No'),
        ),
        TextButton(
          onPressed: () => onActionTap(true),
          child: Text('Yes'),
        ),
      ],
    );
  }
}
