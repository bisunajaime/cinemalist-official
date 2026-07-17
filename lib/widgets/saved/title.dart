import 'package:flutter/material.dart';
import 'package:cinemalist/library/cubit.dart';
import 'package:cinemalist/models/ranking_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/widgets/dialogs/dialogs.dart';

enum SavedRecordType {
  movie,
  actor,
  tvShow,
}

class SavedRecordsTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final LocalStorageCubit localCubit;
  final SavedRecordType type;

  const SavedRecordsTitle({
    super.key,
    required this.title,
    required this.localCubit,
    required this.type,
    this.icon = Icons.movie_rounded,
  });

  @override
  Widget build(BuildContext context) {
    if (localCubit.state.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryLight),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: Styles.heading.copyWith(fontSize: 20),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${localCubit.state.length}',
              style: Styles.mBold.copyWith(fontSize: 12, color: AppColors.primaryLight),
            ),
          ),
          const Spacer(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () async {
                final result = await showDialog(
                  context: context,
                  builder: (_) => ShowRemoveConfirmationDialog(type: 'all $title'),
                );
                if (result != true) return;
                await RankingHelper.removeRankingWithType(context, type);
                localCubit.remove();
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.error.withValues(alpha: 0.1),
                ),
                child: Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
