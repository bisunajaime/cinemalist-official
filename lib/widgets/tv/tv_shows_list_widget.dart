import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/bloc/tvshows/trending/populartvshows_bloc.dart';
import 'package:cinemalist/bloc/watch_later/watch_later_cubit.dart';
import 'package:cinemalist/views/tvshow_page.dart';
import 'package:cinemalist/widgets/generic/generic_movie_grid_widget.dart';

class TvShowsListWidget extends StatelessWidget {
  const TvShowsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pagedCubit = context.read<PopularTvShowsCubit>();
    final localCubit = context.watch<TvWatchLaterCubit>();
    return GenericMovieGridWidget(
        pagedCubit: pagedCubit,
        localCubit: localCubit,
        onTap: (element) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TvShowPage(
                  model: element,
                ),
              ));
        });
  }
}
