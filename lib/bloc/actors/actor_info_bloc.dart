import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tmdbflutter/models/actor_info_model.dart';
import 'package:meta/meta.dart';

import '../../repository/tmdb_repository.dart';

abstract class ActorInfoState extends Equatable {
  const ActorInfoState();
  @override
  List<Object> get props => [];
}

class ActorInfoEmpty extends ActorInfoState {}

class ActorInfoLoading extends ActorInfoState {}

class ActorInfoError extends ActorInfoState {}

class ActorInfoMax extends ActorInfoState {}

class ActorInfoLoadingNextPage extends ActorInfoState {}

class ActorInfoLoaded extends ActorInfoState {
  final ActorInfoModel actorInfo;
  ActorInfoLoaded({
    @required this.actorInfo,
  }) : assert(actorInfo != null);

  @override
  List<Object> get props => [actorInfo];
}

/*

  EVENT

 */

abstract class ActorInfoEvent extends Equatable {
  const ActorInfoEvent();
}

class FetchActorInfo extends ActorInfoEvent {
  final int id;
  const FetchActorInfo({
    this.id,
  });
  @override
  List<Object> get props => [id];
}

/*

  BLOC

 */

class ActorInfoBloc extends Bloc<ActorInfoEvent, ActorInfoState> {
  final TMDBRepository tmdbRepository;

  ActorInfoBloc({@required this.tmdbRepository})
      : assert(tmdbRepository != null);

  @override
  ActorInfoState get initialState => ActorInfoEmpty();

  @override
  Stream<ActorInfoState> mapEventToState(ActorInfoEvent event) async* {
    if (event is FetchActorInfo) {
      yield ActorInfoLoading();
      try {
        ActorInfoModel actorInfo =
            await tmdbRepository.fetchActorInfo(id: event.id);
        yield ActorInfoLoaded(actorInfo: actorInfo);
      } catch (e) {
        print(e);
        yield ActorInfoError();
      }
    }
  }
}
