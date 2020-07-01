import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tmdbflutter/barrels/models.dart';

abstract class GenresState extends Equatable {
  const GenresState();
  @override
  List<Object> get props => [];
}

class GenresEmpty extends GenresState {}

class GenresLoading extends GenresState {}

class GenresLoaded extends GenresState {
  final List<GenresModel> genres;

  const GenresLoaded({@required this.genres}) : assert(genres != null);

  @override
  List<Object> get props => [genres];
}

class GenresError extends GenresState {}
