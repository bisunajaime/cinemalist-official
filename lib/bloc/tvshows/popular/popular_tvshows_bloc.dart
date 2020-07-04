import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:tmdbflutter/bloc/tvshows/popular/popular_tvshows_event.dart';
import 'package:tmdbflutter/bloc/tvshows/popular/popular_tvshows_state.dart';
import 'package:tmdbflutter/models/tvshow_model.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';

class PopularTvShowsBloc
    extends Bloc<PopularTvShowsEvent, PopularTvShowsState> {
  final TMDBRepository tmdbRepository;
  int initialPage = 1;
  List<TVShowModel> popularTvShows = [];
  List<TVShowModel> nextPage = [];

  PopularTvShowsBloc({@required this.tmdbRepository})
      : assert(tmdbRepository != null);

  @override
  PopularTvShowsState get initialState => PopularTvShowsEmpty();

  @override
  Stream<PopularTvShowsState> mapEventToState(
      PopularTvShowsEvent event) async* {
    if (event is FetchPopularTvShows) {
      yield PopularTvShowsLoading();
      try {
        popularTvShows.clear();
        nextPage.clear();
        initialPage = 1;
        popularTvShows.addAll(
            await tmdbRepository.fetchPopularTvShows(page: initialPage));
        print(initialPage);
        print(popularTvShows.length);
        yield PopularTvShowsLoaded(popularTvShows: popularTvShows);
      } catch (e) {
        print(e);
        yield PopularTvShowsError();
      }
    }
    if (event is LoadNextPage) {
      try {
        initialPage += 1;
        nextPage = await tmdbRepository.fetchPopularTvShows(page: initialPage);
        nextPage.removeAt(0);
        popularTvShows.addAll(nextPage);
        print(initialPage);
        print(popularTvShows.length);
        popularTvShows.removeWhere((element) => element.posterPath == null);
        List removeDups = popularTvShows.toSet().toList();
        yield PopularTvShowsLoaded(popularTvShows: removeDups);
      } catch (e) {
        print(initialPage);
        print(e);
      }
    }
  }
}
