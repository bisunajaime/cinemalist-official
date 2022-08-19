import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../barrels/models.dart';
import '../../../repository/tmdb_repository.dart';

/*

EVENT

*/

abstract class NowShowingEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchNowShowingMovies extends NowShowingEvent {}

//STATES

abstract class NowShowingState extends Equatable {
  const NowShowingState();

  @override
  List<Object> get props => [];
}

class NowShowingInitial extends NowShowingState {}

class NowShowingFailed extends NowShowingState {}

class NowShowingSuccess extends NowShowingState {
  final List<GenericMoviesModel>? nowShowingMovies;
  final bool? hasReachedMax;

  const NowShowingSuccess({
    this.nowShowingMovies,
    this.hasReachedMax,
  });

  NowShowingSuccess copyWith({
    List<GenericMoviesModel>? nowShowingMovies,
    bool? hasReachedMax,
  }) {
    return NowShowingSuccess(
        nowShowingMovies: nowShowingMovies ?? this.nowShowingMovies,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  @override
  List<Object> get props => [nowShowingMovies!, hasReachedMax!];
  @override
  String toString() =>
      'NowShowingSuccess { nowShowingMovies: ${nowShowingMovies!.length}, hasReachedMax: $hasReachedMax }';
}

// BLOC

class NowShowingBloc extends Bloc<NowShowingEvent, NowShowingState> {
  final TMDBRepository? tmdbRepository;
  int page = 1;
  NowShowingBloc({this.tmdbRepository}) : super(NowShowingInitial());

  @override
  NowShowingState get initialState => NowShowingInitial();

  @override
  Stream<NowShowingState> mapEventToState(NowShowingEvent event) async* {
    final NowShowingState currentState = state;
    if (event is FetchNowShowingMovies && !_hasReachedMax(currentState)) {
      try {
        if (currentState is NowShowingInitial) {
          final movies = await tmdbRepository!.fetchNowPlaying(page: page);
          yield NowShowingSuccess(
              nowShowingMovies: movies, hasReachedMax: false);
          return;
        }

        if (currentState is NowShowingSuccess) {
          final movies = await tmdbRepository!.fetchNowPlaying(page: ++page);
          yield movies.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : NowShowingSuccess(
                  nowShowingMovies: currentState.nowShowingMovies! + movies,
                  hasReachedMax: false,
                );
        }
      } catch (_) {
        yield NowShowingFailed();
      }
    }
  }

  bool _hasReachedMax(NowShowingState state) =>
      state is NowShowingSuccess && state.hasReachedMax!;
}
