import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class TVShowModel extends Equatable {
  final String? originalName, name, firstAirDate, posterPath, overview;
  final double? popularity, voteAverage;
  final int? voteCount, id;
  TVShowModel({
    required this.id,
    required this.originalName,
    required this.name,
    required this.firstAirDate,
    required this.posterPath,
    required this.overview,
    required this.popularity,
    required this.voteAverage,
    required this.voteCount,
  });

  factory TVShowModel.fromJson(Map<String, dynamic> json) {
    return TVShowModel(
      id: json['id'],
      originalName: json['original_name'],
      name: json['name'],
      firstAirDate: json['first_air_date'],
      posterPath: json['poster_path'],
      overview: json['overview'],
      popularity: json['popularity'].toDouble(),
      voteAverage: json['vote_average'].toDouble(),
      voteCount: json['vote_count'],
    );
  }

  @override
  List<Object> get props => [
        id!,
        originalName!,
        name!,
        firstAirDate!,
        posterPath!,
        overview!,
        popularity!,
        voteAverage!,
        voteCount!,
      ];

  @override
  String toString() => 'TvShow { id: $id }';
}

/*

{
      "original_name": "Dark",
      "genre_ids": [
        80,
        18,
        9648,
        10765
      ],
      "name": "Dark",
      "popularity": 165.163,
      "origin_country": [
        "DE"
      ],
      "vote_count": 2312,
      "first_air_date": "2017-12-01",
      "backdrop_path": "/3lBDg3i6nn5R2NKFCJ6oKyUo2j5.jpg",
      "original_language": "de",
      "id": 70523,
      "vote_average": 8.5,
      "overview": "A missing child causes four families to help each other for answers. What they could not imagine is that this mystery would be connected to innumerable other secrets of the small town.",
      "poster_path": "/apbrbWs8M9lyOpJYU5WXrpFbk1Z.jpg"
    },
 */
