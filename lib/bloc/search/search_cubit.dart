import 'package:flutter/cupertino.dart';
import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/library/cubit.dart';
import 'package:tmdbflutter/models/search_model.dart';
import 'package:tmdbflutter/models/tvshow_model.dart';
import 'package:tmdbflutter/repository/tmdb_repository/tmdb_repository.dart';

class SearchCubit extends SearchTMDBCubit<SearchModel?> {
  final searchController = TextEditingController();

  static final types = <String>[
    'movie',
    'person',
    'tv',
  ];

  SearchCubit(TMDBRepository tmdbRepository)
      : super(tmdbRepository, initialState: SearchModel.initial());

  List<ActorsModel>? get actorResults => state?.actors;
  List<GenericMoviesModel>? get movieResults => state?.movies;
  List<TVShowModel>? get tvResults => state?.tvShows;

  bool get hasResults =>
      actorResults?.isNotEmpty == true ||
      movieResults?.isNotEmpty == true ||
      tvResults?.isNotEmpty == true;

  Future<void> search(String searchString) async {
    if (searchString.isEmpty) {
      clearResults();
      return;
    }
    if (query.toLowerCase() == searchString.toLowerCase()) {
      return;
    }
    query = searchString;
    didSearch = true;
    logger.waiting('searching movies, actors, and tv for: $searchString');
    isLoading = true;
    final actorsResults = tmdbRepository.fetchSearchResults(
        type: 'person', query: searchString, page: 1);
    final movieResults = tmdbRepository.fetchSearchResults(
        type: 'movie', query: searchString, page: 1);
    final tvResults = tmdbRepository.fetchSearchResults(
        type: 'tv', query: searchString, page: 1);
    final results = await Future.wait([
      actorsResults,
      movieResults,
      tvResults,
    ]);
    logger.info(
        'ACTORS: ${results[0].length} - MOVIE: ${results[1].length} - TV: ${results[2].length}');
    emit(state?.copyWith(
      actors: results[0],
      movies: results[1],
      tvShows: results[2],
    ));
    isLoading = false;
  }

  void updateSearchController(String text) {
    searchController.text = text;
    searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: searchController.text.length));
  }

  @override
  String get name => 'SearchCubit';

  @override
  Future<SearchModel?> loadFromServer() {
    // TODO: implement loadFromServer
    throw UnimplementedError();
  }

  @override
  void clearResults() {
    didSearch = false;
    query = '';
    searchController.clear();
    emit(SearchModel.initial());
  }
}
