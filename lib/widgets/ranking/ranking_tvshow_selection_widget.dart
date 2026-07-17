import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/bloc/ranking/tvshow_ranking_cubit.dart';
import 'package:cinemalist/bloc/watch_later/watch_later_cubit.dart';
import 'package:cinemalist/models/ranking_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';

class RankingTvShowsSelectionWidget extends StatelessWidget {
  const RankingTvShowsSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TvWatchLaterCubit>();
    final rankingCubit = context.watch<TvShowRankingCubit>();
    final saved = cubit.state;

    if (saved.isEmpty) {
      return _buildEmpty('Save some TV shows first');
    }

    if (saved.length == rankingCubit.rankedRecordsCount) {
      return _buildAllRanked(rankingCubit);
    }

    return DragTarget<RankingModel>(
      onAcceptWithDetails: (details) async {
        final letter = RankingHelper.findLetterOfModel(rankingCubit.state, details.data);
        if (letter == null) return;
        await rankingCubit.removeRanking(letter, details.data);
      },
      builder: (_, __, ___) => SizedBox(
        height: 130,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: saved.length,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemBuilder: (_, i) {
            final show = saved[i];
            final ranked = RankingHelper.alreadyRanked(show.id!, rankingCubit.state);
            if (ranked) return const SizedBox.shrink();
            return _DraggableShowCard(
              imageUrl: 'https://image.tmdb.org/t/p/w300${show.posterPath}',
              title: show.name ?? '',
              data: RankingModel.fromTvShowModel(show),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmpty(String msg) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(msg, style: Styles.mReg.copyWith(fontSize: 13, color: AppColors.textMuted)),
      ),
    );
  }

  Widget _buildAllRanked(TvShowRankingCubit rankingCubit) {
    return DragTarget<RankingModel>(
      onAcceptWithDetails: (details) async {
        final letter = RankingHelper.findLetterOfModel(rankingCubit.state, details.data);
        if (letter == null) return;
        await rankingCubit.removeRanking(letter, details.data);
      },
      builder: (_, __, ___) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        height: 90,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline_rounded, color: AppColors.success, size: 28),
              const SizedBox(height: 6),
              Text(
                'All items ranked! Double-tap to remove.',
                style: Styles.mReg.copyWith(fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DraggableShowCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final RankingModel data;
  const _DraggableShowCard({required this.imageUrl, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: 100,
      height: 130,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover, fadeInDuration: const Duration(milliseconds: 200)),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
                ),
              ),
            ),
            Positioned(
              bottom: 6, left: 6, right: 6,
              child: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: Styles.mBold.copyWith(fontSize: 10)),
            ),
            Positioned(
              top: 4, right: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(6)),
                child: const Icon(Icons.drag_indicator_rounded, color: AppColors.primaryLight, size: 14),
              ),
            ),
          ],
        ),
      ),
    );

    return Draggable<RankingModel>(
      data: data,
      feedback: Material(color: Colors.transparent, child: Opacity(opacity: 0.85, child: card)),
      childWhenDragging: Opacity(opacity: 0.3, child: card),
      child: card,
    ).animate().fadeIn(duration: 250.ms).slideX(begin: 0.05, end: 0);
  }
}
