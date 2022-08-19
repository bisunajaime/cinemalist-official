import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tmdbflutter/models/tvshow_model.dart';

import '../../../repository/tmdb_repository.dart';

/*

EVENT

*/

abstract class SimilarTvShowsEvent extends Equatable {
  const SimilarTvShowsEvent();
}

class FetchSimilarTvShows extends SimilarTvShowsEvent {
  final int? id;
  const FetchSimilarTvShows({this.id});
  @override
  List<Object> get props => [id!];
}

//STATES

abstract class SimilarTvShowsState extends Equatable {
  const SimilarTvShowsState();

  @override
  List<Object> get props => [];
}

class SimilarTvShowsEmpty extends SimilarTvShowsState {}

class SimilarTvShowsLoading extends SimilarTvShowsState {}

class SimilarTvShowsError extends SimilarTvShowsState {}

class SimilarTvShowsLoaded extends SimilarTvShowsState {
  final List<TVShowModel>? similarTvShows;

  const SimilarTvShowsLoaded({
    this.similarTvShows,
  });
  @override
  List<Object> get props => [similarTvShows!];
  @override
  String toString() =>
      'SimilarTvShowsSuccess { SimilarTvShows: ${similarTvShows!.length} }';
}

// BLOC

class SimilarTvShowsBloc
    extends Bloc<SimilarTvShowsEvent, SimilarTvShowsState> {
  final TMDBRepository? tmdbRepository;
  SimilarTvShowsBloc({this.tmdbRepository}) : super(SimilarTvShowsLoading());

  @override
  SimilarTvShowsState get initialState => SimilarTvShowsEmpty();

  @override
  Stream<SimilarTvShowsState> mapEventToState(
      SimilarTvShowsEvent event) async* {
    if (event is FetchSimilarTvShows) {
      yield SimilarTvShowsLoading();
      try {
        final List<TVShowModel> similar =
            await tmdbRepository!.fetchSimilarTvShows(id: event.id);
        yield SimilarTvShowsLoaded(similarTvShows: similar);
      } catch (e) {
        yield SimilarTvShowsError();
      }
    }
  }
}
