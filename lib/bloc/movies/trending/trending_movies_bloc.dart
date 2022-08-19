import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tmdbflutter/barrels/trending_movies_barrel.dart';
import 'package:tmdbflutter/models/generic_movies_model.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';

class TrendingMoviesBloc
    extends Bloc<TrendingMoviesEvent, TrendingMoviesState> {
  final TMDBRepository tmdbRepository;

  TrendingMoviesBloc({required this.tmdbRepository})
      : assert(tmdbRepository != null);

  @override
  TrendingMoviesState get initialState => TrendingMoviesEmpty();

  @override
  Stream<TrendingMoviesState> mapEventToState(
      TrendingMoviesEvent event) async* {
    if (event is FetchTrendingMovies) {
      yield TrendingMoviesLoading();
      try {
        final List<GenericMoviesModel> trending =
            await tmdbRepository.fetchTrending();
        yield TrendingMoviesLoaded(trendingMovies: trending);
      } catch (e) {
        yield TrendingMoviesError();
      }
    }
  }
}
