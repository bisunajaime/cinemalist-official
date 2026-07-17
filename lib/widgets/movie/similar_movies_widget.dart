import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinemalist/bloc/movies/similar/similar_movies_bloc.dart';
import 'package:cinemalist/models/generic_movies_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/views/movie_page.dart';
import 'package:cinemalist/widgets/generic/movie_preview_sheet.dart';

class SimilarMoviesWidget extends StatelessWidget {
  const SimilarMoviesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SimilarMoviesCubit>();
    final movies = cubit.state;

    if (cubit.initialLoading) {
      return SizedBox(
        height: 200,
        child: Shimmer.fromColors(
          baseColor: AppColors.shimmerBase,
          highlightColor: AppColors.shimmerHighlight,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    }

    if (movies == null || movies.isEmpty) return const SizedBox.shrink();

    final filtered = movies.where((m) => m.posterPath != null).toList();

    return SizedBox(
      height: 220,
      child: _SimilarMoviesList(movies: filtered),
    );
  }
}

class _SimilarMoviesList extends StatefulWidget {
  final List<GenericMoviesModel> movies;
  const _SimilarMoviesList({required this.movies});

  @override
  State<_SimilarMoviesList> createState() => _SimilarMoviesListState();
}

class _SimilarMoviesListState extends State<_SimilarMoviesList> {
  @override
  Widget build(BuildContext context) {
    final pagedCubit = context.read<SimilarMoviesCubit>();
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final maxScroll = notification.metrics.maxScrollExtent;
        final currentScroll = notification.metrics.pixels;
        if (maxScroll - currentScroll <= 200) {
          pagedCubit.loadNextPage(onComplete: () {
            if (mounted) setState(() {});
          });
        }
        return true;
      },
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: widget.movies.length,
        itemBuilder: (context, i) {
          final movie = widget.movies[i];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              AppRoutes.slideUp(MoviePage(
                model: movie,
                tag: 'similar${movie.posterPath}',
              )),
            ),
            onLongPress: () => showMoviePreview(context, movie),
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: 'https://image.tmdb.org/t/p/w300${movie.posterPath}',
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 250),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black87, Colors.transparent],
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star_rounded, color: AppColors.gold, size: 14),
                            const SizedBox(width: 3),
                            Text(
                              (movie.voteAverage ?? 0).toStringAsFixed(1),
                              style: Styles.mBold.copyWith(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).animate(delay: (40 * i).ms).fadeIn(duration: 250.ms);
        },
      ),
    );
  }
}
