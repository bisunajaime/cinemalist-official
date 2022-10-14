import 'package:cinemalist/library/cubit.dart';
import 'package:cinemalist/models/tvshow_model.dart';

import '../../../repository/tmdb_repository/tmdb_repository.dart';

class SimilarTvShowsCubit extends PagedTMDBCubit<TVShowModel> {
  final int? movieId;
  SimilarTvShowsCubit(TMDBRepository tmdbRepository, this.movieId)
      : super(tmdbRepository);

  @override
  Future<List<TVShowModel>?> loadFromServer() async {
    return await tmdbRepository.fetchSimilarTvShows(id: movieId, page: 1);
  }

  @override
  Future<List<TVShowModel>?> loadFromServerWithPage(int page) async {
    return await tmdbRepository.fetchSimilarTvShows(id: movieId, page: page);
  }

  @override
  String get name => 'SimilarTvShowsCubit';
}
