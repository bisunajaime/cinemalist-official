import 'package:flutter/material.dart';
import 'package:tmdbflutter/library/cubit.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/widgets/dialogs/dialogs.dart';

class SavedRecordsTitle extends StatelessWidget {
  final String title;
  final LocalStorageCubit localCubit;
  const SavedRecordsTitle({
    Key? key,
    required this.title,
    required this.localCubit,
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
