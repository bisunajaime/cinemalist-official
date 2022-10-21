import 'package:cinemalist/bloc/saved/saved_category_cubit.dart';
import 'package:cinemalist/models/saved_category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<List<SavedCategoryModel>?> showSaveToCategoryDialog(
    BuildContext context) async {
  return await showModalBottomSheet(
    context: context,
    builder: (context) {
      return SaveToCategoryDialog();
    },
  );
}

class SaveToCategoryDialog extends StatefulWidget {
  const SaveToCategoryDialog({Key? key}) : super(key: key);

  @override
  State<SaveToCategoryDialog> createState() => _SaveToCategoryDialogState();
}

class _SaveToCategoryDialogState extends State<SaveToCategoryDialog> {
  final selectedCategories = <SavedCategoryModel>[];
  @override
  Widget build(BuildContext context) {
    final savedCategoriesCubit = context.watch<SavedCategoryCubit>();
    return Container(
      color: Color(0xff2E2C2C),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'Choose categories\nto save to',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Container(
            height: 100,
            width: double.infinity,
            child: ListView.builder(
              itemCount: savedCategoriesCubit.state.length + 1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index == 0) {
                  final model = SavedCategoryModel.defaultOption();
                  return Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: CategoryOption(
                      savedCategoryModel: model,
                      isSelected: selectedCategories.contains(model),
                      onTap: () {
                        if (selectedCategories.contains(model)) {
                          selectedCategories.remove(model);
                        } else {
                          selectedCategories.add(model);
                        }
                        setState(() {});
                      },
                    ),
                  );
                }
                final model = savedCategoriesCubit.state[index - 1];
                return CategoryOption(
                  savedCategoryModel: model,
                  isSelected: selectedCategories.contains(model),
                  onTap: () {
                    if (selectedCategories.contains(model)) {
                      selectedCategories.remove(model);
                    } else {
                      selectedCategories.add(model);
                    }
                    setState(() {});
                  },
                );
              },
            ),
          ),
          SizedBox(height: 18),
          Row(
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
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    padding: EdgeInsets.symmetric(
                      vertical: 18,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, selectedCategories);
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
          SizedBox(height: MediaQuery.of(context).padding.top),
        ],
      ),
    );
  }
}

class DefaultCategoryOption extends StatelessWidget {
  final SavedCategoryModel model;
  final VoidCallback onTap;
  const DefaultCategoryOption(
      {Key? key, required this.model, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          child: Container(
            width: 180,
            decoration: BoxDecoration(
              color: Color(0xff212121),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(
              right: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(),
                ),
                Text(
                  'Default',
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
      ),
    );
  }
}

class CategoryOption extends StatelessWidget {
  final SavedCategoryModel savedCategoryModel;
  final VoidCallback onTap;
  final bool isSelected;
  const CategoryOption({
    Key? key,
    required this.savedCategoryModel,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: savedCategoryModel.color,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(
                  color: Colors.white,
                  width: 4,
                )
              : Border.all(
                  color: Colors.transparent,
                  width: 4,
                ),
        ),
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(
          right: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
