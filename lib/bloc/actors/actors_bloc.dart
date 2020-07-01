import 'package:bloc/bloc.dart';
import 'package:tmdbflutter/bloc/actors/actors_event.dart';
import 'package:tmdbflutter/bloc/actors/actors_state.dart';
import 'package:meta/meta.dart';
import '../../barrels/models.dart';
import '../../repository/tmdb_repository.dart';

class ActorsBloc extends Bloc<ActorsEvent, ActorState> {
  final TMDBRepository tmdbRepository;

  ActorsBloc({@required this.tmdbRepository}) : assert(tmdbRepository != null);

  @override
  ActorState get initialState => ActorEmpty();

  @override
  Stream<ActorState> mapEventToState(ActorsEvent event) async* {
    if (event is FetchActors) {
      yield ActorLoading();
      try {
        final List<ActorsModel> actors = await tmdbRepository.fetchActors();
        yield ActorLoaded(actors: actors);
      } catch (_) {
        yield ActorError();
      }
    }
  }
}
