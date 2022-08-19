/*

  STATE

 */

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tmdbflutter/models/cast_model.dart';
import 'package:meta/meta.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';

abstract class MovieCastState extends Equatable {
  const MovieCastState();
  @override
  List<Object> get props => [];
}

class MovieCastEmpty extends MovieCastState {}

class MovieCastLoading extends MovieCastState {}

class MovieCastError extends MovieCastState {}

class MovieCastMax extends MovieCastState {}

class MovieCastLoadingNextPage extends MovieCastState {}

class MovieCastLoaded extends MovieCastState {
  final List<CastModel> movieCast;
  MovieCastLoaded({
    required this.movieCast,
  }) : assert(movieCast != null);

  @override
  List<Object> get props => [movieCast];
}

/*

  EVENT

 */

abstract class MovieCastEvent extends Equatable {
  const MovieCastEvent();
}

class FetchMovieCast extends MovieCastEvent {
  final int? id;
  const FetchMovieCast({
    this.id,
  });
  @override
  List<Object> get props => [id!];
}

/*

  BLOC

 */

class MovieCastBloc extends Bloc<MovieCastEvent, MovieCastState> {
  final TMDBRepository tmdbRepository;

  MovieCastBloc({required this.tmdbRepository})
      : assert(tmdbRepository != null);

  @override
  MovieCastState get initialState => MovieCastEmpty();

  @override
  Stream<MovieCastState> mapEventToState(MovieCastEvent event) async* {
    if (event is FetchMovieCast) {
      yield MovieCastLoading();
      try {
        List<CastModel> movieCasts =
            await tmdbRepository.fetchMovieCasts(id: event.id);
        yield MovieCastLoaded(movieCast: movieCasts);
      } catch (e) {
        print(e);
        yield MovieCastError();
      }
    }
  }
}
