import 'package:cinemalist/utils/cinemalist_constants.dart';
import 'package:equatable/equatable.dart';

class SeasonModel extends Equatable {
  final String? airDate, name, posterPath, overview;
  final int? episodeCount, id, seasonNumber;

  SeasonModel({
    this.airDate,
    this.name,
    this.posterPath,
    this.overview,
    this.episodeCount,
    this.id,
    this.seasonNumber,
  });

  String get mainPosterPath {
    if (posterPath == null) {
      return 'placeholder_posterpath';
    }
    return CinemalistConstants.tmdbImagePath + posterPath!;
  }

  factory SeasonModel.fromJson(Map<String, dynamic> json) {
    return SeasonModel(
      airDate: json['air_date'],
      name: json['name'],
      posterPath: json['poster_path'],
      overview: json['overview'],
      episodeCount: json['episode_count'],
      id: json['id'],
      seasonNumber: json['season_number'],
    );
  }

  @override
  List<Object> get props => [
        airDate!,
        name!,
        posterPath!,
        overview!,
        episodeCount!,
        id!,
        seasonNumber!,
      ];

  @override
  String toString() => "Season { seasonId: $id }";
}

/*

{
      "air_date": "1987-04-19",
      "episode_count": 63,
      "id": 3581,
      "name": "Specials",
      "overview": "",
      "poster_path": "/lzN0CllVFXtGtSl15r59Kb52DdT.jpg",
      "season_number": 0
    },

 */
