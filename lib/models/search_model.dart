import 'package:cinemalist/barrels/models.dart';
import 'package:cinemalist/models/tvshow_model.dart';

class SearchModel {
  final List<ActorsModel> actors;
  final List<GenericMoviesModel> movies;
  final List<TVShowModel> tvShows;

  SearchModel(this.actors, this.movies, this.tvShows);

  factory SearchModel.initial() {
    return SearchModel([], [], []);
  }

  SearchModel copyWith({
    List<ActorsModel>? actors,
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
