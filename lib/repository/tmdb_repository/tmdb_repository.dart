import 'package:tmdbflutter/models/actor_info_model.dart';
import 'package:tmdbflutter/models/actors_model.dart';
import 'package:tmdbflutter/models/cast_model.dart';
import 'package:tmdbflutter/models/generic_movies_model.dart';
import 'package:tmdbflutter/models/genres_model.dart';
import 'package:tmdbflutter/models/movieinfo/MovieInfo.dart';
import 'package:tmdbflutter/models/season_model.dart';
import 'package:tmdbflutter/models/tvshow_model.dart';
import 'package:tmdbflutter/models/tvshowcredits_model.dart';

abstract class TMDBRepository {
  Future<List<GenresModel>> fetchCategories();

  Future<List<GenericMoviesModel>> fetchPopular();

  Future<List<GenericMoviesModel>> fetchUpcoming();

  Future<List<GenericMoviesModel>> fetchTrending();

  Future<List<ActorsModel>> fetchActors();

  Future<List<GenericMoviesModel>> fetchNowPlaying({int? page});

  Future<List<TVShowModel>> fetchPopularTvShows({int? page});

  Future<MovieInfo> fetchMovieInfo({int? id});

  Future<List<CastModel>> fetchMovieCasts({int? id});

  Future<TvShowCreditsModel> fetchTvShowCredits({int? id});

  Future<ActorInfoModel> fetchActorInfo({int? id});

  Future<List<GenericMoviesModel>> fetchSimilarMovies({int? id, int? page});

  Future<List<TVShowModel>> fetchSimilarTvShows({int? id, int? page});

  Future<List<GenericMoviesModel>> fetchActorMovies({int? id, int? page});

  Future<List<GenericMoviesModel>> fetchMoviesByGenre({int? id, int? page});

  Future<List<SeasonModel>> fetchTvSeasons({int? id});

  Future fetchSearchResults({String? type, String? query, int? page});
}
