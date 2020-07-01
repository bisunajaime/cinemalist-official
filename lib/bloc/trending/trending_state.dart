import 'package:equatable/equatable.dart';

import '../../barrels/models.dart';
import 'package:meta/meta.dart';

abstract class TrendingState extends Equatable {
  const TrendingState();
  @override
  List<Object> get props => [];
}

class TrendingEmpty extends TrendingState {}

class TrendingLoading extends TrendingState {}

class TrendingLoaded extends TrendingState {
  final List<TrendingModel> trendingMovies;

  const TrendingLoaded({@required this.trendingMovies})
      : assert(trendingMovies != null);

  @override
  List<Object> get props => [trendingMovies];
}

class TrendingError extends TrendingState {}
