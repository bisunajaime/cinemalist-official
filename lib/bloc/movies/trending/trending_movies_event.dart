import 'package:equatable/equatable.dart';

abstract class TrendingMoviesEvent extends Equatable {
  const TrendingMoviesEvent();
}

class FetchTrendingMovies extends TrendingMoviesEvent {
  const FetchTrendingMovies();
  @override
  List<Object> get props => [];
}
