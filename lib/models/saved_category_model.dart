import 'package:cinemalist/widgets/dialogs/create_saved_category_dialog.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SavedCategoryModel extends Equatable {
  final String? id, label, colorHex;

  SavedCategoryModel({
    this.id,
    this.label,
    this.colorHex,
  });

  Color get color => HexColor.fromHex(colorHex!); // use colorHex

  bool get isValid =>
      label != null && label?.isNotEmpty == true && colorHex != null;

  SavedCategoryModel copyWith({
    String? id,
    String? label,
    String? colorHex,
  }) {
    return SavedCategoryModel(
      id: id ?? this.id,
      label: label ?? this.label,
      colorHex: colorHex ?? this.colorHex,
    );
  }

  factory SavedCategoryModel.fromJson(Map<String, dynamic> json) {
    return SavedCategoryModel(
      id: json['id'],
      label: json['label'],
      colorHex: json['colorHex'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'colorHex': colorHex,
      };

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return 'ID: $id | label: $label | colorHex: $colorHex';
  }

  factory SavedCategoryModel.initial() {
    return SavedCategoryModel(id: Uuid().v4());
  }
}
