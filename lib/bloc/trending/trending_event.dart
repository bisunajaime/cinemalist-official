import 'package:equatable/equatable.dart';

abstract class TrendingEvent extends Equatable {
  const TrendingEvent();
}

class FetchTrendingMovies extends TrendingEvent {
  const FetchTrendingMovies();
  @override
  List<Object> get props => [];
}
