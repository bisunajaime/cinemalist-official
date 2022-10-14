import 'package:cinemalist/library/cubit.dart';

import '../../../barrels/models.dart';
import '../../../repository/tmdb_repository/tmdb_repository.dart';

class SimilarMoviesCubit extends PagedTMDBCubit<GenericMoviesModel> {
  final int? movieId;
  SimilarMoviesCubit(TMDBRepository tmdbRepository, this.movieId)
      : super(tmdbRepository);

  @override
  String get name => 'SimilarMoviesCubit';

  @override
  Future<List<GenericMoviesModel>?> loadFromServer() async {
    return await tmdbRepository.fetchSimilarMovies(id: movieId, page: 1);
  }

  @override
  Future<List<GenericMoviesModel>?> loadFromServerWithPage(int page) async {
    return await tmdbRepository.fetchSimilarMovies(id: movieId, page: page);
  }
}
