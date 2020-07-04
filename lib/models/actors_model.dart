import 'package:equatable/equatable.dart';

class ActorsModel extends Equatable {
  final int id;
  final double popularity;
  final String department, profilePath, name;

  ActorsModel(
      {this.id, this.popularity, this.department, this.profilePath, this.name});

  factory ActorsModel.fromJson(Map<String, dynamic> json) {
    return ActorsModel(
      id: json['id'],
      popularity: json['popularity'],
      department: json['department'],
      profilePath: json['profile_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['profile_path']}'
          : 'https://via.placeholder.com/400',
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
