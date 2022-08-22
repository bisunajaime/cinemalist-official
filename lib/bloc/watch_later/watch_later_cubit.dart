import 'dart:convert';
import 'package:collection/collection.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/library/cubit.dart';
import 'package:tmdbflutter/library/cubit.dart';
import 'package:tmdbflutter/library/cubit.dart';
import 'package:tmdbflutter/models/generic_actor_model.dart';
import 'package:tmdbflutter/models/tvshow_model.dart';
import 'package:tmdbflutter/repository/localstorage_repository/localstorage_repository.dart';

class MoviesWatchLaterCubit extends LocalStorageCubit<GenericMoviesModel> {
  MoviesWatchLaterCubit() : super([]);

  @override
  String get fileName => 'movies_watch_later.json';

  @override
  Future<List<GenericMoviesModel>> retrieve() async {
    final data = await localStorageRepository.retrieve();
    if (data == null) return [];
    return (jsonDecode(data) as List)
        .map((e) => GenericMoviesModel.fromJson(e))
        .toList();
  }
}

class TvWatchLaterCubit extends LocalStorageCubit<TVShowModel> {
  TvWatchLaterCubit() : super([]);

  @override
  String get fileName => 'tv_shows_watch_later.json';

  @override
  Future<List<TVShowModel>> retrieve() async {
    final data = await localStorageRepository.retrieve();
    if (data == null) return [];
    return (jsonDecode(data) as List)
        .map((e) => TVShowModel.fromJson(e))
        .toList();
  }
}

class SavedActorsCubit extends LocalStorageCubit<GenericActorModel> {
  SavedActorsCubit() : super([]);

  @override
  String get fileName => 'saved_actors.json';

  @override
  Future<List<GenericActorModel>> retrieve() async {
    final data = await localStorageRepository.retrieve();
    if (data == null) return [];
    return (jsonDecode(data) as List)
        .map((e) => GenericActorModel.fromJson(e))
        .toList();
  }
}
