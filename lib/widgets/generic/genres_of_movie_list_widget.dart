import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/barrels/genres_barrel.dart';
import 'package:cinemalist/barrels/models.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/utils/genre_utils.dart';

class GenresOfMovieListWidget extends StatelessWidget {
  final List<int>? genreIds;
  const GenresOfMovieListWidget({super.key, this.genreIds});

  @override
  Widget build(BuildContext context) {
    final genreCubit = context.read<GenresCubit>();
    final state = genreCubit.state;
    if (genreIds == null ||
        genreIds!.isEmpty ||
        state == null ||
        state.isEmpty) {
      return const SizedBox(height: 4);
    }
    final genres = loadGenreIds(genreIds!, state);
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemCount: genres.length,
        itemBuilder: (_, i) => _GenreChip(genre: genres[i]),
      ),
    );
  }
}

class _GenreChip extends StatelessWidget {
  final GenresModel genre;
  const _GenreChip({required this.genre});

  @override
  Widget build(BuildContext context) {
    final colors = grabColorForGenre(genre.name!);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Text(
        genre.name!,
        style: Styles.mBold.copyWith(fontSize: 10),
      ),
    );
  }
}
