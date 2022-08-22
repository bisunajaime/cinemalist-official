import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdbflutter/barrels/genres_barrel.dart';
import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/utils/genre_utils.dart';

class GenresOfMovieListWidget extends StatelessWidget {
  final List<int>? genreIds;
  const GenresOfMovieListWidget({Key? key, this.genreIds}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final genreCubit = context.read<GenresCubit>();
    if (genreIds == null) return Container();
    final genres = loadGenreIds(genreIds!, genreCubit.state!);
    return Container(
      height: 30,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children:
            genres.map((e) => GenreItem(e, genres.indexOf(e) == 0)).toList(),
      ),
    );
  }
}

class GenreItem extends StatelessWidget {
  final GenresModel genre;
  final bool isFirst;
  const GenreItem(this.genre, this.isFirst);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: EdgeInsets.only(
        right: 8,
        left: isFirst ? 8 : 0,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: grabColorForGenre(genre.name!),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Text(
        genre.name!,
        style: Styles.mBold.copyWith(
          fontSize: 10,
        ),
      ),
    );
  }
}
