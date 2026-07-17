import 'package:flutter/material.dart';
import 'package:cinemalist/styles/theme.dart';

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
      tooltip: isSaved ? 'Remove from saved' : 'Save',
      elevation: 4,
      heroTag: tag,
      onPressed: () async => await onTap(record),
      backgroundColor: isSaved ? AppColors.primary : AppColors.card,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Icon(
          isSaved ? Icons.bookmark_rounded : Icons.bookmark_add_outlined,
          key: ValueKey(isSaved),
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
