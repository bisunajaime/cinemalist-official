import 'package:cinemalist/barrels/models.dart';
import 'package:cinemalist/library/cubit.dart';

import '../../repository/tmdb_repository/tmdb_repository.dart';

class ActorMoviesCubit extends PagedTMDBCubit<GenericMoviesModel> {
  final TMDBRepository tmdbRepository;
  final int? id;
  ActorMoviesCubit(this.tmdbRepository, this.id) : super(tmdbRepository);

  @override
  String get name => 'ActorMoviesCubit';

  @override
  Future<List<GenericMoviesModel>?> loadFromServer() async {
    return await tmdbRepository.fetchActorMovies(id: id, page: 1);
  }

  @override
  Future<List<GenericMoviesModel>?> loadFromServerWithPage(int page) async {
    return tmdbRepository.fetchActorMovies(id: id, page: page);
  }
}
