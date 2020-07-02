import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/bloc/movies/popular/popular_movies_event.dart';
import 'package:tmdbflutter/bloc/movies/popular/popular_movies_state.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final TMDBRepository tmdbRepository;

  PopularMoviesBloc({@required this.tmdbRepository})
      : assert(tmdbRepository != null);

  @override
  PopularMoviesState get initialState => PopularMoviesEmpty();

  @override
  Stream<PopularMoviesState> mapEventToState(PopularMoviesEvent event) async* {
    if (event is FetchPopularMovies) {
      yield PopularMoviesLoading();
      try {
        final List<GenericMoviesModel> popular =
            await tmdbRepository.fetchPopular();
        yield PopularMoviesLoaded(popularMovies: popular);
      } catch (e) {
        yield PopularMoviesError();
      }
    }
  }
}
