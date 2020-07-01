import 'package:equatable/equatable.dart';

class TrendingModel extends Equatable {
  final double popularity;
  final int voteCount;
  final bool video;
  final String posterPath;
  final int id;
  final bool adult;
  final String title;
  final double voteAverage;
  final String overview;
  final String releaseDate;

  TrendingModel({
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
  });

  @override
  List<Object> get props => [
        popularity,
        voteCount,
        video,
        posterPath,
        id,
        adult,
        title,
        voteAverage,
        overview,
        releaseDate,
      ];

  factory TrendingModel.fromJson(Map<String, dynamic> json) {
    return TrendingModel(
      // popularity: json['popularity'],
      // voteCount: json['vote_count'],
      // video: json['video'],
      posterPath: json['poster_path'],
      id: json['id'],
      // adult: json['adult'],
      title: json['title'],
      voteAverage: json['vote_average'].toDouble(),
      overview: json['overview'],
      // releaseDate: json['release_date'],
    );
  }
}
