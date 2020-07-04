/*

  STATE

 */

import 'package:equatable/equatable.dart';

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
  final List<GenericMoviesModel> MovieCast;
  MovieCastLoaded({
    @required this.MovieCast,
  }) : assert(MovieCast != null);

  @override
  List<Object> get props => [MovieCast];
}

/*

  EVENT

 */

/*

  BLOC

 */
