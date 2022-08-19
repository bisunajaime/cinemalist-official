import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../barrels/models.dart';
import '../../../repository/tmdb_repository.dart';

/*

EVENT

*/

abstract class MovieByGenreEvent extends Equatable {
  const MovieByGenreEvent();
}

class FetchMovieByGenreMovies extends MovieByGenreEvent {
  final int? id;
  const FetchMovieByGenreMovies({this.id});
  @override
  List<Object> get props => [id!];
}

//STATES

abstract class MovieByGenreState extends Equatable {
  const MovieByGenreState();

  @override
  List<Object> get props => [];
}

class MovieByGenreInitial extends MovieByGenreState {}

class MovieByGenreFailed extends MovieByGenreState {}

class MovieByGenreSuccess extends MovieByGenreState {
  final List<GenericMoviesModel>? movieByGenreMovies;
  final bool? hasReachedMax;

  const MovieByGenreSuccess({
    this.movieByGenreMovies,
    this.hasReachedMax,
  });

  MovieByGenreSuccess copyWith({
    List<GenericMoviesModel>? movieByGenreMovies,
    bool? hasReachedMax,
  }) {
    return MovieByGenreSuccess(
        movieByGenreMovies: movieByGenreMovies ?? this.movieByGenreMovies,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  @override
  List<Object> get props => [movieByGenreMovies!, hasReachedMax!];
  @override
  String toString() =>
      'MovieByGenreSuccess { MovieByGenreMovies: ${movieByGenreMovies!.length}, hasReachedMax: $hasReachedMax }';
}

// BLOC

class MovieByGenreBloc extends Bloc<MovieByGenreEvent, MovieByGenreState> {
  final TMDBRepository? tmdbRepository;
  int page = 1;
  MovieByGenreBloc({this.tmdbRepository});

  @override
  MovieByGenreState get initialState => MovieByGenreInitial();

  @override
  Stream<MovieByGenreState> mapEventToState(MovieByGenreEvent event) async* {
    final MovieByGenreState currentState = state;
    if (event is FetchMovieByGenreMovies && !_hasReachedMax(currentState)) {
      try {
        if (currentState is MovieByGenreInitial) {
          final movies =
              await tmdbRepository!.fetchMoviesByGenre(page: page, id: event.id);
          yield MovieByGenreSuccess(
              movieByGenreMovies: movies, hasReachedMax: false);
          return;
        }

        if (currentState is MovieByGenreSuccess) {
          final movies = await tmdbRepository!.fetchMoviesByGenre(
              page: ++page, id: event.id);
          yield movies.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : MovieByGenreSuccess(
                  movieByGenreMovies: currentState.movieByGenreMovies! + movies,
                  hasReachedMax: false,
                );
        }
      } catch (_) {
        yield MovieByGenreFailed();
      }
    }
  }

  bool _hasReachedMax(MovieByGenreState state) =>
      state is MovieByGenreSuccess && state.hasReachedMax!;
}
