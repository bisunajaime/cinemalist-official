import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tmdbflutter/models/season_model.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';

abstract class TvSeasonsState extends Equatable {
  const TvSeasonsState();
  @override
  List<Object> get props => [];
}

class TvSeasonsEmpty extends TvSeasonsState {}

class TvSeasonsLoading extends TvSeasonsState {}

class TvSeasonsError extends TvSeasonsState {}

class TvSeasonsMax extends TvSeasonsState {}

class TvSeasonsLoadingNextPage extends TvSeasonsState {}

class TvSeasonsLoaded extends TvSeasonsState {
  final List<SeasonModel> tvSeasons;
  TvSeasonsLoaded({
    required this.tvSeasons,
  }) : assert(tvSeasons != null);

  @override
  List<Object> get props => [tvSeasons];
}

/*

  EVENT

 */

abstract class TvSeasonsEvent extends Equatable {
  const TvSeasonsEvent();
}

class FetchTvSeasons extends TvSeasonsEvent {
  final int? id;
  const FetchTvSeasons({
    this.id,
  });
  @override
  List<Object> get props => [id!];
}

/*

  BLOC

 */

class TvSeasonsBloc extends Bloc<TvSeasonsEvent, TvSeasonsState> {
  final TMDBRepository tmdbRepository;

  TvSeasonsBloc({required this.tmdbRepository})
      : assert(tmdbRepository != null),
        super(TvSeasonsLoading());

  @override
  TvSeasonsState get initialState => TvSeasonsEmpty();

  @override
  Stream<TvSeasonsState> mapEventToState(TvSeasonsEvent event) async* {
    if (event is FetchTvSeasons) {
      yield TvSeasonsLoading();
      try {
        List<SeasonModel> tvSeasons =
            await tmdbRepository.fetchTvSeasons(id: event.id);
        yield TvSeasonsLoaded(tvSeasons: tvSeasons);
      } catch (e) {
        print(e);
        yield TvSeasonsError();
      }
    }
  }
}
