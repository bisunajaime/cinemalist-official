import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdbflutter/models/search_history_model.dart';
import 'package:tmdbflutter/repository/localstorage_repository/localstorage_repository.dart';

class SearchHistoryCubit extends Cubit<List<SearchHistoryModel>> {
  late final LocalStorageRepository localStorageRepository;
  SearchHistoryCubit() : super([]) {
    localStorageRepository = FileLocalStorageRepository(fileName);
    initialLoad();
  }

  String get fileName => 'search_history.json';
  List<String> get searchedTexts => state.map((e) => e.text).toList();

  void initialLoad() {
    _retrieve().then((value) {
      emit(value);
    });
  }

  bool modelValid(SearchHistoryModel model) {
    if (model.text.isEmpty) return false;
    if (searchedTexts.contains(model.text)) return false;
    return true;
  }

  Future<void> save(SearchHistoryModel model) async {
    if (modelValid(model) == false) return;
    final didSave =
        await localStorageRepository.save(jsonEncode(model.toJson()));
    if (!didSave) print('There was a problem');
    final copy = [...state];
    copy.insert(0, model);
    emit(copy);
  }

  Future<List<SearchHistoryModel>> _retrieve() async {
    final data = await localStorageRepository.retrieve();
    if (data == null) return [];
    return (jsonDecode(data) as List)
        .map((e) => SearchHistoryModel.fromJson(e))
        .toList();
  }
}
