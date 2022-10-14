import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/barrels/genres_barrel.dart';
import 'package:cinemalist/barrels/models.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/utils/genre_utils.dart';

class GenresOfMovieListWidget extends StatelessWidget {
  final List<int>? genreIds;
  const GenresOfMovieListWidget({Key? key, this.genreIds}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final genreCubit = context.read<GenresCubit>();
    final state = genreCubit.state;
    if (genreIds == null ||
        genreIds?.isEmpty == true ||
        state == null ||
        state.isEmpty == true) return Container(height: 5);
    final genres = loadGenreIds(genreIds!, genreCubit.state!);
    return Container(
      height: 30,
      margin: EdgeInsets.symmetric(vertical: 5),
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
