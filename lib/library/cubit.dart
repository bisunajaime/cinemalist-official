import 'dart:convert';

import 'package:bloc/bloc.dart' as c;
import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cinemalist/models/generic_movies_model.dart';
import 'package:cinemalist/repository/localstorage_repository/localstorage_repository.dart';
import 'package:cinemalist/repository/log.dart';
import 'package:cinemalist/repository/logger_log.dart';
import 'package:cinemalist/repository/tmdb_repository/tmdb_repository.dart';

abstract class Cubit<T> extends c.Cubit<T?> {
  String get name;

  /// [fileName] - must be a .json file
  String? get fileName;
  String? get toJson;
  Log get logger => LoggerLog(name);
  late final LocalStorageRepository localRepository;
  Cubit(initialState) : super(initialState ?? null) {
    if (fileName != null) {
      assert(fileName!.contains('.json'));
      localRepository = FileLocalStorageRepository(fileName!);
    }
  }

  bool isLoading = true;

  void setIsLoading(bool loading) {
    isLoading = loading;
  }

  bool get loading => state == null && isLoading;
  bool get loadingAndNotNull => state != null && isLoading;
  bool get error => state == null && isLoading == false;

  Future<T?> loadFromServer();

  Future<void> saveLocal() async {
    if (fileName != null && toJson != null) {
      await localRepository.save(toJson!);
    }
  }

  Future<bool> hasInternet() async {
    final connectivity = Connectivity();
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<void> loadData() async {
    try {
      logger.waiting('loading data');
      setIsLoading(true);
      var result;
      if (await hasInternet()) {
        result = await loadFromServer();
      } else {
        // TODO:
        // result = await loadFromFile();
      }
      emit(result);
      setIsLoading(false);
      // await saveLocal();
      logger.success('data loaded');
    } catch (e) {
      logger.error('there was a problem: $e');
    }
  }
}

abstract class TMDBCubit<T> extends Cubit<T?> {
  final TMDBRepository tmdbRepository;
  TMDBCubit(this.tmdbRepository, {initialState}) : super(initialState ?? null);

  @override
  String? get fileName => null;

  @override
  String? get toJson => null;

  Future<void> refresh() async {
    logger.info('pulled to refresh');
    isLoading = true;
    emit(null);
    await loadData();
  }
}

abstract class SearchTMDBCubit<T> extends Cubit<T?> {
  final TMDBRepository tmdbRepository;
  bool didSearch = false;
  String query = '';

  @override
  String? get fileName => null;
  @override
  String? get toJson => null;

  SearchTMDBCubit(this.tmdbRepository, {initialState})
      : super(initialState ?? null);

  void clearResults();
}

abstract class LocalStorageCubit<T extends SerializableClass>
    extends c.Cubit<List<T>> {
  late final LocalStorageRepository localStorageRepository;
  LocalStorageCubit(List<T> initialState) : super(initialState) {
    localStorageRepository = FileLocalStorageRepository(fileName);
    loadFromLocal();
  }

  String get fileName;
  Future<void> loadFromLocal() async {
    final results = await retrieve();
    emit(results);
  }

  List<int> get ids => state.map((e) => e.id!).toList();

  bool isSaved(T model) {
    return ids.contains(model.id!);
  }

  Future<bool> save(T record) async {
    final results = [...state];
    final hasRecord =
        results.firstWhereOrNull((element) => element.id == record.id);
    final remove = hasRecord != null;
    if (remove) {
      results.removeWhere((element) => element.id == record.id);
    } else {
      results.insert(0, record);
    }
    final newResults = jsonEncode(results.map((e) {
      e.toJson();
      return e.toJson();
    }).toList());
    await localStorageRepository.save(newResults);
    emit(results);
    return true;
  }

  Future<List<T>> retrieve();
  Future<bool> remove() async {
    emit([]);
    return await localStorageRepository.remove();
  }
}

abstract class PagedTMDBCubit<T> extends Cubit<List<T>?> {
  final TMDBRepository tmdbRepository;
  PagedTMDBCubit(this.tmdbRepository, {initialState})
      : super(initialState ?? <T>[]);
  bool loadingNextPage = false;
  bool initialLoading = true;
  bool hasReachedMax = false;

  @override
  String? get fileName => null;
  @override
  String? get toJson => null;

  @override
  bool get loading => state?.isEmpty == true && initialLoading == true;

  int page = 1;

  Future<List<T>?> loadFromServerWithPage(int page);

  Future<void> refresh() async {
    logger.waiting('refreshing');
    state?.clear();
    page = 1;
    hasReachedMax = false;
    initialLoading = true;
    loadingNextPage = false;
    await loadFirstPage();
    logger.success('refreshed');
  }

  Future<void> loadFirstPage() async {
    logger.waiting('loading first page');
    page = 1;
    initialLoading = true;
    final results = await loadFromServer();
    logger.success('first page loaded');
    if (results == null) return null;
    state?.addAll(results.toList());
    initialLoading = false;
    emit(results);
  }

  Future<void> loadNextPage({required Function onComplete}) async {
    if (hasReachedMax) {
      logger.info('reached max');
      return;
    }
    if (loadingNextPage == true) {
      return;
    }
    page++;
    logger.waiting('loading next page: $page');
    loadingNextPage = true;
    final results = await loadFromServerWithPage(page);
    if (results == null) {
      logger.error('no results from server');
      return;
    }
    state?.addAll(results.toList());
    loadingNextPage = false;
    if (results.isEmpty && state?.isNotEmpty == true) {
      logger.info('reached max');
      hasReachedMax = true;
    }
    logger.success('next page loaded for page: $page');
    onComplete();
    emit(state);
  }

  @override
  Future<void> loadData() async {
    await loadFirstPage();
  }
}
