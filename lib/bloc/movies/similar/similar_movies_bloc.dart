import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../barrels/models.dart';
import '../../../repository/tmdb_repository.dart';

/*

EVENT

*/

abstract class SimilarMoviesEvent extends Equatable {
  const SimilarMoviesEvent();
}

class FetchSimilarMoviesMovies extends SimilarMoviesEvent {
  final int id;
  const FetchSimilarMoviesMovies({this.id});
  @override
  List<Object> get props => [id];
}

//STATES

abstract class SimilarMoviesState extends Equatable {
  const SimilarMoviesState();

  @override
  List<Object> get props => [];
}

class SimilarMoviesEmpty extends SimilarMoviesState {}

class SimilarMoviesLoading extends SimilarMoviesState {}

class SimilarMoviesError extends SimilarMoviesState {}

class SimilarMoviesLoaded extends SimilarMoviesState {
  final List<GenericMoviesModel> similarMoviesMovies;

  const SimilarMoviesLoaded({
    this.similarMoviesMovies,
  });
  @override
  List<Object> get props => [similarMoviesMovies];
  @override
  String toString() =>
      'SimilarMoviesSuccess { SimilarMoviesMovies: ${similarMoviesMovies.length} }';
}

// BLOC

class SimilarMoviesBloc extends Bloc<SimilarMoviesEvent, SimilarMoviesState> {
  final TMDBRepository tmdbRepository;
  SimilarMoviesBloc({this.tmdbRepository});

  @override
  SimilarMoviesState get initialState => SimilarMoviesEmpty();

  @override
  Stream<SimilarMoviesState> mapEventToState(SimilarMoviesEvent event) async* {
    if (event is FetchSimilarMoviesMovies) {
      yield SimilarMoviesLoading();
      try {
        final List<GenericMoviesModel> similar =
            await tmdbRepository.fetchSimilarMovies(id: event.id);
        yield SimilarMoviesLoaded(similarMoviesMovies: similar);
      } catch (e) {
        yield SimilarMoviesError();
      }
    }
  }
}
