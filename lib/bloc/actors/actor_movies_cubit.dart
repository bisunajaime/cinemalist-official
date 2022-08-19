import 'package:equatable/equatable.dart';
import 'package:tmdbflutter/barrels/models.dart';
import 'package:meta/meta.dart';
import 'package:tmdbflutter/library/cubit.dart';

import '../../repository/tmdb_repository.dart';

class ActorMoviesCubit extends Cubit<List<GenericMoviesModel>?> {
  final TMDBRepository tmdbRepository;
  final int? id;
  ActorMoviesCubit(this.tmdbRepository, this.id) : super(null);

  @override
  Future<List<GenericMoviesModel>?> loadFromServer() {
    return tmdbRepository.fetchActorMovies(id: id);
  }
}
