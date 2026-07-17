import 'package:cinemalist/barrels/models.dart';
import 'package:cinemalist/models/actor_info_model.dart';
import 'package:cinemalist/models/movieinfo/MovieInfo.dart';
import 'package:cinemalist/models/season_model.dart';
import 'package:cinemalist/models/tvshow_model.dart';
import 'package:cinemalist/models/tvshowcredits_model.dart';
import 'package:cinemalist/repository/tmdb_client/tmdb_client.dart';
import 'package:cinemalist/repository/tmdb_repository/tmdb_repository.dart';

class _CacheEntry<T> {
  final T data;
  final DateTime timestamp;
  _CacheEntry(this.data) : timestamp = DateTime.now();

  bool get isExpired => DateTime.now().difference(timestamp) > const Duration(days: 2);
}

class TMDBAPIRepository implements TMDBRepository {
  final TMDBClient tmdbClient;
  final Map<String, _CacheEntry> _cache = {};

  TMDBAPIRepository({required this.tmdbClient});

  T? _getFromCache<T>(String key) {
    final entry = _cache[key];
    if (entry == null) return null;
    if (entry.isExpired) {
      _cache.remove(key);
      return null;
    }
    return entry.data as T;
  }

  void _putInCache<T>(String key, T data) {
    _cache[key] = _CacheEntry<T>(data);
  }

  Future<T> _cached<T>(String key, Future<T> Function() fetch) async {
    final hit = _getFromCache<T>(key);
    if (hit != null) return hit;
    final result = await fetch();
    _putInCache(key, result);
    return result;
  }

  @override
  Future<List<GenresModel>> fetchCategories() {
    return _cached('categories', () => tmdbClient.fetchCategories());
  }

  @override
  Future<List<GenericMoviesModel>> fetchPopular() {
    return _cached('popular', () => tmdbClient.fetchPopular());
  }

  @override
  Future<List<GenericMoviesModel>> fetchUpcoming() {
    return _cached('upcoming', () => tmdbClient.fetchUpcoming());
  }

  @override
  Future<List<GenericMoviesModel>> fetchTrending() {
    return _cached('trending', () => tmdbClient.fetchTrending());
  }

  @override
  Future<List<ActorsModel>> fetchActors() {
    return _cached('actors', () => tmdbClient.fetchActors());
  }

  @override
  Future<List<GenericMoviesModel>> fetchNowPlaying({int? page}) {
    return _cached('nowplaying_$page', () => tmdbClient.fetchNowPlaying(page: page));
  }

  @override
  Future<List<TVShowModel>> fetchPopularTvShows({int? page}) {
    return _cached('tvshows_$page', () => tmdbClient.fetchPopularTvShows(page: page));
  }

  @override
  Future<MovieInfo> fetchMovieInfo({int? id}) {
    return _cached('movie_info_$id', () => tmdbClient.fetchMovieInfo(id: id));
  }

  @override
  Future<List<ActorInfoModel>> fetchMovieCasts({int? id}) {
    return _cached('movie_casts_$id', () => tmdbClient.fetchMovieCasts(id: id));
  }

  @override
  Future<TvShowCreditsModel> fetchTvShowCredits({int? id}) {
    return _cached('tv_credits_$id', () => tmdbClient.fetchTvShowCredits(id: id));
  }

  @override
  Future<ActorInfoModel> fetchActorInfo({int? id}) {
    return _cached('actor_info_$id', () => tmdbClient.fetchActorInfo(id: id));
  }

  @override
  Future<List<GenericMoviesModel>> fetchSimilarMovies({int? id, int? page}) {
    return _cached('similar_movies_${id}_$page', () => tmdbClient.fetchSimilarMovies(id: id, page: page));
  }

  @override
  Future<List<TVShowModel>> fetchSimilarTvShows({int? id, int? page}) {
    return _cached('similar_tv_${id}_$page', () => tmdbClient.fetchSimilarTvShows(id: id, page: page));
  }

  @override
  Future<List<GenericMoviesModel>> fetchActorMovies({int? id, int? page}) {
    return _cached('actor_movies_${id}_$page', () => tmdbClient.fetchActorMovies(id: id, page: page));
  }

  @override
  Future<List<GenericMoviesModel>> fetchMoviesByGenre({int? id, int? page}) {
    return _cached('genre_movies_${id}_$page', () => tmdbClient.fetchMoviesByGenre(id: id, page: page));
  }

  @override
  Future<List<SeasonModel>> fetchTvSeasons({int? id}) {
    return _cached('tv_seasons_$id', () => tmdbClient.fetchTvSeasons(id: id));
  }

  @override
  Future fetchSearchResults({String? type, String? query, int? page}) {
    // Don't cache search — results change frequently and queries are unique
    return tmdbClient.fetchSearchResults(type: type, query: query, page: page);
  }
}
