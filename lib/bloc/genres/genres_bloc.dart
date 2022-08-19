import 'package:bloc/bloc.dart';
import 'package:tmdbflutter/barrels/genres_barrel.dart';
import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';
import 'package:meta/meta.dart';

class GenresBloc extends Bloc<GenreEvent, GenresState> {
  final TMDBRepository tmdbRepository;

  GenresBloc({required this.tmdbRepository}) : super(GenresLoading());

  @override
  GenresState get initialState => GenresEmpty();

  @override
  Stream<GenresState> mapEventToState(GenreEvent event) async* {
    if (event is FetchGenres) {
      yield GenresLoading();
      try {
        final List<GenresModel> genres = await tmdbRepository.fetchCategories();
        yield GenresLoaded(genres: genres);
      } catch (_) {
        yield GenresError();
      }
    }
  }
}
