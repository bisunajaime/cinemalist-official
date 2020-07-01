import 'package:meta/meta.dart';
import 'package:tmdbflutter/repository/tmdb_api_client.dart';
import 'package:tmdbflutter/barrels/models.dart';

class TMDBRepository {
  final TMDBApiClient tmdbApiClient;

  TMDBRepository({@required this.tmdbApiClient})
      : assert(tmdbApiClient != null);

  Future<List<GenresModel>> fetchCategories() async {
    return await tmdbApiClient.fetchCategories();
  }

  Future<List<PopularModel>> fetchPopular() async {
    return await tmdbApiClient.fetchPopular();
  }

  Future<List<UpcomingModel>> fetchUpcoming() async {
    return await tmdbApiClient.fetchUpcoming();
  }
}
