import 'package:equatable/equatable.dart';

class ActorsModel extends Equatable {
  final double popularity;
  final String department, profilePath, name;

  ActorsModel({this.popularity, this.department, this.profilePath, this.name});

  factory ActorsModel.fromJson(Map<String, dynamic> json) {
    return ActorsModel(
      popularity: json['popularity'],
      department: json['department'],
      profilePath: json['profile_path'],
      name: json['name'],
    );
  }

  @override
  List<Object> get props => [
        popularity,
        department,
        profilePath,
        name,
      ];
}
