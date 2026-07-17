import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/bloc/movies/byGenre/moviesbygenre_cubit.dart';
import 'package:cinemalist/repository/tmdb_repository/tmdb_repository.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/utils/genre_utils.dart';
import 'package:cinemalist/widgets/genre/movies_by_genre_list.dart';

class GenresPage extends StatelessWidget {
  final int? id;
  final String? genre;
  const GenresPage({this.id, this.genre});

  @override
  Widget build(BuildContext context) {
    final tmdbRepo = context.read<TMDBRepository>();
    return BlocProvider<MoviesByGenreCubit>(
      create: (context) => MoviesByGenreCubit(tmdbRepo, id!),
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            final colors = grabColorForGenre(genre!);
            return [
              SliverAppBar(
                pinned: true,
                expandedHeight: MediaQuery.of(context).size.height * 0.2,
                backgroundColor: colors.first,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  title: Text(
                    genre!,
                    style: Styles.heading.copyWith(fontSize: 28),
                  ),
                  titlePadding: const EdgeInsets.only(left: 16, bottom: 14),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: colors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
            ];
          },
          floatHeaderSlivers: true,
          body: const MoviesByGenreListWidget(),
        ),
      ),
    );
  }
}
