import 'package:meta/meta.dart';
import 'package:tmdbflutter/repository/tmdb_api_client.dart';
import 'package:tmdbflutter/barrels/models.dart';

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

  Future<List<GenericMoviesModel>> fetchNowPlaying() async {
    return await tmdbApiClient.fetchNowPlaying();
  }
}
