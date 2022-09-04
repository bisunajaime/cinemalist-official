import 'package:tmdbflutter/library/cubit.dart';
import 'package:tmdbflutter/models/tvshowcredits_model.dart';
import 'package:tmdbflutter/repository/tmdb_repository/tmdb_repository.dart';

class TvShowCreditsCubit extends TMDBCubit<TvShowCreditsModel?> {
  final int? movieId;
  TvShowCreditsCubit(TMDBRepository tmdbRepository, this.movieId)
      : super(tmdbRepository);

  @override
  Future<TvShowCreditsModel?> loadFromServer() async {
    return await tmdbRepository.fetchTvShowCredits(id: movieId);
  }

  @override
  String get name => 'TvShowCreditsCubit';
}
