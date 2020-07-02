import 'package:equatable/equatable.dart';

abstract class UpcomingMoviesEvent extends Equatable {
  const UpcomingMoviesEvent();
}

class FetchUpcomingMovies extends UpcomingMoviesEvent {
  const FetchUpcomingMovies();
  @override
  List<Object> get props => [];
}
