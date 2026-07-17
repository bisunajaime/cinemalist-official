import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/bloc/ranking/movie_ranking_cubit.dart';
import 'package:cinemalist/bloc/ranking/ranking_cubit.dart';
import 'package:cinemalist/bloc/watch_later/watch_later_cubit.dart';
import 'package:cinemalist/models/ranking_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';

class RankingMovieSelectionWidget extends StatelessWidget {
  const RankingMovieSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<MoviesWatchLaterCubit>();
    final rankingCubit = context.watch<MovieRankingCubit>();
    final saved = cubit.state;

    if (saved.isEmpty) {
      return _EmptyState(message: 'Save some movies first');
    }

    if (saved.length == rankingCubit.rankedRecordsCount) {
      return _AllRankedState(rankingCubit: rankingCubit);
    }

    return _SelectionList(
      itemCount: saved.length,
      rankingCubit: rankingCubit,
      itemBuilder: (i) {
        final movie = saved[i];
        final ranked = RankingHelper.alreadyRanked(movie.id!, rankingCubit.state);
        if (ranked) return const SizedBox.shrink();
        return _DraggableCard(
          imageUrl: 'https://image.tmdb.org/t/p/w300${movie.posterPath}',
          title: movie.title ?? '',
          data: RankingModel.fromGenericMovieModel(movie),
        );
      },
    );
  }
}

class _AllRankedState extends StatelessWidget {
  final RankingCubit rankingCubit;
  const _AllRankedState({required this.rankingCubit});

  @override
  Widget build(BuildContext context) {
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

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          message,
          style: Styles.mReg.copyWith(fontSize: 13, color: AppColors.textMuted),
        ),
      ),
    );
  }
}

class _SelectionList extends StatelessWidget {
  final int itemCount;
  final RankingCubit rankingCubit;
  final Widget Function(int) itemBuilder;

  const _SelectionList({
    required this.itemCount,
    required this.rankingCubit,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
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
          itemCount: itemCount,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemBuilder: (_, i) => itemBuilder(i),
        ),
      ),
    );
  }
}

class _DraggableCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final RankingModel data;

  const _DraggableCard({
    required this.imageUrl,
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<RankingModel>(
      data: data,
      feedback: Material(
        color: Colors.transparent,
        child: _CardContent(imageUrl: imageUrl, title: title, width: 100, height: 130),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _CardContent(imageUrl: imageUrl, title: title, width: 100, height: 130),
      ),
      child: _CardContent(imageUrl: imageUrl, title: title, width: 100, height: 130),
    ).animate().fadeIn(duration: 250.ms).slideX(begin: 0.05, end: 0);
  }
}

class _CardContent extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double width;
  final double height;

  const _CardContent({
    required this.imageUrl,
    required this.title,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 200),
              errorWidget: (_, __, ___) => Container(color: AppColors.card),
            ),
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
              bottom: 6,
              left: 6,
              right: 6,
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Styles.mBold.copyWith(fontSize: 10),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.drag_indicator_rounded,
                  color: AppColors.primaryLight,
                  size: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
