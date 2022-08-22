import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tmdbflutter/library/cubit.dart';
import 'package:tmdbflutter/models/cast_model.dart';
import 'package:meta/meta.dart';
import 'package:tmdbflutter/repository/tmdb_repository/tmdb_repository.dart';

class MovieCastCubit extends TMDBCubit<List<CastModel>?> {
  final int? movieId;
  MovieCastCubit(TMDBRepository tmdbRepository, this.movieId)
      : super(tmdbRepository);

  @override
  Future<List<CastModel>?> loadFromServer() async {
    return await tmdbRepository.fetchMovieCasts(id: movieId);
  }

  @override
  String get name => 'MovieCastCubit';
}
