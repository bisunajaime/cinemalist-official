import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tmdbflutter/barrels/models.dart';

abstract class UpcomingState extends Equatable {
  const UpcomingState();
  @override
  List<Object> get props => [];
}

class UpcomingEmpty extends UpcomingState {}

class UpcomingLoading extends UpcomingState {}

class UpcomingLoaded extends UpcomingState {
  final List<UpcomingModel> upcomingMovies;

  const UpcomingLoaded({@required this.upcomingMovies})
      : assert(upcomingMovies != null);

  @override
  List<Object> get props => [upcomingMovies];
}

class UpcomingError extends UpcomingState {}
