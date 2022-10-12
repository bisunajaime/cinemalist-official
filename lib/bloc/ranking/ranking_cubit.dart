import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/repository/localstorage_repository/localstorage_repository.dart';

class RankingModel extends Equatable {
  final int id;
  final String? photoUrl, title;
  // final RankingType type;

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

  Map<String, dynamic> toJson() => {
        'id': id,
        'photoUrl': photoUrl,
        'title': title,
        // 'type': _rankingTypeToString[type],
      };
}

enum RankingType {
  movies,
  tvShows,
  actors,
}

final _initialMovieRankingState = <String, List<RankingModel>>{
  's': [],
  'a': [],
  'b': [],
  'c': [],
  'd': [],
  'f': [],
};

class MovieRankingCubit extends Cubit<Map<String, List<RankingModel>>> {
  late final LocalStorageRepository localStorageRepository;
  bool isLoading = true;
  MovieRankingCubit() : super(_initialMovieRankingState) {
    localStorageRepository = FileLocalStorageRepository(fileName);
    initialLoad();
  }

  void setIsLoading(bool loading) {
    isLoading = loading;
  }

  String get fileName => 'movie_rankings.json';

  Future<void> initialLoad() async {
    setIsLoading(true);
    final data = await localStorageRepository.retrieve();
    final hasData = data != null;
    print('hasData | $hasData');
    if (hasData) {
      emit(MovieRankingHelper.decodeRawData(data));
      return;
    }
    await localStorageRepository.save(jsonEncode(_initialMovieRankingState));
    setIsLoading(false);
  }

  Future<void> refresh() async {
    emit(await loadData());
  }

  Future<Map<String, List<RankingModel>>> loadData() async {
    final data = await localStorageRepository.retrieve();
    if (data == null) return {};
    return MovieRankingHelper.decodeRawData(data);
  }

  Future<bool> saveMovie(String letter, RankingModel movie) async {
    if (MovieRankingHelper.movieAlreadyRanked(movie.id, state)) {
      return false;
    }
    final rankings = state[letter];
    if (rankings?.contains(movie) == true) {
      return false;
    }
    final stateCopy = {...state};
    stateCopy[letter]!.add(movie);
    final didSave = await localStorageRepository.save(
      MovieRankingHelper.encodeData(stateCopy),
    );
    emit(stateCopy);
    return didSave;
  }

  Future<bool> removeMovie(String letter, RankingModel record) async {
    final stateCopy = {...state};
    stateCopy[letter]?.remove(record);
    final didRemove = await localStorageRepository
        .save(MovieRankingHelper.encodeData(stateCopy));
    emit(stateCopy);
    return didRemove;
  }

  Future<void> updateMovieIndex(
    String letter,
    int oldIndex,
    int newIndex,
  ) async {
    final stateCopy = {...state};
    final rankingData = stateCopy[letter];
    final movedMovie = rankingData![oldIndex];
    rankingData.removeAt(oldIndex);
    rankingData.insert(newIndex, movedMovie);
    stateCopy[letter] = rankingData;
    await localStorageRepository.save(MovieRankingHelper.encodeData(stateCopy));
    emit(stateCopy);
  }
}

class MovieRankingHelper {
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

  static bool movieAlreadyRanked(
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
}
