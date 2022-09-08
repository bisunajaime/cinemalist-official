import 'package:tmdbflutter/models/generic_movies_model.dart';

class SearchHistoryModel extends SerializableClass {
  final String text;
  final DateTime dateSearched;

  SearchHistoryModel(this.text, this.dateSearched);

  @override
  Map<String, dynamic> toJson() => {
        'text': text,
        'date_searched': dateSearched.toIso8601String(),
      };

  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) {
    return SearchHistoryModel(
        json['text'], DateTime.parse(json['date_searched']));
  }
}
