import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdbflutter/bloc/tvshows/trending/populartvshows_bloc.dart';
import 'package:tmdbflutter/views/tvshow_page.dart';
import 'package:tmdbflutter/widgets/generic/generic_movie_grid_widget.dart';

class TvShowsListWidget extends StatelessWidget {
  const TvShowsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pagedCubit = context.read<PopularTvShowsCubit>();
    return GenericMovieGridWidget(
        pagedCubit: pagedCubit,
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
