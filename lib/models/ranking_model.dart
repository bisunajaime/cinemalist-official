import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:tmdbflutter/models/generic_actor_model.dart';
import 'package:tmdbflutter/models/generic_movies_model.dart';
import 'package:tmdbflutter/models/tvshow_model.dart';

enum RankingType {
  movies,
  tvShows,
  actors,
}

class RankingModel extends Equatable {
  final int id;
  final String? photoUrl, title;
  // final RankingType type;

  String? get fullPhotoUrl =>
      photoUrl != null ? 'https://image.tmdb.org/t/p/w500$photoUrl' : null;

  static Map<String, RankingType> _rankingTypeMap = {
    'movies': RankingType.movies,
    'tvShows': RankingType.tvShows,
    'actors': RankingType.actors,
  };

  static Map<RankingType, String> _rankingTypeToString = {
    RankingType.movies: 'movies',
    RankingType.tvShows: 'tvShows',
    RankingType.actors: 'actors',
  };

  RankingModel(
    this.id,
    this.photoUrl,
    this.title,
    // this.type,
  );

  @override
  List<Object?> get props => [id];

  factory RankingModel.fromJson(Map<String, dynamic> json) {
    return RankingModel(
      json['id'],
      json['photoUrl'],
      json['title'],
      // _rankingTypeMap[json['type']]!,
    );
  }

  factory RankingModel.fromGenericMovieModel(GenericMoviesModel model) {
    return RankingModel(
      model.id!,
      model.posterPath ?? '',
      model.title ?? 'No title',
      // RankingType.movies,
    );
  }

  factory RankingModel.fromGenericActorModel(GenericActorModel model) {
    return RankingModel(
      model.id!,
      model.profilePath ?? '',
      model.name ?? 'No title',
      // RankingType.movies,
    );
  }

  factory RankingModel.fromTvShowModel(TVShowModel model) {
    return RankingModel(
      model.id!,
      model.posterPath ?? '',
      model.name ?? 'No title',
      // RankingType.movies,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'photoUrl': photoUrl,
        'title': title,
        // 'type': _rankingTypeToString[type],
      };
}

class RankingHelper {
  static Map<String, List<RankingModel>> decodeRawData(String json) {
    final decodedJson = jsonDecode(json) as Map;
    return decodedJson.map(
      (key, value) => MapEntry(key as String,
          (value as List).map((e) => RankingModel.fromJson(e)).toList()),
    );
  }

  static String encodeData(Map<String, List<RankingModel>> data) {
    final mappedData = data.map(
        (key, value) => MapEntry(key, value.map((e) => e.toJson()).toList()));
    return jsonEncode(mappedData);
  }

  static bool alreadyRankedInLetter(
    int movieId,
    String letter,
    Map<String, List<RankingModel>> data,
  ) {
    final selectedLetter = data[letter];
    final ids = selectedLetter?.map((e) => e.id);
    final exists = ids?.contains(movieId) == true;
    return exists;
  }

  static bool alreadyRanked(
    int movieId,
    Map<String, List<RankingModel>> data,
  ) {
    final keys = data.keys;
    for (var k in keys) {
      final idList = data[k]!.map((e) => e.id);
      if (idList.contains(movieId)) {
        return true;
      }
    }
    return false;
  }

  static String? findLetterOfModel(
    Map<String, List<RankingModel>> data,
    RankingModel model,
  ) {
    final keys = data.keys;
    for (var k in keys) {
      final lst = data[k];
      if (lst?.contains(model) == true) {
        return k;
      }
    }
    return null;
  }
}
