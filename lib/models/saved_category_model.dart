import 'package:cinemalist/widgets/dialogs/create_saved_category_dialog.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SavedCategoryModel extends Equatable {
  final String? id, label;
  final CategoryEmojiOption? emojiOption;

  SavedCategoryModel({
    this.id,
    this.label,
    this.emojiOption,
  });

  bool get isValid =>
      label != null && label?.isNotEmpty == true && emojiOption != null;

  SavedCategoryModel copyWith({
    String? id,
    String? label,
    String? colorHex,
    CategoryEmojiOption? emojiOption,
  }) {
    return SavedCategoryModel(
      id: id ?? this.id,
      label: label ?? this.label,
      emojiOption: emojiOption ?? this.emojiOption,
    );
  }

  factory SavedCategoryModel.fromJson(Map<String, dynamic> json) {
    return SavedCategoryModel(
      id: json['id'],
      label: json['label'],
      emojiOption: CategoryEmojiOption.fromJson(json['emojiOption']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'emojiOption': emojiOption?.toJson(),
      };

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return 'ID: $id | label: $label';
  }

  factory SavedCategoryModel.initial() {
    return SavedCategoryModel(id: Uuid().v4());
  }
}
