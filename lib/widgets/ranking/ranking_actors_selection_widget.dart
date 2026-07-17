import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/bloc/ranking/actor_ranking_cubit.dart';
import 'package:cinemalist/bloc/watch_later/watch_later_cubit.dart';
import 'package:cinemalist/models/ranking_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';

class RankingActorsSelectionWidget extends StatelessWidget {
  const RankingActorsSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SavedActorsCubit>();
    final rankingCubit = context.watch<ActorRankingCubit>();
    final actors = cubit.state;

    if (actors.isEmpty) {
      return _buildEmpty('Save some actors first');
    }

    if (actors.length == rankingCubit.rankedRecordsCount) {
      return _buildAllRanked(rankingCubit);
    }

    return DragTarget<RankingModel>(
      onAcceptWithDetails: (details) async {
        final letter = RankingHelper.findLetterOfModel(rankingCubit.state, details.data);
        if (letter == null) return;
        await rankingCubit.removeRanking(letter, details.data);
      },
      builder: (_, __, ___) => SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: actors.length,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemBuilder: (_, i) {
            final actor = actors[i];
            final ranked = RankingHelper.alreadyRanked(actor.id!, rankingCubit.state);
            if (ranked) return const SizedBox.shrink();
            return _DraggableActorChip(
              imageUrl: 'https://image.tmdb.org/t/p/w200${actor.profilePath}',
              name: actor.name ?? '',
              data: RankingModel.fromGenericActorModel(actor),
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

  Widget _buildAllRanked(ActorRankingCubit rankingCubit) {
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

class _DraggableActorChip extends StatelessWidget {
  final String imageUrl;
  final String name;
  final RankingModel data;
  const _DraggableActorChip({required this.imageUrl, required this.name, required this.data});

  @override
  Widget build(BuildContext context) {
    final avatar = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
                ),
                child: CircleAvatar(
                  backgroundColor: AppColors.card,
                  backgroundImage: NetworkImage(imageUrl),
                  radius: 36,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.drag_indicator_rounded, color: AppColors.primaryLight, size: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 72,
            child: Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Styles.mMed.copyWith(fontSize: 10),
            ),
          ),
        ],
      ),
    );

    return Draggable<RankingModel>(
      data: data,
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(opacity: 0.85, child: avatar),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: avatar),
      child: avatar,
    ).animate().fadeIn(duration: 250.ms).slideX(begin: 0.05, end: 0);
  }
}
