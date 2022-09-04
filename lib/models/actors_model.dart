import 'package:tmdbflutter/models/generic_movies_model.dart';

class ActorsModel extends SerializableClass {
  final int? id;
  final double? popularity;
  final String? department, profilePath, name;

  ActorsModel(
      {this.id, this.popularity, this.department, this.profilePath, this.name});

  factory ActorsModel.fromJson(Map<String, dynamic> json) {
    return ActorsModel(
      id: json['id'],
      popularity: json['popularity'],
      department: json['department'],
      profilePath: json['profile_path'],
      name: json['name'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'popularity': popularity,
        'department': department,
        'profile_path': profilePath,
        'name': name,
      };
}
