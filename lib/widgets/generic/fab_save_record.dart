import 'package:flutter/material.dart';

class FABSaveRecord<T> extends StatelessWidget {
  final T record;
  final String tag;
  final Function(T) onTap;
  final bool isSaved;
  const FABSaveRecord({
    required this.tag,
    required this.isSaved,
    required this.record,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: 'Save movie',
      elevation: 0,
      heroTag: tag,
      onPressed: () async {
        await onTap(record);
      },
      backgroundColor: Colors.red,
      child: Icon(
        isSaved ? Icons.bookmark : Icons.bookmark_add_outlined,
        color: Colors.white,
      ),
    );
  }
}
