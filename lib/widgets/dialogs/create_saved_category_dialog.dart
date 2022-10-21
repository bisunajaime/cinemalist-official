import 'package:cinemalist/models/saved_category_model.dart';
import 'package:flutter/material.dart';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

Future<SavedCategoryModel?> showSavedCategoryDialog(BuildContext context,
    {SavedCategoryModel? model}) async {
  return await showModalBottomSheet<SavedCategoryModel?>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return CreateSavedCategoryDialog(
        model: model,
      );
    },
  );
}

class CreateSavedCategoryDialog extends StatefulWidget {
  final SavedCategoryModel? model;
  const CreateSavedCategoryDialog({Key? key, this.model}) : super(key: key);

  @override
  State<CreateSavedCategoryDialog> createState() =>
      _CreateSavedCategoryDialogState();
}

class _CreateSavedCategoryDialogState extends State<CreateSavedCategoryDialog> {
  late SavedCategoryModel savedCategoryModel;
  late TextEditingController labelController;
  final colorList = [
    Color(0xffFF3F61),
    Color(0xff3B37FF),
    Color(0xff05E100),
    Color(0xffFF8E3D),
  ];
  Color? selectedColor;

  @override
  void initState() {
    super.initState();
    savedCategoryModel = widget.model ?? SavedCategoryModel.initial();
    labelController = TextEditingController(text: widget.model?.label ?? '');
    selectedColor = widget.model?.colorHex != null
        ? HexColor.fromHex(widget.model!.colorHex!)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff2E2C2C),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'Create a category',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Container(
            height: 30,
            width: double.infinity,
            child: ListView.builder(
              itemCount: colorList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final color = colorList[index];
                return GestureDetector(
                  onTap: () {
                    selectedColor = color;
                    savedCategoryModel =
                        savedCategoryModel.copyWith(colorHex: color.toHex());
                    setState(() {});
                  },
                  child: IntrinsicHeight(
                    child: Container(
                      width: 60,
                      margin: EdgeInsets.only(
                        right: 8,
                        left: index == 0 ? 18 : 0,
                      ),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: savedCategoryModel.colorHex != null &&
                                  HexColor.fromHex(
                                          savedCategoryModel.colorHex!) ==
                                      selectedColor
                              ? Colors.white
                              : Colors.transparent,
                          width: selectedColor == color ? 4 : 0,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: TextField(
              autofocus: true,
              controller: labelController,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              onChanged: (value) {
                savedCategoryModel = savedCategoryModel.copyWith(label: value);
                setState(() {});
              },
              cursorColor: Colors.white,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xff484848),
                contentPadding: EdgeInsets.all(18),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 18,
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
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      padding: EdgeInsets.symmetric(
                        vertical: 18,
                      ),
                    ),
                    onPressed: () {
                      if (!savedCategoryModel.isValid) return;
                      Navigator.pop(context, savedCategoryModel);
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
          SizedBox(height: 16),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
