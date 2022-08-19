import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tmdbflutter/models/tvshowcredits_model.dart';
import 'package:meta/meta.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';

abstract class TvShowCreditsState extends Equatable {
  const TvShowCreditsState();
  @override
  List<Object> get props => [];
}

class TvShowCreditsEmpty extends TvShowCreditsState {}

class TvShowCreditsLoading extends TvShowCreditsState {}

class TvShowCreditsError extends TvShowCreditsState {}

class TvShowCreditsMax extends TvShowCreditsState {}

class TvShowCreditsLoadingNextPage extends TvShowCreditsState {}

class TvShowCreditsLoaded extends TvShowCreditsState {
  final TvShowCreditsModel tvShowCredits;
  TvShowCreditsLoaded({
    required this.tvShowCredits,
  }) : assert(tvShowCredits != null);

  @override
  List<Object> get props => [tvShowCredits];
}

/*

  EVENT

 */

abstract class TvShowCreditsEvent extends Equatable {
  const TvShowCreditsEvent();
}

class FetchTvShowCredits extends TvShowCreditsEvent {
  final int? id;
  const FetchTvShowCredits({
    this.id,
  });
  @override
  List<Object> get props => [id!];
}

/*

  BLOC

 */

class TvShowCreditsBloc extends Bloc<TvShowCreditsEvent, TvShowCreditsState> {
  final TMDBRepository tmdbRepository;

  TvShowCreditsBloc({required this.tmdbRepository})
      : super(TvShowCreditsLoading());

  @override
  TvShowCreditsState get initialState => TvShowCreditsEmpty();

  @override
  Stream<TvShowCreditsState> mapEventToState(TvShowCreditsEvent event) async* {
    if (event is FetchTvShowCredits) {
      yield TvShowCreditsLoading();
      try {
        TvShowCreditsModel tvShowCredits =
            await tmdbRepository.fetchTvShowCredits(id: event.id);
        yield TvShowCreditsLoaded(tvShowCredits: tvShowCredits);
      } catch (e) {
        print(e);
        yield TvShowCreditsError();
      }
    }
  }
}
