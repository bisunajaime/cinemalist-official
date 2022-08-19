import 'package:equatable/equatable.dart';

abstract class MovieInfoEvent extends Equatable {
  const MovieInfoEvent();
}

class FetchMovieInfo extends MovieInfoEvent {
  final int? id;
  const FetchMovieInfo({
    this.id,
  });
  @override
  List<Object> get props => [id!];
}
