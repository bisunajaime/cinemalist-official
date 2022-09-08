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

  static const _SEARCH_RESULT_LIMIT = 9;

  String get fileName => 'search_history.json';
  List<String> get searchedTexts =>
      state.map((e) => e.text.toLowerCase()).toList();

  void initialLoad() {
    _retrieve().then((value) {
      emit(value);
    });
  }

  Future<void> clear() async {
    emit([]);
    await localStorageRepository.remove();
  }

  bool modelValid(SearchHistoryModel model) {
    if (model.text.isEmpty) return false;
    if (model.text.trim().isEmpty) return false;
    if (searchedTexts.contains(model.text.toLowerCase())) return false;
    return true;
  }

  Future<void> save(SearchHistoryModel model) async {
    if (modelValid(model) == false) return;
    var copy = [...state];
    copy.insert(0, model);
    copy = copy.take(_SEARCH_RESULT_LIMIT).toList();
    final didSave =
        await localStorageRepository.save(_convertListToString(copy));
    if (!didSave) print('There was a problem');
    emit(copy);
  }

  String _convertListToString(List<SearchHistoryModel> results) {
    return jsonEncode(results.map((e) => e.toJson()).toList());
  }

  Future<List<SearchHistoryModel>> _retrieve() async {
    final data = await localStorageRepository.retrieve();
    if (data == null) return [];
    return (jsonDecode(data) as List)
        .map((e) => SearchHistoryModel.fromJson(e))
        .toList();
  }
}
