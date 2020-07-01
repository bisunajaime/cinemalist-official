import 'package:bloc/bloc.dart';
import 'package:tmdbflutter/barrels/popular_barrel.dart';
import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';
import 'package:meta/meta.dart';

class PopularsBloc extends Bloc<PopularEvent, PopularState> {
  final TMDBRepository tmdbRepository;

  PopularsBloc({@required this.tmdbRepository})
      : assert(tmdbRepository != null);

  @override
  PopularState get initialState => PopularEmpty();

  @override
  Stream<PopularState> mapEventToState(PopularEvent event) async* {
    if (event is FetchPopularMovies) {
      yield PopularLoading();
      try {
        final List<PopularModel> popularMovies =
            await tmdbRepository.fetchPopular();
        yield PopularLoaded(popularMovies: popularMovies);
      } catch (e) {
        yield PopularError();
      }
    }
  }
}
