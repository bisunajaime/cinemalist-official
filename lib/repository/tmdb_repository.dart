import 'package:meta/meta.dart';
import 'package:tmdbflutter/models/actor_info_model.dart';
import 'package:tmdbflutter/models/movie_info_model.dart';
import 'package:tmdbflutter/models/cast_model.dart';
import 'package:tmdbflutter/models/movieinfo/MovieInfo.dart';
import 'package:tmdbflutter/models/season_model.dart';
import 'package:tmdbflutter/models/tvshow_model.dart';
import 'package:tmdbflutter/models/tvshowcredits_model.dart';
import 'package:tmdbflutter/repository/tmdb_api_client.dart';
import 'package:tmdbflutter/barrels/models.dart';

import '../barrels/models.dart';

class TMDBRepository {
  final TMDBApiClient tmdbApiClient;

  TMDBRepository({required this.tmdbApiClient})
      : assert(tmdbApiClient != null);

  Future<List<GenresModel>> fetchCategories() async {
    return await tmdbApiClient.fetchCategories();
  }

  Future<List<GenericMoviesModel>> fetchPopular() async {
    return await tmdbApiClient.fetchPopular();
  }

  Future<List<GenericMoviesModel>> fetchUpcoming() async {
    return await tmdbApiClient.fetchUpcoming();
  }

  Future<List<GenericMoviesModel>> fetchTrending() async {
    return await tmdbApiClient.fetchTrending();
  }

  Future<List<ActorsModel>> fetchActors() async {
    return await tmdbApiClient.fetchActors();
  }

  Future<List<GenericMoviesModel>> fetchNowPlaying({int? page}) async {
    return await tmdbApiClient.fetchNowPlaying(page: page);
  }

  Future<List<TVShowModel>> fetchPopularTvShows({int? page}) async {
    return await tmdbApiClient.fetchPopularTvShows(page: page);
  }

  Future<MovieInfo> fetchMovieInfo({int? id}) async {
    return await tmdbApiClient.fetchMovieInfo(id: id);
  }

  Future<List<CastModel>> fetchMovieCasts({int? id}) async {
    return await tmdbApiClient.fetchMovieCasts(id: id);
  }

  Future<TvShowCreditsModel> fetchTvShowCredits({int? id}) async {
    return await tmdbApiClient.fetchTvShowCredits(id: id);
  }

  Future<ActorInfoModel> fetchActorInfo({int? id}) async {
    return await tmdbApiClient.fetchActorInfo(id: id);
  }

  Future<List<GenericMoviesModel>> fetchSimilarMovies({int? id}) async {
    return await tmdbApiClient.fetchSimilarMovies(id: id);
  }

  Future<List<TVShowModel>> fetchSimilarTvShows({int? id}) async {
    return await tmdbApiClient.fetchSimilarTvShows(id: id);
  }

  Future<List<GenericMoviesModel>> fetchActorMovies({int? id}) async {
    return await tmdbApiClient.fetchActorMovies(id: id);
  }

  Future<List<GenericMoviesModel>> fetchMoviesByGenre(
      {int? id, int? page}) async {
    return await tmdbApiClient.fetchMoviesByGenre(id: id, page: page);
  }

  Future<List<SeasonModel>> fetchTvSeasons({int? id}) async {
    return await tmdbApiClient.fetchTvSeasons(id: id);
  }

  Future fetchSearchResults({String? type, String? query, int? page}) async {
    return await tmdbApiClient.fetchSearchResults(
      type: type,
      query: query,
      page: page,
    );
  }
}
