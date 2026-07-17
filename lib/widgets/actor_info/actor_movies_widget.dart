import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinemalist/bloc/actors/actor_movies_cubit.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/views/movie_page.dart';

class ActorMoviesWidget extends StatefulWidget {
  const ActorMoviesWidget({super.key});

  @override
  State<ActorMoviesWidget> createState() => _ActorMoviesWidgetState();
}

class _ActorMoviesWidgetState extends State<ActorMoviesWidget> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ActorMoviesCubit>();
    final movies = cubit.state;

    if (cubit.loading) {
      return SizedBox(
        height: 220,
        child: Shimmer.fromColors(
          baseColor: AppColors.shimmerBase,
          highlightColor: AppColors.shimmerHighlight,
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    }

    if (cubit.error || movies == null) return const SizedBox.shrink();

    return SizedBox(
      height: 220,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          final maxScroll = notification.metrics.maxScrollExtent;
          final currentScroll = notification.metrics.pixels;
          if (maxScroll - currentScroll <= 200 && !cubit.hasReachedMax) {
            cubit.loadNextPage(onComplete: () {
              if (mounted) setState(() {});
            });
          }
          return true;
        },
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, i) {
            final movie = movies[i];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                AppRoutes.slideUp(MoviePage(
                  model: movie,
                  tag: 'actor${movie.posterPath}',
                )),
              ),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: movie.posterPath != null
                        ? CachedNetworkImage(
                            imageUrl: 'https://image.tmdb.org/t/p/w300${movie.posterPath}',
                            fit: BoxFit.cover,
                            fadeInDuration: const Duration(milliseconds: 250),
                          )
                        : Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
                  ),
                ),
              ),
            ).animate(delay: (40 * i).ms).fadeIn(duration: 250.ms);
          },
        ),
      ),
    );
  }
}
