import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/bloc/movies/nowshowing/nowshowing_bloc.dart';
import 'package:cinemalist/bloc/watch_later/watch_later_cubit.dart';
import 'package:cinemalist/views/movie_page.dart';
import 'package:cinemalist/widgets/generic/generic_movie_grid_widget.dart';

class NowShowingMoviesListWidget extends StatelessWidget {
  const NowShowingMoviesListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pagedCubit = context.read<NowShowingCubit>();
    final localCubit = context.watch<MoviesWatchLaterCubit>();
    return GenericMovieGridWidget(
        pagedCubit: pagedCubit,
        localCubit: localCubit,
        onTap: (element) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MoviePage(
                tag: 'nowplaying${element.posterPath}',
                model: element,
              ),
            ),
          );
        });
  }
}
