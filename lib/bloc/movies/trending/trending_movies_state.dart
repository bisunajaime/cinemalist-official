import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tmdbflutter/barrels/models.dart';

abstract class TrendingMoviesState extends Equatable {
  const TrendingMoviesState();
  @override
  List<Object> get props => [];
}

class TrendingMoviesEmpty extends TrendingMoviesState {}

class TrendingMoviesLoading extends TrendingMoviesState {}

class TrendingMoviesError extends TrendingMoviesState {}

class TrendingMoviesLoaded extends TrendingMoviesState {
  final List<GenericMoviesModel> trendingMovies;
  const TrendingMoviesLoaded({@required this.trendingMovies})
      : assert(trendingMovies != null);

  @override
  List<Object> get props => [trendingMovies];
}
