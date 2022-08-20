import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdbflutter/bloc/movies/nowshowing/nowshowing_bloc.dart';
import 'package:tmdbflutter/views/movie_page.dart';
import 'package:tmdbflutter/widgets/generic/generic_movie_grid_widget.dart';

class NowShowingMoviesListWidget extends StatelessWidget {
  const NowShowingMoviesListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pagedCubit = context.read<NowShowingCubit>();
    return GenericMovieGridWidget(
        pagedCubit: pagedCubit,
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
