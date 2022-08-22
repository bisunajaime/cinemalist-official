import 'package:tmdbflutter/models/actor_info_model.dart';
import 'package:tmdbflutter/models/cast_model.dart';
import 'package:tmdbflutter/models/movieinfo/MovieInfo.dart';
import 'package:tmdbflutter/models/season_model.dart';
import 'package:tmdbflutter/models/tvshow_model.dart';
import 'package:tmdbflutter/models/tvshowcredits_model.dart';
import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/repository/tmdb_client/tmdb_client.dart';
import 'package:tmdbflutter/repository/tmdb_repository/tmdb_repository.dart';

class TMDBAPIRepository implements TMDBRepository {
  final TMDBClient tmdbClient;

  TMDBAPIRepository({required this.tmdbClient});
  @override
  Future<List<GenresModel>> fetchCategories() async {
    return await tmdbClient.fetchCategories();
  }

  @override
  Future<List<GenericMoviesModel>> fetchPopular() async {
    return await tmdbClient.fetchPopular();
  }

  @override
  Future<List<GenericMoviesModel>> fetchUpcoming() async {
    return await tmdbClient.fetchUpcoming();
  }

  @override
  Future<List<GenericMoviesModel>> fetchTrending() async {
    return await tmdbClient.fetchTrending();
  }

  @override
  Future<List<ActorsModel>> fetchActors() async {
    return await tmdbClient.fetchActors();
  }

  @override
  Future<List<GenericMoviesModel>> fetchNowPlaying({int? page}) async {
    return await tmdbClient.fetchNowPlaying(page: page);
  }

  @override
  Future<List<TVShowModel>> fetchPopularTvShows({int? page}) async {
    return await tmdbClient.fetchPopularTvShows(page: page);
  }

  @override
  Future<MovieInfo> fetchMovieInfo({int? id}) async {
    return await tmdbClient.fetchMovieInfo(id: id);
  }

  @override
  Future<List<CastModel>> fetchMovieCasts({int? id}) async {
    return await tmdbClient.fetchMovieCasts(id: id);
  }

  @override
  Future<TvShowCreditsModel> fetchTvShowCredits({int? id}) async {
    return await tmdbClient.fetchTvShowCredits(id: id);
  }

  @override
  Future<ActorInfoModel> fetchActorInfo({int? id}) async {
    return await tmdbClient.fetchActorInfo(id: id);
  }

  @override
  Future<List<GenericMoviesModel>> fetchSimilarMovies(
      {int? id, int? page}) async {
    return await tmdbClient.fetchSimilarMovies(id: id, page: page);
  }

  @override
  Future<List<TVShowModel>> fetchSimilarTvShows({int? id, int? page}) async {
    return await tmdbClient.fetchSimilarTvShows(id: id, page: page);
  }

  @override
  Future<List<GenericMoviesModel>> fetchActorMovies(
      {int? id, int? page}) async {
    return await tmdbClient.fetchActorMovies(id: id, page: page);
  }

  @override
  Future<List<GenericMoviesModel>> fetchMoviesByGenre(
      {int? id, int? page}) async {
    return await tmdbClient.fetchMoviesByGenre(id: id, page: page);
  }

  @override
  Future<List<SeasonModel>> fetchTvSeasons({int? id}) async {
    return await tmdbClient.fetchTvSeasons(id: id);
  }

  @override
  Future fetchSearchResults({String? type, String? query, int? page}) async {
    return await tmdbClient.fetchSearchResults(
      type: type,
      query: query,
      page: page,
    );
  }
}
