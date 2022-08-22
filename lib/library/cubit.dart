import 'package:bloc/bloc.dart' as c;
import 'package:tmdbflutter/repository/log.dart';
import 'package:tmdbflutter/repository/logger_log.dart';
import 'package:tmdbflutter/repository/tmdb_repository/tmdb_repository.dart';

abstract class Cubit<T> extends c.Cubit<T?> {
  String get name;
  Log get logger => LoggerLog(name);
  Cubit(initialState) : super(initialState ?? null);

  bool isLoading = true;

  void setIsLoading(bool loading) {
    isLoading = loading;
  }

  bool get loading => state == null && isLoading;
  bool get loadingAndNotNull => state != null && isLoading;
  bool get error => state == null && isLoading == false;

  Future<T?> loadFromServer();

  Future<void> loadData() async {
    logger.waiting('loading data');
    setIsLoading(true);
    final result = await loadFromServer();
    // TODO: save locally and if there is no internet, use the local file
    emit(result);
    setIsLoading(false);
    logger.success('data loaded');
  }
}

abstract class TMDBCubit<T> extends Cubit<T?> {
  final TMDBRepository tmdbRepository;
  TMDBCubit(this.tmdbRepository, {initialState}) : super(initialState ?? null);

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

  SearchTMDBCubit(this.tmdbRepository, {initialState})
      : super(initialState ?? null);

  void clearResults();
}

abstract class PagedTMDBCubit<T> extends Cubit<List<T>?> {
  final TMDBRepository tmdbRepository;
  PagedTMDBCubit(this.tmdbRepository, {initialState})
      : super(initialState ?? <T>[]);
  bool loadingNextPage = false;
  bool initialLoading = true;
  bool hasReachedMax = false;

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
