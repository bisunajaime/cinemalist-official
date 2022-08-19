import 'package:bloc/bloc.dart';
import 'package:tmdbflutter/barrels/upcoming_movies_barrel.dart';
import 'package:tmdbflutter/library/cubit.dart';
import 'package:tmdbflutter/models/generic_movies_model.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';

class UpcomingMoviesCubit extends TMDBCubit<List<GenericMoviesModel>?> {
  UpcomingMoviesCubit(TMDBRepository tmdbRepository) : super(tmdbRepository);

  @override
  Future<List<GenericMoviesModel>?> loadFromServer() async {
    return await tmdbRepository.fetchUpcoming();
  }
}
