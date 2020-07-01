import 'package:equatable/equatable.dart';

abstract class GenreEvent extends Equatable {
  const GenreEvent();
}

class FetchGenres extends GenreEvent {
  const FetchGenres();

  @override
  List<Object> get props => [];
}
