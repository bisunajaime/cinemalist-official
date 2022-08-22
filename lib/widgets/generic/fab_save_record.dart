import 'package:flutter/material.dart';

enum RecordType {
  movie,
  tv,
  actor,
}

final _typeToString = <RecordType, String>{
  RecordType.movie: 'movie',
  RecordType.tv: 'tv',
  RecordType.actor: 'actor',
};

class FABSaveRecord<T> extends StatelessWidget {
  final RecordType type;
  final T record;
  final Function(T) onTap;
  const FABSaveRecord({
    required this.type,
    required this.record,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: 'Save movie',
      elevation: 0,
      onPressed: () async {
        await onTap(record);
      },
      backgroundColor: Colors.red,
      child: Icon(
        Icons.bookmark_add_outlined,
        color: Colors.white,
      ),
    );
  }
}
