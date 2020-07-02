import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/bloc/movies/movies_event.dart';
import 'package:tmdbflutter/bloc/movies/movies_state.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final TMDBRepository tmdbRepository;

  MoviesBloc({@required this.tmdbRepository}) : assert(tmdbRepository != null);

  @override
  MoviesState get initialState => MoviesEmpty();

  @override
  Stream<MoviesState> mapEventToState(MoviesEvent event) async* {
    if (event is FetchPopularMovies) {
      yield MoviesLoading();
      try {
        final List<GenericMoviesModel> popular =
            await tmdbRepository.fetchPopular();
        yield MoviesLoaded(movies: popular);
      } catch (e) {
        yield MoviesError();
      }
    } else if (event is FetchTrendingMovies) {
      yield MoviesLoading();
      try {
        final List<GenericMoviesModel> trending =
            await tmdbRepository.fetchTrending();
        yield MoviesLoaded(movies: trending);
      } catch (e) {
        yield MoviesError();
      }
    } else if (event is FetchUpcomingMovies) {
      yield MoviesLoading();
      try {
        final List<GenericMoviesModel> upcoming =
            await tmdbRepository.fetchUpcoming();
        yield MoviesLoaded(movies: upcoming);
      } catch (e) {
        yield MoviesError();
      }
    }
  }
}
