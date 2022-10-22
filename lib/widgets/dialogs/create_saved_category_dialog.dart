import 'package:cinemalist/models/saved_category_model.dart';
import 'package:equatable/equatable.dart';
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
  CategoryEmojiOption? selectedEmoji;
  final colorList = [
    Color(0xffFF3F61),
    Color(0xff3B37FF),
    Color(0xff05E100),
    Color(0xffFF3838),
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
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        color: Color(0xff2E2C2C),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              SampleCategoryCard(
                categoryEmojiOption: selectedEmoji,
                label: labelController.text,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
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
                height: 80,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: categoryEmojiMap.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final key = categoryEmojiMap.keys.toList()[index];
                    final categoryEmoji = categoryEmojiMap[key];
                    final isSelected = categoryEmoji == selectedEmoji;
                    return IntrinsicHeight(
                      child: GestureDetector(
                        onTap: () {
                          selectedEmoji = categoryEmoji;
                          savedCategoryModel = savedCategoryModel.copyWith(
                            emojiOption: categoryEmoji,
                          );
                          setState(() {});
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            right: 8,
                            left: index == 0 ? 18 : 0,
                          ),
                          padding: EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: categoryEmoji!.primaryColor,
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  )
                                : Border.all(
                                    width: 3,
                                    color: Colors.transparent,
                                  ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            categoryEmoji.emoji,
                            style: TextStyle(
                              fontSize: 30,
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
                    savedCategoryModel =
                        savedCategoryModel.copyWith(label: value);
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
            ],
          ),
        ),
      ),
    );
  }
}

class SampleCategoryCard extends StatelessWidget {
  final CategoryEmojiOption? categoryEmojiOption;
  final String label;
  const SampleCategoryCard({
    Key? key,
    this.categoryEmojiOption,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (categoryEmojiOption == null) return Container();
    return Container(
      height: 140,
      child: ListView.builder(
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Container(
          margin: EdgeInsets.only(
            right: 12,
            left: index == 0 ? 12 : 0,
            top: 12,
          ),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: categoryEmojiOption!.secondaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          height: 120,
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: categoryEmojiOption!.primaryColor,
                ),
                padding: EdgeInsets.all(10),
                child: Text(
                  categoryEmojiOption!.emoji,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(child: SizedBox()),
              Text(
                label.isEmpty ? 'Label will appear here' : label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontStyle:
                      label.isEmpty ? FontStyle.italic : FontStyle.normal,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryEmojiOption extends Equatable {
  final String emoji, label;
  final int primaryColorValue, secondaryColorValue;

  CategoryEmojiOption({
    required this.emoji,
    required this.label,
    required this.primaryColorValue,
    required this.secondaryColorValue,
  });

  Color get primaryColor => Color(primaryColorValue);
  Color get secondaryColor => Color(secondaryColorValue);

  factory CategoryEmojiOption.fromJson(Map<String, dynamic> json) {
    return CategoryEmojiOption(
      emoji: json['emoji'],
      label: json['label'],
      primaryColorValue: json['primaryColorValue'],
      secondaryColorValue: json['secondaryColorValue'],
    );
  }

  Map<String, dynamic> toJson() => {
        'emoji': emoji,
        'label': label,
        'primaryColorValue': primaryColorValue,
        'secondaryColorValue': secondaryColorValue,
      };

  @override
  List<Object?> get props => [emoji];
}

enum EmojiOption {
  action,
  romance,
  comedy,
  adventure,
  crime,
  animation,
  documentary,
  family,
  drama,
  horror,
  music,
  mystery,
  sciFi,
  tvMovie,
  thriller,
  war,
  western,
}

final categoryEmojiMap = <EmojiOption, CategoryEmojiOption>{
  EmojiOption.action: CategoryEmojiOption(
    label: 'Action',
    emoji: '💣',
    primaryColorValue: 0xff888D8F,
    secondaryColorValue: 0xff6A7072,
  ),
  EmojiOption.animation: CategoryEmojiOption(
    label: 'Animation',
    emoji: '🎨',
    primaryColorValue: 0xffE1AD55,
    secondaryColorValue: 0xffB98E45,
  ),
  EmojiOption.comedy: CategoryEmojiOption(
    label: 'Comedy',
    emoji: '🤡',
    primaryColorValue: 0xffFCE8C0,
    secondaryColorValue: 0xffD3BF95,
  ),
  EmojiOption.adventure: CategoryEmojiOption(
    label: 'Adventure',
    emoji: '⛰️',
    primaryColorValue: 0xffC4C9CC,
    secondaryColorValue: 0xff999EA1,
  ),
  EmojiOption.crime: CategoryEmojiOption(
    label: 'Crime',
    emoji: '💸',
    primaryColorValue: 0xffE2E0CF,
    secondaryColorValue: 0xffACA992,
  ),
  EmojiOption.documentary: CategoryEmojiOption(
    label: 'Documentary',
    emoji: '🎥',
    primaryColorValue: 0xff707E85,
    secondaryColorValue: 0xff546066,
  ),
  EmojiOption.family: CategoryEmojiOption(
    label: 'Family',
    emoji: '👨‍👨‍👧',
    primaryColorValue: 0xffFDE095,
    secondaryColorValue: 0xffC6AB65,
  ),
  EmojiOption.drama: CategoryEmojiOption(
    label: 'Drama',
    emoji: '🎭',
    primaryColorValue: 0xff6D0017,
    secondaryColorValue: 0xff540D1C,
  ),
  EmojiOption.horror: CategoryEmojiOption(
    label: 'Horror',
    emoji: '👻',
    primaryColorValue: 0xffB1B0B2,
    secondaryColorValue: 0xff7E7785,
  ),
  EmojiOption.thriller: CategoryEmojiOption(
    label: 'Thriller',
    emoji: '😱',
    primaryColorValue: 0xff8EADED,
    secondaryColorValue: 0xff647DAF,
  ),
  EmojiOption.mystery: CategoryEmojiOption(
    label: 'Mystery',
    emoji: '❔',
    primaryColorValue: 0xffC8C8C8,
    secondaryColorValue: 0xff8E8A8A,
  ),
  EmojiOption.war: CategoryEmojiOption(
    label: 'War',
    emoji: '🪖',
    primaryColorValue: 0xff5D7851,
    secondaryColorValue: 0xff3F5336,
  ),
  EmojiOption.sciFi: CategoryEmojiOption(
    label: 'Sci-Fi',
    emoji: '🌍',
    primaryColorValue: 0xffC5D764,
    secondaryColorValue: 0xff97A649,
  ),
  EmojiOption.music: CategoryEmojiOption(
    label: 'Music',
    emoji: '🎶',
    primaryColorValue: 0xffC4C9CC,
    secondaryColorValue: 0xff999EA1,
  ),
  EmojiOption.tvMovie: CategoryEmojiOption(
    label: 'TV Movie',
    emoji: '📺',
    primaryColorValue: 0xffBEB6A2,
    secondaryColorValue: 0xff8E8469,
  ),
  EmojiOption.romance: CategoryEmojiOption(
    label: 'Romance',
    emoji: '🌹',
    primaryColorValue: 0xffB5195A,
    secondaryColorValue: 0xff8A1647,
  ),
  EmojiOption.western: CategoryEmojiOption(
    label: 'Western',
    emoji: '🤠',
    primaryColorValue: 0xffBEA48C,
    secondaryColorValue: 0xff927963,
  ),
};
