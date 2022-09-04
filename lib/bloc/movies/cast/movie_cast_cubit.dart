import 'package:tmdbflutter/library/cubit.dart';
import 'package:tmdbflutter/models/actor_info_model.dart';
import 'package:tmdbflutter/repository/tmdb_repository/tmdb_repository.dart';

class MovieCastCubit extends TMDBCubit<List<ActorInfoModel>?> {
  final int? movieId;
  MovieCastCubit(TMDBRepository tmdbRepository, this.movieId)
      : super(tmdbRepository);

  @override
  Future<List<ActorInfoModel>?> loadFromServer() async {
    return await tmdbRepository.fetchMovieCasts(id: movieId);
  }

  @override
  String get name => 'MovieCastCubit';
}
