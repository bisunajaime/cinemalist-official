import 'package:meta/meta.dart';
import 'package:tmdbflutter/models/actor_info_model.dart';
import 'package:tmdbflutter/models/movie_info_model.dart';
import 'package:tmdbflutter/models/cast_model.dart';
import 'package:tmdbflutter/models/tvshow_model.dart';
import 'package:tmdbflutter/models/tvshowcredits_model.dart';
import 'package:tmdbflutter/repository/tmdb_api_client.dart';
import 'package:tmdbflutter/barrels/models.dart';

import '../barrels/models.dart';
import '../barrels/models.dart';
import '../barrels/models.dart';

class TMDBRepository {
  final TMDBApiClient tmdbApiClient;

  TMDBRepository({@required this.tmdbApiClient})
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

  Future<List<GenericMoviesModel>> fetchNowPlaying({int page}) async {
    return await tmdbApiClient.fetchNowPlaying(page: page);
  }

  Future<List<TVShowModel>> fetchPopularTvShows({int page}) async {
    return await tmdbApiClient.fetchPopularTvShows(page: page);
  }

  Future<MovieInfoModel> fetchMovieInfo({int id}) async {
    return await tmdbApiClient.fetchMovieInfo(id: id);
  }

  Future<List<CastModel>> fetchMovieCasts({int id}) async {
    return await tmdbApiClient.fetchMovieCasts(id: id);
  }

  Future<TvShowCreditsModel> fetchTvShowCredits({int id}) async {
    return await tmdbApiClient.fetchTvShowCredits(id: id);
  }

  Future<ActorInfoModel> fetchActorInfo({int id}) async {
    return await tmdbApiClient.fetchActorInfo(id: id);
  }

  Future<List<GenericMoviesModel>> fetchSimilarMovies({int id}) async {
    return await tmdbApiClient.fetchSimilarMovies(id: id);
  }
}
