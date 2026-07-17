import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinemalist/barrels/upcoming_movies_barrel.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/widgets/generic/movie_preview_sheet.dart';

class UpcomingMoviesListWidget extends StatelessWidget {
  const UpcomingMoviesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<UpcomingMoviesCubit>();
    final movies = cubit.state;
    final height = MediaQuery.of(context).size.height * 0.22;

    if (cubit.isLoading) {
      return SizedBox(
        height: height,
        child: ListView.builder(
          itemCount: 6,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemBuilder: (context, i) => Container(
            width: 100,
            margin: const EdgeInsets.all(4),
            child: Shimmer.fromColors(
              baseColor: AppColors.shimmerBase,
              highlightColor: AppColors.shimmerHighlight,
              child: Container(decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(10))),
            ),
          ),
        ),
      );
    }

    if (movies == null) return const SizedBox.shrink();

    return SizedBox(
      height: height,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: movies.length,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, i) {
          final movie = movies[i];
          return GestureDetector(
            onTap: () => showMoviePreview(context, movie, list: movies, initialIndex: i),
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: Container(
                margin: const EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'upcoming${movie.posterPath}',
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/placeholder_box.png',
                          image: 'https://image.tmdb.org/t/p/w300${movie.posterPath}',
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(milliseconds: 300),
                        ),
                      ),
                      Positioned(
                        bottom: 0, left: 0, right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black87, Colors.transparent])),
                          child: Row(children: [
                            Icon(Icons.star_rounded, color: AppColors.gold, size: 11),
                            const SizedBox(width: 2),
                            Text((movie.voteAverage ?? 0).toStringAsFixed(1), style: Styles.mBold.copyWith(fontSize: 10)),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ).animate(delay: (40 * i).ms).fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0);
        },
      ),
    );
  }
}
