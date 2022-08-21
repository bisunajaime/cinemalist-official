import 'package:tmdbflutter/library/cubit.dart';
import 'package:tmdbflutter/models/movieinfo/MovieInfo.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';

class MovieInfoCubit extends TMDBCubit<MovieInfo?> {
  final int? movieId;
  MovieInfoCubit(TMDBRepository tmdbRepository, this.movieId)
      : super(tmdbRepository);

  @override
  Future<MovieInfo?> loadFromServer() async {
    return await tmdbRepository.fetchMovieInfo(id: movieId);
  }

  @override
  String get name => 'MovieInfoCubit';
}
