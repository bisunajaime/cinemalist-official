import 'package:equatable/equatable.dart';

class GenericMoviesModel extends Equatable {
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
  });

  @override
  List<Object> get props => [
        popularity!,
        voteCount!,
        video!,
        posterPath!,
        id!,
        adult!,
        title!,
        voteAverage!,
        overview!,
        releaseDate!,
      ];

  factory GenericMoviesModel.fromJson(Map<String, dynamic> json) {
    return GenericMoviesModel(
      // popularity: json['popularity'],
      // voteCount: json['vote_count'],
      // video: json['video'],
      posterPath: json['poster_path'],
      id: json['id'],
      // adult: json['adult'],
      title: json['title'],
      voteAverage: json['vote_average'].toDouble(),
      overview: json['overview'],
      releaseDate: json['release_date'],
    );
  }
}

/**
 * 
 * {
      "popularity": 167.729,
      "vote_count": 3823,
      "video": false,
      "poster_path": "/xBHvZcjRiWyobQ9kxBhO6B2dtRI.jpg",
      "id": 419704,
      "adult": false,
      "backdrop_path": "/5BwqwxMEjeFtdknRV792Svo0K1v.jpg",
      "original_language": "en",
      "original_title": "Ad Astra",
      "genre_ids": [
        18,
        878
      ],
      "title": "Ad Astra",
      "vote_average": 6.1,
      "overview": "The near future, a time when both hope and hardships drive humanity to look to the stars and beyond. While a mysterious phenomenon menaces to destroy life on planet Earth, astronaut Roy McBride undertakes a mission across the immensity of space and its many perils to uncover the truth about a lost expedition that decades before boldly faced emptiness and silence in search of the unknown.",
      "release_date": "2019-09-17"
    },
 * 
 */
