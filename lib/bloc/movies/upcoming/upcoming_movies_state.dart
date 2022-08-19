import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tmdbflutter/barrels/models.dart';

abstract class UpcomingMoviesState extends Equatable {
  const UpcomingMoviesState();
  @override
  List<Object> get props => [];
}

class UpcomingMoviesEmpty extends UpcomingMoviesState {}

class UpcomingMoviesLoading extends UpcomingMoviesState {}

class UpcomingMoviesError extends UpcomingMoviesState {}

class UpcomingMoviesLoaded extends UpcomingMoviesState {
  final List<GenericMoviesModel> upcomingMovies;
  const UpcomingMoviesLoaded({required this.upcomingMovies})
      : assert(upcomingMovies != null);

  @override
  List<Object> get props => [upcomingMovies];
}
