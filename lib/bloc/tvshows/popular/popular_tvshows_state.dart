import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/models/tvshow_model.dart';

abstract class PopularTvShowsState extends Equatable {
  const PopularTvShowsState();
  @override
  List<Object> get props => [];
}

class PopularTvShowsEmpty extends PopularTvShowsState {}

class PopularTvShowsLoading extends PopularTvShowsState {}

class PopularTvShowsError extends PopularTvShowsState {}

class PopularTvShowsMax extends PopularTvShowsState {}

class PopularTvShowsLoadingNextPage extends PopularTvShowsState {}

class PopularTvShowsLoaded extends PopularTvShowsState {
  final List<TVShowModel> popularTvShows;
  PopularTvShowsLoaded({
    @required this.popularTvShows,
  }) : assert(popularTvShows != null);

  @override
  List<Object> get props => [popularTvShows];
}
