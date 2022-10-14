import 'package:flutter/material.dart';
import 'package:cinemalist/library/cubit.dart';
import 'package:cinemalist/models/ranking_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/widgets/dialogs/dialogs.dart';

enum SavedRecordType {
  movie,
  actor,
  tvShow,
}

class SavedRecordsTitle extends StatelessWidget {
  final String title;
  final LocalStorageCubit localCubit;
  final SavedRecordType type;
  const SavedRecordsTitle({
    Key? key,
    required this.title,
    required this.localCubit,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (localCubit.state.length == 0) return Container();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title (${localCubit.state.length})',
            style: Styles.mBold.copyWith(
              fontSize: 18,
            ),
          ),
          GestureDetector(
            onTap: () async {
              final result = await showDialog(
                context: context,
                builder: (context) => ShowRemoveConfirmationDialog(
                  type: 'all $title',
                ),
              );
              if (result != true) return;
              await RankingHelper.removeRankingWithType(context, type);
              localCubit.remove();
            },
            child: Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.pinkAccent,
              ),
              child: Icon(
                Icons.delete_forever,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
