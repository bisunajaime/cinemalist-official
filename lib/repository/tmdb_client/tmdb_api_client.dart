import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cinemalist/barrels/models.dart';
import 'package:cinemalist/models/actor_info_model.dart';
import 'package:cinemalist/models/builder/filter_builder.dart';
import 'package:cinemalist/models/movieinfo/MovieInfo.dart';
import 'package:cinemalist/models/season_model.dart';
import 'package:cinemalist/models/tvshow_model.dart';
import 'package:cinemalist/models/tvshowcredits_model.dart';
import 'package:cinemalist/repository/search_results_repository.dart';
import 'package:cinemalist/repository/tmdb_client/tmdb_client.dart';
import 'package:cinemalist/repository/uri_generator.dart';

class TMDBApiClient implements TMDBClient {
  final String apiKey;
  final baseUrl = 'api.themoviedb.org';
  final version = '/3';
  final http.Client httpClient;
  late final UriLoader uriLoader;

  TMDBApiClient({required this.httpClient, required this.apiKey}) {
    uriLoader = TMDBUriLoader(baseUrl, version, apiKey);
  }

  Future<dynamic> _fetchJson(String url, [Map<String, dynamic>? filters]) async {
    final response = await httpClient.get(uriLoader.generateUri(url, filters));
    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode} on $url');
    }
    return jsonDecode(response.body);
  }

  List<T> _parseList<T>(dynamic json, String key, T Function(Map<String, dynamic>) fromJson) {
    return (json[key] as List).map((data) => fromJson(data)).toList();
  }

  @override
  Future<List<GenresModel>> fetchCategories() async {
    final json = await _fetchJson('/genre/movie/list');
    return _parseList(json, 'genres', GenresModel.fromJson);
  }

  @override
  Future<List<GenericMoviesModel>> fetchPopular() async {
    final filter = FilterBuilder().sortBy().page(1);
    final json = await _fetchJson('/discover/movie', filter.toJson());
    return _parseList(json, 'results', GenericMoviesModel.fromJson);
  }

  @override
  Future<List<GenericMoviesModel>> fetchUpcoming() async {
    final json = await _fetchJson('/movie/upcoming');
    return _parseList(json, 'results', GenericMoviesModel.fromJson);
  }

  @override
  Future<List<GenericMoviesModel>> fetchTrending() async {
    final json = await _fetchJson('/trending/movie/week');
    return _parseList(json, 'results', GenericMoviesModel.fromJson);
  }

  @override
  Future<List<ActorsModel>> fetchActors() async {
    final json = await _fetchJson('/person/popular');
    return _parseList(json, 'results', ActorsModel.fromJson);
  }

  @override
  Future<List<GenericMoviesModel>> fetchNowPlaying({int? page}) async {
    final filters = FilterBuilder().page(page);
    final json = await _fetchJson('/movie/now_playing', filters.toJson());
    return _parseList(json, 'results', GenericMoviesModel.fromJson);
  }

  @override
  Future<List<TVShowModel>> fetchPopularTvShows({int? page}) async {
    final filters = FilterBuilder().sortBy().includeAdult().page(page);
    final json = await _fetchJson('/discover/tv', filters.toJson());
    return _parseList(json, 'results', TVShowModel.fromJson);
  }

  @override
  Future<MovieInfo> fetchMovieInfo({int? id}) async {
    final filters = FilterBuilder().appendToResponse();
    final json = await _fetchJson('/movie/$id', filters.toJson());
    return MovieInfo.fromJson(json);
  }

  @override
  Future<List<ActorInfoModel>> fetchMovieCasts({int? id}) async {
    final json = await _fetchJson('/movie/$id/credits');
    return _parseList(json, 'cast', ActorInfoModel.fromJson);
  }

  @override
  Future<TvShowCreditsModel> fetchTvShowCredits({int? id}) async {
    final json = await _fetchJson('/tv/$id/credits');
    return TvShowCreditsModel.fromJson(json);
  }

  @override
  Future<ActorInfoModel> fetchActorInfo({int? id}) async {
    final json = await _fetchJson('/person/$id');
    return ActorInfoModel.fromJson(json);
  }

  @override
  Future<List<GenericMoviesModel>> fetchSimilarMovies({int? id, int? page}) async {
    final filters = FilterBuilder().page(page);
    final json = await _fetchJson('/movie/$id/similar', filters.toJson());
    return _parseList(json, 'results', GenericMoviesModel.fromJson);
  }

  @override
  Future<List<TVShowModel>> fetchSimilarTvShows({int? id, int? page}) async {
    final filters = FilterBuilder().page(page);
    final json = await _fetchJson('/tv/$id/similar', filters.toJson());
    return _parseList(json, 'results', TVShowModel.fromJson);
  }

  @override
  Future<List<GenericMoviesModel>> fetchMoviesByGenre({int? id, int? page}) async {
    final filters = FilterBuilder()
        .sortBy()
        .includeAdult(include: false)
        .page(page)
        .withGenres(id);
    final json = await _fetchJson('/discover/movie', filters.toJson());
    return _parseList(json, 'results', GenericMoviesModel.fromJson);
  }

  @override
  Future<List<GenericMoviesModel>> fetchActorMovies({int? id, int? page}) async {
    final filters = FilterBuilder().sortBy().includeAdult().page(page).withCast(id);
    final json = await _fetchJson('/discover/movie', filters.toJson());
    return _parseList(json, 'results', GenericMoviesModel.fromJson);
  }

  @override
  Future<List<SeasonModel>> fetchTvSeasons({int? id}) async {
    final json = await _fetchJson('/tv/$id');
    return _parseList(json, 'seasons', SeasonModel.fromJson);
  }

  @override
  Future fetchSearchResults({String? type, String? query, int? page}) async {
    SearchResultsRepository searchResults =
        DefaultSearchResults(uriLoader, httpClient);
    switch (type) {
      case 'movie':
        searchResults = MovieSearchResults(uriLoader, httpClient);
        break;
      case 'person':
        searchResults = PersonSearchResults(uriLoader, httpClient);
        break;
      case 'tv':
        searchResults = TvSearchResults(uriLoader, httpClient);
        break;
      case 'clear':
        return [];
    }
    return await searchResults.searchMovies(query, page);
  }
}
