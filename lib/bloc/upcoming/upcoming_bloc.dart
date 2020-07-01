import 'package:bloc/bloc.dart';
import 'package:tmdbflutter/barrels/upcoming_barrel.dart';
import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';
import 'package:meta/meta.dart';

class UpcomingsBloc extends Bloc<UpcomingEvent, UpcomingState> {
  final TMDBRepository tmdbRepository;

  UpcomingsBloc({@required this.tmdbRepository})
      : assert(tmdbRepository != null);

  @override
  UpcomingState get initialState => UpcomingEmpty();

  @override
  Stream<UpcomingState> mapEventToState(UpcomingEvent event) async* {
    if (event is FetchUpcomingMovies) {
      yield UpcomingLoading();
      try {
        final List<UpcomingModel> upcomingMovies =
            await tmdbRepository.fetchUpcoming();
        yield UpcomingLoaded(upcomingMovies: upcomingMovies);
      } catch (e) {
        yield UpcomingError();
      }
    }
  }
}
