import 'package:equatable/equatable.dart';

abstract class PopularEvent extends Equatable {
  const PopularEvent();
}

class FetchPopularMovies extends PopularEvent {
  const FetchPopularMovies();

  @override
  List<Object> get props => [];
}
