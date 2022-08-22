import 'dart:convert';

import 'package:tmdbflutter/library/cubit.dart';
import 'package:tmdbflutter/models/generic_movies_model.dart';
import 'package:tmdbflutter/repository/tmdb_repository/tmdb_repository.dart';

class UpcomingMoviesCubit extends TMDBCubit<List<GenericMoviesModel>?> {
  UpcomingMoviesCubit(TMDBRepository tmdbRepository) : super(tmdbRepository);

  @override
  Future<List<GenericMoviesModel>?> loadFromServer() async {
    return await tmdbRepository.fetchUpcoming();
  }

  @override
  String get name => 'UpcomingMoviesCubit';

  @override
  String? get fileName => 'upcoming_movies.json';

  @override
  String? get toJson => jsonEncode(state?.map((e) => e.toJson()).toList());
}
