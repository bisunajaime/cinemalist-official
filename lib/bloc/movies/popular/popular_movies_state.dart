import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tmdbflutter/barrels/models.dart';

abstract class PopularMoviesState extends Equatable {
  const PopularMoviesState();
  @override
  List<Object> get props => [];
}

class PopularMoviesEmpty extends PopularMoviesState {}

class PopularMoviesLoading extends PopularMoviesState {}

class PopularMoviesError extends PopularMoviesState {}

class PopularMoviesLoaded extends PopularMoviesState {
  final List<GenericMoviesModel> popularMovies;
  const PopularMoviesLoaded({@required this.popularMovies})
      : assert(popularMovies != null);

  @override
  List<Object> get props => [popularMovies];
}
