import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/bloc/movies/nowplaying/nowplaying_movies_event.dart';
import 'package:tmdbflutter/bloc/movies/nowplaying/nowplaying_movies_state.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';

class NowPlayingMoviesBloc
    extends Bloc<NowPlayingMoviesEvent, NowPlayingMoviesState> {
  final TMDBRepository tmdbRepository;

  NowPlayingMoviesBloc({@required this.tmdbRepository})
      : assert(tmdbRepository != null);

  @override
  NowPlayingMoviesState get initialState => NowPlayingMoviesEmpty();

  @override
  Stream<NowPlayingMoviesState> mapEventToState(
      NowPlayingMoviesEvent event) async* {
    if (event is FetchNowPlayingMovies) {
      yield NowPlayingMoviesLoading();
      try {
        final List<GenericMoviesModel> nowPlaying =
            await tmdbRepository.fetchNowPlaying();
        yield NowPlayingMoviesLoaded(nowPlayingMovies: nowPlaying);
      } catch (e) {
        yield NowPlayingMoviesError();
      }
    }
  }
}
