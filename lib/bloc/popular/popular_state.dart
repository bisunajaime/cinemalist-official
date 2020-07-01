import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tmdbflutter/barrels/models.dart';

abstract class PopularState extends Equatable {
  const PopularState();
  @override
  List<Object> get props => [];
}

class PopularEmpty extends PopularState {}

class PopularLoading extends PopularState {}

class PopularLoaded extends PopularState {
  final List<PopularModel> popularMovies;

  const PopularLoaded({@required this.popularMovies})
      : assert(popularMovies != null);

  @override
  List<Object> get props => [popularMovies];
}

class PopularError extends PopularState {}
