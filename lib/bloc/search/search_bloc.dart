import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/library/cubit.dart';
import 'package:tmdbflutter/models/actor_info_model.dart';
import 'package:tmdbflutter/models/tvshow_model.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';

// EVENTS
/*
abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class FetchSearchResults extends SearchEvent {
  final String? query;
  final String? type;
  const FetchSearchResults({this.query, this.type});

  @override
  List<Object> get props => [query!, type!];
}

class ClearEvent extends SearchEvent {
  final String? query;
  final String? type;
  const ClearEvent({this.query, this.type});
  @override
  List<Object> get props => [];
}
// STATES

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object> get props => [];
}

class HasNotSearched extends SearchState {}

class SearchIsLoading extends SearchState {}

class SearchError extends SearchState {}

class ClearSearch extends SearchState {}

class SearchResultsLoaded extends SearchState {
  final List? searchModel;
  final bool? hasReachedMax;
  const SearchResultsLoaded({
    this.searchModel,
    this.hasReachedMax,
  });

  SearchResultsLoaded copyWith({
    List? searchModel,
    bool? hasReachedMax,
  }) {
    return SearchResultsLoaded(
      searchModel: searchModel ?? this.searchModel,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [searchModel!, hasReachedMax!];
  @override
  String toString() =>
      "SearchResultsLoaded { searchModel: ${searchModel!.length}, hasReachedMax: $hasReachedMax }";
}

// BLOC

class SearchResultBloc extends Bloc<SearchEvent, SearchState> {
  final TMDBRepository? tmdbRepository;
  int page = 1;
  SearchResultBloc({this.tmdbRepository}) : super(SearchIsLoading());

  @override
  SearchState get initialState => HasNotSearched();

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is FetchSearchResults) {
      yield SearchIsLoading();
      final results = await tmdbRepository!.fetchSearchResults(
        query: event.query,
        type: event.type,
        page: 1,
      );
      yield SearchResultsLoaded(
        hasReachedMax: false,
        searchModel: results,
      );
    }
//    final currentState = state;
//    if (event is FetchSearchResults && !_hasReachedMax(currentState)) {
//      try {
//        if (currentState is HasNotSearched) {
//          yield SearchIsLoading();
//          final searchResults = await tmdbRepository.fetchSearchResults(
//              query: event.query, type: event.type, page: page);
//          yield SearchResultsLoaded(
//              hasReachedMax: false, searchModel: searchResults);
//          return;
//        }
//
//        if (currentState is SearchResultsLoaded) {
//          final searchResults = await tmdbRepository.fetchSearchResults(
//            page: ++page,
//            type: event.type,
//            query: event.query,
//          );
//          yield searchResults.isEmpty
//              ? currentState.copyWith(hasReachedMax: true)
//              : SearchResultsLoaded(
//                  searchModel: currentState.searchModel + searchResults,
//                  hasReachedMax: false,
//                );
//        }
//      } catch (e) {
//        print(e);
//        yield SearchError();
//      }
//    }
  }

  // bool _hasReachedMax(SearchState state) =>
  //     state is SearchResultsLoaded && state.hasReachedMax;
}*/

class SearchModel {
  final List<ActorInfoModel> actors;
  final List<GenericMoviesModel> movies;
  final List<TVShowModel> tvShows;

  SearchModel(this.actors, this.movies, this.tvShows);

  factory SearchModel.initial() {
    return SearchModel([], [], []);
  }

  SearchModel copyWith({
    List<ActorInfoModel>? actors,
    List<GenericMoviesModel>? movies,
    List<TVShowModel>? tvShows,
  }) {
    return SearchModel(
      actors ?? this.actors,
      movies ?? this.movies,
      tvShows ?? this.tvShows,
    );
  }
}

class SearchCubit extends TMDBCubit<SearchModel> {
  static final types = <String>[
    'movie',
    'person',
    'tv',
  ];

  SearchCubit(TMDBRepository tmdbRepository)
      : super(tmdbRepository, initialState: SearchModel.initial());

  Future<void> search(String searchString) async {
    isLoading = true;
    final actorsResults = tmdbRepository.fetchSearchResults(
        type: 'person', query: searchString, page: 1);
    final movieResults = tmdbRepository.fetchSearchResults(
        type: 'movie', query: searchString, page: 1);
    final tvResults = tmdbRepository.fetchSearchResults(
        type: 'tv', query: searchString, page: 1);
    final results = await Future.wait([
      actorsResults,
      movieResults,
      tvResults,
    ]);
    emit(state?.copyWith(
      actors: results[0],
      movies: results[1],
      tvShows: results[2],
    ));
    isLoading = false;
  }

  @override
  String get name => 'SearchCubit';

  @override
  Future<SearchModel?> loadFromServer() {
    // TODO: implement loadFromServer
    throw UnimplementedError();
  }
}
