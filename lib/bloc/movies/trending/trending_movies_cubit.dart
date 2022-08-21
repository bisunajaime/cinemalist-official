import 'package:tmdbflutter/library/cubit.dart';
import 'package:tmdbflutter/models/generic_movies_model.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';

class TrendingMoviesCubit extends TMDBCubit<List<GenericMoviesModel>?> {
  TrendingMoviesCubit(TMDBRepository tmdbRepository) : super(tmdbRepository);

  @override
  Future<List<GenericMoviesModel>?> loadFromServer() async {
    return await tmdbRepository.fetchTrending();
  }

  @override
  String get name => 'TrendingMoviesCubit';
}
