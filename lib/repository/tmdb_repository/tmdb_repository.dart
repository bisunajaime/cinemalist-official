import 'package:cinemalist/models/actor_info_model.dart';
import 'package:cinemalist/models/actors_model.dart';
import 'package:cinemalist/models/generic_movies_model.dart';
import 'package:cinemalist/models/genres_model.dart';
import 'package:cinemalist/models/movieinfo/MovieInfo.dart';
import 'package:cinemalist/models/season_model.dart';
import 'package:cinemalist/models/tvshow_model.dart';
import 'package:cinemalist/models/tvshowcredits_model.dart';

abstract class TMDBRepository {
  Future<List<GenresModel>> fetchCategories();

  Future<List<GenericMoviesModel>> fetchPopular();

  Future<List<GenericMoviesModel>> fetchUpcoming();

  Future<List<GenericMoviesModel>> fetchTrending();

  Future<List<ActorsModel>> fetchActors();

  Future<List<GenericMoviesModel>> fetchNowPlaying({int? page});

  Future<List<TVShowModel>> fetchPopularTvShows({int? page});

  Future<MovieInfo> fetchMovieInfo({int? id});

  Future<List<ActorInfoModel>> fetchMovieCasts({int? id});

  Future<TvShowCreditsModel> fetchTvShowCredits({int? id});

  Future<ActorInfoModel> fetchActorInfo({int? id});

  Future<List<GenericMoviesModel>> fetchSimilarMovies({int? id, int? page});

  Future<List<TVShowModel>> fetchSimilarTvShows({int? id, int? page});

  Future<List<GenericMoviesModel>> fetchActorMovies({int? id, int? page});

  Future<List<GenericMoviesModel>> fetchMoviesByGenre({int? id, int? page});

  Future<List<SeasonModel>> fetchTvSeasons({int? id});

  Future fetchSearchResults({String? type, String? query, int? page});
}
