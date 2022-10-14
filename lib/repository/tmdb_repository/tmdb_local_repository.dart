import 'package:cinemalist/models/actor_info_model.dart';
import 'package:cinemalist/models/actors_model.dart';
import 'package:cinemalist/models/generic_movies_model.dart';
import 'package:cinemalist/models/genres_model.dart';
import 'package:cinemalist/models/movieinfo/MovieInfo.dart';
import 'package:cinemalist/models/season_model.dart';
import 'package:cinemalist/models/tvshow_model.dart';
import 'package:cinemalist/models/tvshowcredits_model.dart';
import 'package:cinemalist/repository/tmdb_client/tmdb_client.dart';
import 'package:cinemalist/repository/tmdb_repository/tmdb_repository.dart';

class TMDBLocalRepository implements TMDBRepository {
  final TMDBClient tmdbClient;

  TMDBLocalRepository(this.tmdbClient);

  @override
  Future<ActorInfoModel> fetchActorInfo({int? id}) {
    // TODO: implement fetchActorInfo
    throw UnimplementedError();
  }

  @override
  Future<List<GenericMoviesModel>> fetchActorMovies({int? id, int? page}) {
    // TODO: implement fetchActorMovies
    throw UnimplementedError();
  }

  @override
  Future<List<ActorsModel>> fetchActors() {
    // TODO: implement fetchActors
    throw UnimplementedError();
  }

  @override
  Future<List<GenresModel>> fetchCategories() {
    // TODO: implement fetchCategories
    throw UnimplementedError();
  }

  @override
  Future<List<ActorInfoModel>> fetchMovieCasts({int? id}) {
    // TODO: implement fetchMovieCasts
    throw UnimplementedError();
  }

  @override
  Future<MovieInfo> fetchMovieInfo({int? id}) {
    // TODO: implement fetchMovieInfo
    throw UnimplementedError();
  }

  @override
  Future<List<GenericMoviesModel>> fetchMoviesByGenre({int? id, int? page}) {
    // TODO: implement fetchMoviesByGenre
    throw UnimplementedError();
  }

  @override
  Future<List<GenericMoviesModel>> fetchNowPlaying({int? page}) {
    // TODO: implement fetchNowPlaying
    throw UnimplementedError();
  }

  @override
  Future<List<GenericMoviesModel>> fetchPopular() {
    // TODO: implement fetchPopular
    throw UnimplementedError();
  }

  @override
  Future<List<TVShowModel>> fetchPopularTvShows({int? page}) {
    // TODO: implement fetchPopularTvShows
    throw UnimplementedError();
  }

  @override
  Future fetchSearchResults({String? type, String? query, int? page}) {
    // TODO: implement fetchSearchResults
    throw UnimplementedError();
  }

  @override
  Future<List<GenericMoviesModel>> fetchSimilarMovies({int? id, int? page}) {
    // TODO: implement fetchSimilarMovies
    throw UnimplementedError();
  }

  @override
  Future<List<TVShowModel>> fetchSimilarTvShows({int? id, int? page}) {
    // TODO: implement fetchSimilarTvShows
    throw UnimplementedError();
  }

  @override
  Future<List<GenericMoviesModel>> fetchTrending() {
    // TODO: implement fetchTrending
    throw UnimplementedError();
  }

  @override
  Future<List<SeasonModel>> fetchTvSeasons({int? id}) {
    // TODO: implement fetchTvSeasons
    throw UnimplementedError();
  }

  @override
  Future<TvShowCreditsModel> fetchTvShowCredits({int? id}) {
    // TODO: implement fetchTvShowCredits
    throw UnimplementedError();
  }

  @override
  Future<List<GenericMoviesModel>> fetchUpcoming() {
    // TODO: implement fetchUpcoming
    throw UnimplementedError();
  }
}
