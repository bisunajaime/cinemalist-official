import 'package:cinemalist/bloc/saved/saved_category_cubit.dart';
import 'package:cinemalist/models/saved_category_model.dart';
import 'package:cinemalist/widgets/dialogs/create_saved_category_dialog.dart';
import 'package:cinemalist/widgets/saved/category/saved_categories_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<SavedCategoryModel?> showSelectCategoryDialog(
    BuildContext context) async {
  return await showModalBottomSheet(
    context: context,
    builder: (context) => ShowSelectCategoryDialog(),
  );
}

class ShowSelectCategoryDialog extends StatelessWidget {
  const ShowSelectCategoryDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 18),
          Text(
            'Select a Category',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 18),
          SelectCategoryListWidget(),
          SizedBox(height: 18),
        ],
      ),
    );
  }
}

class SelectCategoryListWidget extends StatefulWidget {
  const SelectCategoryListWidget({Key? key}) : super(key: key);

  @override
  State<SelectCategoryListWidget> createState() =>
      _SelectCategoryListWidgetState();
}

class _SelectCategoryListWidgetState extends State<SelectCategoryListWidget> {
  SavedCategoryModel? selectedCategory;
  @override
  Widget build(BuildContext context) {
    final savedCategoriesCubit = context.watch<SavedCategoryCubit>();
    return Column(
      children: [
        Container(
          height: 140,
          child: ListView.builder(
            itemCount: savedCategoriesCubit.state.length + 1,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              if (index == 0) {
                return CreateSavedCategoryWidget();
              }
              final category = savedCategoriesCubit.state[index - 1];
              return GestureDetector(
                  onTap: () {
                    selectedCategory = category;
                    setState(() {});
                  },
                  child: SavedCategoryCard(category,
                      isSelected: selectedCategory == category));
            },
          ),
        ),
        SizedBox(height: 18),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: 18,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Dismiss',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    padding: EdgeInsets.symmetric(
                      vertical: 18,
                    ),
                  ),
                  onPressed: () {
                    if (selectedCategory == null) return;
                    Navigator.pop(context, selectedCategory);
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
