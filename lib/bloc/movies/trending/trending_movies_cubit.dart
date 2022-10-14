import 'dart:convert';

import 'package:cinemalist/library/cubit.dart';
import 'package:cinemalist/models/generic_movies_model.dart';
import 'package:cinemalist/repository/tmdb_repository/tmdb_repository.dart';

class TrendingMoviesCubit extends TMDBCubit<List<GenericMoviesModel>?> {
  TrendingMoviesCubit(TMDBRepository tmdbRepository) : super(tmdbRepository);

  @override
  Future<List<GenericMoviesModel>?> loadFromServer() async {
    return await tmdbRepository.fetchTrending();
  }

  @override
  String get name => 'TrendingMoviesCubit';

  @override
  String? get fileName => 'trending_movies.json';

  @override
  String? get toJson => jsonEncode(state?.map((e) => e.toJson()).toList());
}
