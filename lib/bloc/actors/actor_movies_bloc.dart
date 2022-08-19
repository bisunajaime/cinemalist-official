import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tmdbflutter/barrels/models.dart';
import 'package:meta/meta.dart';

import '../../repository/tmdb_repository.dart';

abstract class ActorMoviesState extends Equatable {
  const ActorMoviesState();
  @override
  List<Object> get props => [];
}

class ActorMoviesEmpty extends ActorMoviesState {}

class ActorMoviesLoading extends ActorMoviesState {}

class ActorMoviesError extends ActorMoviesState {}

class ActorMoviesMax extends ActorMoviesState {}

class ActorMoviesLoadingNextPage extends ActorMoviesState {}

class ActorMoviesLoaded extends ActorMoviesState {
  final List<GenericMoviesModel> actorMovies;
  ActorMoviesLoaded({
    required this.actorMovies,
  }) : assert(actorMovies != null);

  @override
  List<Object> get props => [actorMovies];
}

/*

  EVENT

 */

abstract class ActorMoviesEvent extends Equatable {
  const ActorMoviesEvent();
}

class FetchActorMovies extends ActorMoviesEvent {
  final int? id;
  const FetchActorMovies({
    this.id,
  });
  @override
  List<Object> get props => [id!];
}

/*

  BLOC

 */

class ActorMoviesBloc extends Bloc<ActorMoviesEvent, ActorMoviesState> {
  final TMDBRepository tmdbRepository;

  ActorMoviesBloc({required this.tmdbRepository})
      : assert(tmdbRepository != null),
        super(ActorMoviesLoading());

  @override
  ActorMoviesState get initialState => ActorMoviesEmpty();

  @override
  Stream<ActorMoviesState> mapEventToState(ActorMoviesEvent event) async* {
    if (event is FetchActorMovies) {
      yield ActorMoviesLoading();
      try {
        List<GenericMoviesModel> actorMovies =
            await tmdbRepository.fetchActorMovies(id: event.id);
        yield ActorMoviesLoaded(actorMovies: actorMovies);
      } catch (e) {
        print(e);
        yield ActorMoviesError();
      }
    }
  }
}
