import 'package:equatable/equatable.dart';

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();
}

class FetchPopularMovies extends MoviesEvent {
  const FetchPopularMovies();
  @override
  List<Object> get props => [];
}

class FetchTrendingMovies extends MoviesEvent {
  const FetchTrendingMovies();
  @override
  List<Object> get props => [];
}

class FetchUpcomingMovies extends MoviesEvent {
  const FetchUpcomingMovies();
  @override
  List<Object> get props => [];
}
