import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tmdbflutter/barrels/models.dart';

class ActorInfoModel extends Equatable {
  final String? birthday,
      knownForDepartment,
      name,
      biography,
      placeOfBirth,
      imdbId,
      homePage,
      profilePath,
      deathday;
  late List<GenericMoviesModel> knownFor;
  final int id;
  final double popularity;

  ActorInfoModel({
    required this.birthday,
    required this.knownForDepartment,
    required this.name,
    required this.biography,
    required this.placeOfBirth,
    required this.imdbId,
    required this.homePage,
    required this.profilePath,
    required this.deathday,
    // @required this.knownFor, // new
    required this.id,
    required this.popularity,
  });

  factory ActorInfoModel.fromJson(Map<String, dynamic> json) {
    // List knownForInfo = json['known_for'] ?? [];
    // List<GenericMoviesModel> knownFor =
    //     knownForInfo.map((e) => GenericMoviesModel.fromJson(e)).toList();

    return ActorInfoModel(
      birthday: json['birthday'] ?? "?",
      knownForDepartment: json['known_for_department'] ?? "?",
      name: json['name'] ?? "?",
      biography: json['biography'] ?? "?",
      placeOfBirth: json['place_of_birth'] ?? "?",
      imdbId: json['imdb_id'] ?? "?",
      homePage: json['homepage'] ?? "?",
      profilePath: json['profile_path'],
      deathday: json['deathday'] ?? "?",
//      knownFor: knownFor ?? [],
      id: json['id'] ?? 0,
      popularity: json['popularity'].toDouble() ?? 0,
    );
  }

  @override
  List<Object> get props => [
        birthday!,
        knownForDepartment!,
        name!,
        biography!,
        placeOfBirth!,
        imdbId!,
        homePage!,
        deathday!,
        knownFor,
        id,
        popularity,
      ];
}
