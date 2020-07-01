import 'package:equatable/equatable.dart';

import '../../barrels/models.dart';
import 'package:meta/meta.dart';

abstract class ActorState extends Equatable {
  const ActorState();
  @override
  List<Object> get props => [];
}

class ActorEmpty extends ActorState {}

class ActorLoading extends ActorState {}

class ActorLoaded extends ActorState {
  final List<ActorsModel> actors;
  const ActorLoaded({@required this.actors}) : assert(actors != null);

  @override
  List<Object> get props => [actors];
}

class ActorError extends ActorState {}
