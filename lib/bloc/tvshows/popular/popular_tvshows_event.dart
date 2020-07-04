import 'package:equatable/equatable.dart';

abstract class PopularTvShowsEvent extends Equatable {
  const PopularTvShowsEvent();
}

class FetchPopularTvShows extends PopularTvShowsEvent {
  const FetchPopularTvShows();
  @override
  List<Object> get props => [];
}

class LoadNextPage extends PopularTvShowsEvent {
  const LoadNextPage();

  @override
  List<Object> get props => [];
}
