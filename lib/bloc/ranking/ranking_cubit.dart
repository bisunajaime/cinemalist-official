import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/models/ranking_model.dart';
import 'package:cinemalist/repository/localstorage_repository/localstorage_repository.dart';

final _initialMovieRankingState = <String, List<RankingModel>>{
  's': [],
  'a': [],
  'b': [],
  'c': [],
  'd': [],
  'f': [],
};

abstract class RankingCubit extends Cubit<Map<String, List<RankingModel>>> {
  late final LocalStorageRepository localStorageRepository;
  RankingCubit() : super(_initialMovieRankingState) {
    localStorageRepository = FileLocalStorageRepository(fileName);
  }

  String get fileName;

  int get rankedRecordsCount {
    var count = 0;
    state.entries.forEach((element) {
      count += element.value.length;
    });
    return count;
  }

  Future<void> initialLoad() async {
    final data = await localStorageRepository.retrieve();
    final hasData = data != null;
    print('hasData | $hasData');
    if (hasData) {
      emit(RankingHelper.decodeRawData(data));
      return;
    }
    await localStorageRepository.save(jsonEncode(_initialMovieRankingState));
  }

  Future<bool> saveRanking(String letter, RankingModel model) async {
    if (RankingHelper.alreadyRanked(model.id, state) &&
        RankingHelper.alreadyRankedInLetter(model.id, letter, state)) {
      return false;
    }
    final rankings = state[letter];
    if (rankings?.contains(model) == true) {
      return false;
    }
    final letterOfMovie = RankingHelper.findLetterOfModel(state, model);
    if (letterOfMovie != null) {
      state[letterOfMovie]?.remove(model);
    }
    final stateCopy = {...state};
    stateCopy[letter]!.add(model);
    final didSave = await localStorageRepository.save(
      RankingHelper.encodeData(stateCopy),
    );
    emit(stateCopy);
    return didSave;
  }

  Future<void> removeRankingWithoutLetter(RankingModel record) async {
    final letter = RankingHelper.findLetterOfModel(state, record);
    if (letter == null) return;
    await removeRanking(letter, record);
  }

  Future<void> resetRankings() async {
    emit(_initialMovieRankingState);
    await localStorageRepository
        .save(RankingHelper.encodeData(_initialMovieRankingState));
  }

  Future<bool> removeRanking(String letter, RankingModel record) async {
    final stateCopy = {...state};
    stateCopy[letter]?.remove(record);
    final didRemove =
        await localStorageRepository.save(RankingHelper.encodeData(stateCopy));
    emit(stateCopy);
    return didRemove;
  }

  Future<void> updateRankingIndex(
    String letter,
    int oldIndex,
    int newIndex,
  ) async {
    final stateCopy = {...state};
    final rankingData = stateCopy[letter];
    final movedMovie = rankingData![oldIndex];
    rankingData.remove(movedMovie);
    rankingData.insert(newIndex, movedMovie);
    // final nIndex = newIndex > rankingData.length ? newIndex - 1 : newIndex - 1;
    stateCopy[letter] = rankingData;
    await localStorageRepository.save(RankingHelper.encodeData(stateCopy));
    emit(stateCopy);
  }
}
