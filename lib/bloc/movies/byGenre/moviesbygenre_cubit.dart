import 'package:tmdbflutter/library/cubit.dart';

import '../../../barrels/models.dart';
import '../../../repository/tmdb_repository/tmdb_repository.dart';

class MoviesByGenreCubit extends PagedTMDBCubit<GenericMoviesModel?> {
  final int genreId;

  MoviesByGenreCubit(TMDBRepository tmdbRepository, this.genreId)
      : super(tmdbRepository);

  @override
  Future<List<GenericMoviesModel?>?> loadFromServer() async {
    return await tmdbRepository.fetchMoviesByGenre(page: 1, id: genreId);
  }

  @override
  Future<List<GenericMoviesModel?>?> loadFromServerWithPage(int page) async {
    return await tmdbRepository.fetchMoviesByGenre(page: page, id: genreId);
  }

  @override
  String get name => 'MoviesByGenreCubit';
}
