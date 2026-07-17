import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/bloc/ranking/tvshow_ranking_cubit.dart';
import 'package:cinemalist/bloc/watch_later/watch_later_cubit.dart';
import 'package:cinemalist/models/ranking_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/utils/delayed_runner.dart';
import 'package:cinemalist/widgets/generic/tvshow_preview_sheet.dart';
import 'package:cinemalist/widgets/dialogs/dialogs.dart';

class SavedTvShowsWidget extends StatelessWidget {
  const SavedTvShowsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TvWatchLaterCubit>();
    final shows = cubit.state;
    if (shows.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 200,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: shows.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          final show = shows[i];
          return GestureDetector(
            onTap: () => showTvShowPreview(context, show, list: shows, initialIndex: i),
            child: Container(
              width: 130,
              margin: const EdgeInsets.only(right: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: 'https://image.tmdb.org/t/p/w300${show.posterPath}',
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
                            Text(show.name ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: Styles.mBold.copyWith(fontSize: 11)),
                            const SizedBox(height: 2),
                            Row(children: [
                              Icon(Icons.star_rounded, color: AppColors.ratingColor(show.voteAverage ?? 0), size: 12),
                              const SizedBox(width: 3),
                              Text((show.voteAverage ?? 0).toStringAsFixed(1), style: Styles.mMed.copyWith(fontSize: 10, color: AppColors.ratingColor(show.voteAverage ?? 0))),
                            ]),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6, right: 6,
                      child: GestureDetector(
                        onTap: () async {
                          final result = await showDialog(
                            context: context,
                            builder: (_) => ShowRemoveConfirmationDialog(type: show.name!),
                          );
                          if (result != true) return;
                          final runner = DelayedRunner(milliseconds: 250);
                          runner.run(() async {
                            await context.read<TvShowRankingCubit>().removeRankingWithoutLetter(
                                RankingModel.fromTvShowModel(show));
                            await cubit.save(show);
                          });
                        },
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
          ).animate(delay: (50 * i).ms).fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0);
        },
      ),
    );
  }
}
