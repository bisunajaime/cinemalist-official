import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/bloc/ranking/movie_ranking_cubit.dart';
import 'package:cinemalist/bloc/watch_later/watch_later_cubit.dart';
import 'package:cinemalist/models/ranking_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/utils/delayed_runner.dart';
import 'package:cinemalist/widgets/generic/movie_preview_sheet.dart';
import 'package:cinemalist/widgets/dialogs/dialogs.dart';

class SavedMoviesWidget extends StatelessWidget {
  const SavedMoviesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<MoviesWatchLaterCubit>();
    final movies = cubit.state;
    if (movies.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 200,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: movies.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          final movie = movies[i];
          return _SavedMovieCard(
            imageUrl: 'https://image.tmdb.org/t/p/w300${movie.posterPath}',
            title: movie.title ?? '',
            rating: movie.voteAverage ?? 0,
            onTap: () => showMoviePreview(context, movie, list: movies, initialIndex: i),
            onRemove: () async {
              final result = await showDialog(
                context: context,
                builder: (_) => ShowRemoveConfirmationDialog(type: movie.title!),
              );
              if (result != true) return;
              final runner = DelayedRunner(milliseconds: 250);
              runner.run(() async {
                await context.read<MovieRankingCubit>().removeRankingWithoutLetter(
                    RankingModel.fromGenericMovieModel(movie));
                await cubit.save(movie);
              });
            },
          ).animate(delay: (50 * i).ms).fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0);
        },
      ),
    );
  }
}

class _SavedMovieCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double rating;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _SavedMovieCard({
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 250),
                errorWidget: (_, __, ___) => Container(color: AppColors.card),
              ),
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black.withValues(alpha: 0.85), Colors.transparent],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: Styles.mBold.copyWith(fontSize: 11)),
                      const SizedBox(height: 2),
                      Row(children: [
                        Icon(Icons.star_rounded, color: AppColors.ratingColor(rating), size: 12),
                        const SizedBox(width: 3),
                        Text(rating.toStringAsFixed(1), style: Styles.mMed.copyWith(fontSize: 10, color: AppColors.ratingColor(rating))),
                      ]),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 6, right: 6,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(Icons.close_rounded, color: AppColors.error, size: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
