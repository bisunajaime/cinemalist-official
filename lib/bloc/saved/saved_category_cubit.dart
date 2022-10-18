import 'dart:convert';

import 'package:cinemalist/models/saved_category_model.dart';
import 'package:cinemalist/repository/localstorage_repository/localstorage_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavedCategoryCubit extends Cubit<List<SavedCategoryModel>> {
  late final LocalStorageRepository localStorageRepository;
  SavedCategoryCubit() : super([]) {
    localStorageRepository = FileLocalStorageRepository(fileName);
    init();
  }

  String get fileName => 'saved_categories_model.json';

  Future init() async {
    emit(await retrieveSavedCategories());
  }

  Future<List<SavedCategoryModel>> retrieveSavedCategories() async {
    final json = await localStorageRepository.retrieve();
    if (json == null) {
      await localStorageRepository.save(jsonEncode([]));
      return [];
    }
    final decodedJson = jsonDecode(json) as List;
    final savedCategories =
        decodedJson.map((e) => SavedCategoryModel.fromJson(e));
    return savedCategories.toList();
  }

  Future<bool> saveCategory(SavedCategoryModel model) async {
    final copy = [...state];
    if (copy.contains(model)) {
      // update
      final index = copy.indexOf(model);
      copy.removeAt(index);
      copy.insert(index, model);
    } else {
      copy.insert(0, model);
    }
    final json = jsonEncode(copy.map((e) => e.toJson()).toList());
    final saved = await localStorageRepository.save(json);
    emit(copy);
    return saved;
  }

  Future<bool> removeCategory(SavedCategoryModel model) async {
    final copy = [...state];
    copy.removeWhere((element) => element == model);
    final json = jsonEncode(copy.map((e) => e.toJson()).toList());
    final saved = await localStorageRepository.save(json);
    emit(copy);
    return saved;
  }
}

/// when saving a record to a category follow this data structure
/// so when removing a saved category, can just remove the uuid from the list
final savedMovies = {
  'uuid_1': [
    {'saved_movie_1': ''},
    {'saved_movie_2': ''},
    {'saved_movie_3': ''},
  ],
  'uuid_2': {
    'actors': [],
    'movies': [],
    'tvshows': [],
  },
};
