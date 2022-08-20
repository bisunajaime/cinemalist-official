import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdbflutter/bloc/movies/byGenre/moviesbygenre_cubit.dart';
import 'package:tmdbflutter/views/movie_page.dart';
import 'package:tmdbflutter/views/tvshow_page.dart';
import 'package:tmdbflutter/widgets/generic/generic_movie_grid_widget.dart';

class MoviesByGenreListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pagedCubit = context.read<MoviesByGenreCubit>();
    return GenericMovieGridWidget(
        pagedCubit: pagedCubit,
        onTap: (element) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MoviePage(
                  model: element,
                  tag: 'genre${element.posterPath}',
                ),
              ));
        });
  }
}
