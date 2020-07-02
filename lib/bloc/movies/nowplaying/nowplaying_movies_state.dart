import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tmdbflutter/barrels/models.dart';

abstract class NowPlayingMoviesState extends Equatable {
  const NowPlayingMoviesState();
  @override
  List<Object> get props => [];
}

class NowPlayingMoviesEmpty extends NowPlayingMoviesState {}

class NowPlayingMoviesLoading extends NowPlayingMoviesState {}

class NowPlayingMoviesError extends NowPlayingMoviesState {}

class NowPlayingMoviesLoaded extends NowPlayingMoviesState {
  final List<GenericMoviesModel> nowPlayingMovies;
  const NowPlayingMoviesLoaded({@required this.nowPlayingMovies})
      : assert(nowPlayingMovies != null);

  @override
  List<Object> get props => [nowPlayingMovies];
}
