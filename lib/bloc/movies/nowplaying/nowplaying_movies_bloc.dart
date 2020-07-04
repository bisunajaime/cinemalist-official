import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/bloc/movies/nowplaying/nowplaying_movies_event.dart';
import 'package:tmdbflutter/bloc/movies/nowplaying/nowplaying_movies_state.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';

class NowPlayingMoviesBloc
    extends Bloc<NowPlayingMoviesEvent, NowPlayingMoviesState> {
  final TMDBRepository tmdbRepository;
  int initialPage = 1;
  List<GenericMoviesModel> nowPlaying = [];
  List<GenericMoviesModel> nextPage = [];

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
        nowPlaying.clear();
        nextPage.clear();
        initialPage = 1;
        nowPlaying
            .addAll(await tmdbRepository.fetchNowPlaying(page: initialPage));
        print(initialPage);
        print(nowPlaying.length);
        yield NowPlayingMoviesLoaded(nowPlayingMovies: nowPlaying);
      } catch (e) {
        yield NowPlayingMoviesError();
      }
    }
    if (event is LoadNextPage) {
      try {
        nextPage = await tmdbRepository.fetchNowPlaying(page: initialPage++);
        nextPage.removeAt(0);
        nowPlaying.addAll(nextPage);
        print(initialPage);
        print(nowPlaying.length);
        nowPlaying.removeWhere((element) => element.posterPath == null);
        List removeDups = nowPlaying.toSet().toList();
        yield NowPlayingMoviesLoaded(nowPlayingMovies: removeDups);
      } catch (e) {
        print(initialPage);
        print(e);
      }
    }
  }
}
