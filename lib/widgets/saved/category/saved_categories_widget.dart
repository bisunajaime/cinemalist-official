import 'package:cinemalist/models/saved_category_model.dart';
import 'package:cinemalist/widgets/dialogs/create_saved_category_dialog.dart';
import 'package:flutter/material.dart';

class SavedCategoriesListWidget extends StatelessWidget {
  const SavedCategoriesListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO:
    // if the size is 0, show a big add widget
    // "Tap here to create a category"

    return Container(
      height: 100,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          if (index == 0) {
            return CreateSavedCategoryWidget();
          }
          // final category = category[index - 1]
          return SavedCategoryWidget(
            savedCategoryModel: SavedCategoryModel(
              id: 'uuid',
              label: '👻 Do not watch these again',
              colorHex: 'somecolorHex',
            ),
          );
        },
      ),
    );
  }
}

class CreateSavedCategoryWidget extends StatelessWidget {
  const CreateSavedCategoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // show dialog
        final savedCategoryModel = await showSavedCategoryDialog(context);
        if (savedCategoryModel == null) return;
        print(savedCategoryModel);
      },
      child: Container(
        height: 100,
        width: 100,
        margin: EdgeInsets.only(
          right: 8,
        ),
        decoration: BoxDecoration(
          color: Color(0xff343434),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.add_circle_outline_rounded,
          color: Colors.pinkAccent,
          size: 30,
        ),
      ),
    );
  }
}

class SavedCategoryWidget extends StatelessWidget {
  final SavedCategoryModel savedCategoryModel;
  const SavedCategoryWidget({Key? key, required this.savedCategoryModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(
          right: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '4 results',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: SizedBox(),
            ),
            Text(
              savedCategoryModel.label ?? 'No Label',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
