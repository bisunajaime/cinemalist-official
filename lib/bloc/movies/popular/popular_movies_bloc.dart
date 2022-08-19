import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/library/cubit.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';

class PopularMoviesCubit extends TMDBCubit<List<GenericMoviesModel>?> {
  PopularMoviesCubit(TMDBRepository tmdbRepository) : super(tmdbRepository);

  @override
  Future<List<GenericMoviesModel>?> loadFromServer() async {
    return await tmdbRepository.fetchPopular();
  }
}
