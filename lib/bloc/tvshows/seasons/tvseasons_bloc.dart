import 'package:cinemalist/library/cubit.dart';
import 'package:cinemalist/models/season_model.dart';
import 'package:cinemalist/repository/tmdb_repository/tmdb_repository.dart';

class TvSeasonsCubit extends TMDBCubit<List<SeasonModel>> {
  final int? movieId;
  TvSeasonsCubit(TMDBRepository tmdbRepository, this.movieId)
      : super(tmdbRepository);

  @override
  Future<List<SeasonModel>?> loadFromServer() async {
    return await tmdbRepository.fetchTvSeasons(id: movieId);
  }

  @override
  String get name => 'TvSeasonsCubit';
}
