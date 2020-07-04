import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/models/movie_info_model.dart';

abstract class MovieInfoState extends Equatable {
  const MovieInfoState();
  @override
  List<Object> get props => [];
}

class MovieInfoEmpty extends MovieInfoState {}

class MovieInfoLoading extends MovieInfoState {}

class MovieInfoError extends MovieInfoState {}

class MovieInfoMax extends MovieInfoState {}

class MovieInfoLoadingNextPage extends MovieInfoState {}

class SearchMovieInfo extends MovieInfoState {}

class MovieInfoLoaded extends MovieInfoState {
  final MovieInfoModel movieInfo;
  MovieInfoLoaded({
    @required this.movieInfo,
  }) : assert(movieInfo != null);

  @override
  List<Object> get props => [movieInfo];
}
