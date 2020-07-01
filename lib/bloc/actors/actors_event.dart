import 'package:equatable/equatable.dart';

abstract class ActorsEvent extends Equatable {
  const ActorsEvent();
}

class FetchActors extends ActorsEvent {
  const FetchActors();
  @override
  List<Object> get props => [];
}
