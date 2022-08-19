import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tmdbflutter/barrels/upcoming_movies_barrel.dart';
import 'package:tmdbflutter/models/generic_movies_model.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';

class UpcomingMoviesBloc
    extends Bloc<UpcomingMoviesEvent, UpcomingMoviesState> {
  final TMDBRepository tmdbRepository;

  UpcomingMoviesBloc({required this.tmdbRepository})
      : assert(tmdbRepository != null);

  @override
  UpcomingMoviesState get initialState => UpcomingMoviesEmpty();

  @override
  Stream<UpcomingMoviesState> mapEventToState(
      UpcomingMoviesEvent event) async* {
    if (event is FetchUpcomingMovies) {
      yield UpcomingMoviesLoading();
      try {
        final List<GenericMoviesModel> upcoming =
            await tmdbRepository.fetchUpcoming();
        yield UpcomingMoviesLoaded(upcomingMovies: upcoming);
      } catch (e) {
        yield UpcomingMoviesError();
      }
    }
  }
}
