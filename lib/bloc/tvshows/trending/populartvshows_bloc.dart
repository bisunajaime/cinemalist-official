import 'package:tmdbflutter/library/cubit.dart';

import '../../../models/tvshow_model.dart';
import '../../../repository/tmdb_repository.dart';

class PopularTvShowsCubit extends PagedTMDBCubit<TVShowModel?> {
  PopularTvShowsCubit(TMDBRepository tmdbRepository) : super(tmdbRepository);

  @override
  Future<List<TVShowModel?>?> loadFromServer() async {
    return await tmdbRepository.fetchPopularTvShows(page: 1);
  }

  @override
  Future<List<TVShowModel?>?> loadFromServerWithPage(int page) async {
    return await tmdbRepository.fetchPopularTvShows(page: page);
  }

  @override
  String get name => 'PopularTvShowsCubit';
}
