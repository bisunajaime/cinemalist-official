import 'package:equatable/equatable.dart';

abstract class PopularMoviesEvent extends Equatable {
  const PopularMoviesEvent();
}

class FetchPopularMovies extends PopularMoviesEvent {
  const FetchPopularMovies();
  @override
  List<Object> get props => [];
}
