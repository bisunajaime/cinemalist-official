import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdbflutter/models/ranking_model.dart';
import 'package:tmdbflutter/repository/localstorage_repository/localstorage_repository.dart';

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

  int get rankedRecordsCount {
    var count = 0;
    state.entries.forEach((element) {
      count += element.value.length;
    });
    return count;
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
    if (MovieRankingHelper.alreadyRanked(movie.id, state) &&
        MovieRankingHelper.alreadyRankedInLetter(movie.id, letter, state)) {
      return false;
    }
    final rankings = state[letter];
    if (rankings?.contains(movie) == true) {
      return false;
    }
    final letterOfMovie = MovieRankingHelper.findLetterOfModel(state, movie);
    if (letterOfMovie != null) {
      state[letterOfMovie]?.remove(movie);
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
    final nIndex = newIndex > rankingData.length ? newIndex - 1 : newIndex;
    rankingData.insert(nIndex, movedMovie);
    stateCopy[letter] = rankingData;
    await localStorageRepository.save(MovieRankingHelper.encodeData(stateCopy));
    emit(stateCopy);
  }
}
