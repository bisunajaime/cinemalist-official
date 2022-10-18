import 'package:cinemalist/bloc/saved/saved_category_cubit.dart';
import 'package:cinemalist/models/saved_category_model.dart';
import 'package:cinemalist/widgets/dialogs/create_saved_category_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavedCategoriesListWidget extends StatelessWidget {
  const SavedCategoriesListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final savedCategoryCubit = context.watch<SavedCategoryCubit>();
    // TODO:
    // if the size is 0, show a big add widget
    // "Tap here to create a category"
    if (savedCategoryCubit.state.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 16,
        ),
        child: CreateSavedCategoryWidget(),
      );
    }

    return Container(
      height: 100,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: savedCategoryCubit.state.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return CreateSavedCategoryWidget();
          }
          final category = savedCategoryCubit.state[index - 1];
          return SavedCategoryWidget(
            savedCategoryModel: category,
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
        final savedCategoryCubit = context.read<SavedCategoryCubit>();
        await savedCategoryCubit.saveCategory(savedCategoryModel);
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
      child: GestureDetector(
        onTap: () {
          // todo: navigate to saved screen
        },
        onDoubleTap: () async {
          final savedCategoryCubit = context.read<SavedCategoryCubit>();
          final delete =
              await savedCategoryCubit.removeCategory(savedCategoryModel);
        },
        onLongPress: () async {
          final model = await showSavedCategoryDialog(
            context,
            model: savedCategoryModel,
          );
          if (model == null) return;
          final savedCategoryCubit = context.read<SavedCategoryCubit>();
          await savedCategoryCubit.saveCategory(model);
        },
        child: Container(
          width: 180,
          decoration: BoxDecoration(
            color: savedCategoryModel.color,
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
      ),
    );
  }
}
