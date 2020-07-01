import 'package:equatable/equatable.dart';

abstract class UpcomingEvent extends Equatable {
  const UpcomingEvent();
}

class FetchUpcomingMovies extends UpcomingEvent {
  const FetchUpcomingMovies();

  @override
  // TODO: implement props
  List<Object> get props => [];
}
