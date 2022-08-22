import 'dart:convert';

abstract class SerializableClass {
  Map<String, dynamic> toJson();
}

class GenericMoviesModel extends SerializableClass {
  final double? popularity;
  final int? voteCount;
  final bool? video;
  final String? posterPath;
  final int? id;
  final bool? adult;
  final String? title;
  final double? voteAverage;
  final String? overview;
  final String? releaseDate;
  final List<int>? genreIds;

  GenericMoviesModel({
    this.popularity,
    this.voteCount,
    this.video,
    this.posterPath,
    this.id,
    this.adult,
    this.title,
    this.voteAverage,
    this.overview,
    this.releaseDate,
    this.genreIds,
  });

  factory GenericMoviesModel.fromJson(Map<String, dynamic> json) {
    return GenericMoviesModel(
      // popularity: json['popularity'],
      // voteCount: json['vote_count'],
      // video: json['video'],
      posterPath: json['poster_path'],
      id: json['id'],
      // adult: json['adult'],
      title: json['title'],
      genreIds: json["genre_ids"].cast<int>(),
      voteAverage: json['vote_average'].toDouble(),
      overview: json['overview'],
      releaseDate: json['release_date'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "genre_ids": genreIds?.map((e) => e.toString()).toList() ?? [],
        "id": id,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date": releaseDate,
        "title": title,
        "vote_average": voteAverage,
      };
}
