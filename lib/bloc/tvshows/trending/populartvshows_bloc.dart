// EVENTS

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/tvshow_model.dart';
import '../../../repository/tmdb_repository.dart';

abstract class PopularTvShowsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchPopularTvShows extends PopularTvShowsEvent {}

// STATES

abstract class PopularTvShowsState extends Equatable {
  const PopularTvShowsState();

  @override
  List<Object> get props => [];
}

class PopularTvShowsInitial extends PopularTvShowsState {}

class PopularTvShowsFailed extends PopularTvShowsState {}

class PopularTvShowsSuccess extends PopularTvShowsState {
  final List<TVShowModel> tvShowModel;
  final bool hasReachedMax;

  const PopularTvShowsSuccess({
    this.tvShowModel,
    this.hasReachedMax,
  });

  PopularTvShowsSuccess copyWith({
    List<TVShowModel> tvShowModel,
    bool hasReachedMax,
  }) {
    return PopularTvShowsSuccess(
      tvShowModel: tvShowModel ?? this.tvShowModel,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [tvShowModel, hasReachedMax];
  @override
  String toString() =>
      'PopularTvShowSuccess { tvShowModel: ${tvShowModel.length}, hasReachedMax: $hasReachedMax }';
}

// BLOC

class PopularTvShowsBloc
    extends Bloc<PopularTvShowsEvent, PopularTvShowsState> {
  final TMDBRepository tmdbRepository;
  int page = 1;

  PopularTvShowsBloc({this.tmdbRepository});

  @override
  PopularTvShowsState get initialState => PopularTvShowsInitial();

  @override
  Stream<PopularTvShowsState> mapEventToState(
      PopularTvShowsEvent event) async* {
    final currentState = state;
    if (event is FetchPopularTvShows && !_hasReachedMax(currentState)) {
      try {
        if (currentState is PopularTvShowsInitial) {
          final tvShows = await tmdbRepository.fetchPopularTvShows(page: page);
          yield PopularTvShowsSuccess(
              tvShowModel: tvShows, hasReachedMax: false);
          return;
        }

        if (currentState is PopularTvShowsSuccess) {
          final tvShows =
              await tmdbRepository.fetchPopularTvShows(page: ++page);
          yield tvShows.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : PopularTvShowsSuccess(
                  tvShowModel: currentState.tvShowModel + tvShows,
                  hasReachedMax: false,
                );
        }
      } catch (e) {
        print(e);
        yield PopularTvShowsFailed();
      }
    }
  }

  bool _hasReachedMax(PopularTvShowsState state) =>
      state is PopularTvShowsSuccess && state.hasReachedMax;
}
