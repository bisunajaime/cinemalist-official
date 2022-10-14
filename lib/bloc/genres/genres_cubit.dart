import 'package:cinemalist/barrels/models.dart';
import 'package:cinemalist/library/cubit.dart';
import 'package:cinemalist/repository/tmdb_repository/tmdb_repository.dart';

class GenresCubit extends TMDBCubit<List<GenresModel>?> {
  GenresCubit(TMDBRepository tmdbRepository) : super(tmdbRepository);

  @override
  Future<List<GenresModel>?> loadFromServer() async {
    final trendingMovies = await tmdbRepository.fetchTrending();
    var genres = await tmdbRepository.fetchCategories();
    // assign image to genre based on trending movies,
    // movie must not repeat
    addImageToGenre(genres, trendingMovies);
    genres.map((e) => e.genreImage).toList();
    return genres;
  }

  void addImageToGenre(
      List<GenresModel>? genres, List<GenericMoviesModel> movies) {
    if (genres == null || genres.isEmpty) {
      return;
    }
    final genreIds = genres.map((e) => e.id).toList();
    final movieExistsIds = <int?>[];
    final genresAdded = <int?>[];
    movies.forEach((element) {
      for (var id in genreIds) {
        if (genresAdded.contains(id)) {
          continue;
        }
        bool movieHasGenre = element.genreIds?.contains(id) == true;
        bool movieAdded = movieExistsIds.contains(element.id);
        if (movieHasGenre && !movieAdded) {
          movieExistsIds.add(element.id);
          genresAdded.add(id);
          var newGenre = genres.firstWhere((element) => element.id == id);
          newGenre.genreImage = element.posterPath;
        }
      }
    });
  }

  @override
  String get name => 'GenresCubit';
}
