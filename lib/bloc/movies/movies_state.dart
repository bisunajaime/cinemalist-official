import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tmdbflutter/barrels/models.dart';

abstract class MoviesState extends Equatable {
  const MoviesState();
  @override
  List<Object> get props => [];
}

class MoviesEmpty extends MoviesState {}

class MoviesLoading extends MoviesState {}

class MoviesError extends MoviesState {}

class MoviesLoaded extends MoviesState {
  final List<GenericMoviesModel> movies;
  const MoviesLoaded({@required this.movies}) : assert(movies != null);

  @override
  List<Object> get props => [movies];
}
