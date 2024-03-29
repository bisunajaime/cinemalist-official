import 'dart:convert';

import 'package:cinemalist/barrels/models.dart';
import 'package:cinemalist/library/cubit.dart';
import 'package:cinemalist/repository/tmdb_repository/tmdb_repository.dart';

class PopularMoviesCubit extends TMDBCubit<List<GenericMoviesModel>?> {
  PopularMoviesCubit(TMDBRepository tmdbRepository) : super(tmdbRepository);

  @override
  Future<List<GenericMoviesModel>?> loadFromServer() async {
    return await tmdbRepository.fetchPopular();
  }

  @override
  String get name => 'PopularMoviesCubit';

  @override
  String? get fileName => 'popular_movies.json';

  @override
  String? get toJson => jsonEncode(state?.map((e) => e.toJson()).toList());
}
