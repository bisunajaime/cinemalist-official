import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinemalist/bloc/actors/actor_movies_cubit.dart';
import 'package:cinemalist/styles/styles.dart';
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
        height: 240,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemBuilder: (_, __) => Container(
            width: 120,
            margin: const EdgeInsets.only(right: 10),
            child: Shimmer.fromColors(
              baseColor: AppColors.shimmerBase,
              highlightColor: AppColors.shimmerHighlight,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (cubit.error || movies == null) {
      return Center(
        child: TextButton.icon(
          onPressed: () => cubit.loadData(),
          icon: const Icon(Icons.refresh_rounded, color: AppColors.textMuted),
          label: Text('Retry', style: Styles.mMed.copyWith(color: AppColors.textMuted)),
        ),
      );
    }

    return SizedBox(
      height: 240,
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
            final year = movie.releaseDate != null && movie.releaseDate!.length >= 4
                ? movie.releaseDate!.substring(0, 4)
                : '';
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                AppRoutes.slideUp(MoviePage(
                  model: movie,
                  tag: 'actor${movie.posterPath}',
                )),
              ),
              child: Container(
                width: 120,
                margin: const EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: movie.posterPath != null
                            ? CachedNetworkImage(
                                imageUrl: 'https://image.tmdb.org/t/p/w300${movie.posterPath}',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                fadeInDuration: const Duration(milliseconds: 250),
                              )
                            : Image.asset('assets/images/placeholder.png', fit: BoxFit.cover, width: double.infinity),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      movie.title ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.mMed.copyWith(fontSize: 11),
                    ),
                    if (year.isNotEmpty)
                      Text(
                        year,
                        style: Styles.mReg.copyWith(fontSize: 10, color: AppColors.textMuted),
                      ),
                  ],
                ),
              ),
            ).animate(delay: (40 * i).ms).fadeIn(duration: 250.ms);
          },
        ),
      ),
    );
  }
}
