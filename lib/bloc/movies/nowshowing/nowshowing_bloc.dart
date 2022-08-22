import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tmdbflutter/library/cubit.dart';

import '../../../barrels/models.dart';
import '../../../repository/tmdb_repository/tmdb_repository.dart';

class NowShowingCubit extends PagedTMDBCubit<GenericMoviesModel?> {
  NowShowingCubit(TMDBRepository tmdbRepository) : super(tmdbRepository);

  @override
  Future<List<GenericMoviesModel?>?> loadFromServer() {
    return tmdbRepository.fetchNowPlaying(page: 1);
  }

  @override
  Future<List<GenericMoviesModel>?> loadFromServerWithPage(int page) async {
    return await tmdbRepository.fetchNowPlaying(page: page);
  }

  @override
  String get name => 'NowShowingCubit';
}
