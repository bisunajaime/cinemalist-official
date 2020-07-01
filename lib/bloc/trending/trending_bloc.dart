import 'package:bloc/bloc.dart';
import 'package:tmdbflutter/bloc/trending/trending_event.dart';
import 'package:tmdbflutter/bloc/trending/trending_state.dart';

import '../../barrels/models.dart';
import '../../repository/tmdb_repository.dart';
import 'package:meta/meta.dart';

class TrendingBloc extends Bloc<TrendingEvent, TrendingState> {
  final TMDBRepository tmdbRepository;
  TrendingBloc({@required this.tmdbRepository})
      : assert(tmdbRepository != null);

  @override
  TrendingState get initialState => TrendingEmpty();

  @override
  Stream<TrendingState> mapEventToState(TrendingEvent event) async* {
    if (event is FetchTrendingMovies) {
      yield TrendingLoading();
      try {
        final List<TrendingModel> trendingMovies =
            await tmdbRepository.fetchTrending();
        yield TrendingLoaded(trendingMovies: trendingMovies);
      } catch (e) {
        yield TrendingError();
      }
    }
  }
}
