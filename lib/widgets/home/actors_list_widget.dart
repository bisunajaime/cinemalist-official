import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinemalist/barrels/actors_barrel.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/widgets/generic/actor_preview_sheet.dart';

class ActorsListWidget extends StatelessWidget {
  const ActorsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ActorsCubit>();
    final actors = cubit.state;

    if (cubit.isLoading) {
      return SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 6,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemBuilder: (context, i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Shimmer.fromColors(
              baseColor: AppColors.shimmerBase,
              highlightColor: AppColors.shimmerHighlight,
              child: const CircleAvatar(radius: 38),
            ),
          ),
        ),
      );
    }

    if (cubit.error || actors == null) {
      return const SizedBox(height: 100, child: Center(child: Text('Failed to load')));
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, i) {
          final actor = actors[i];
          return GestureDetector(
            onTap: () => showActorPreview(context, actor, list: actors, initialIndex: i),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 2),
                      boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 12)],
                    ),
                    child: CircleAvatar(
                      backgroundColor: AppColors.card,
                      backgroundImage: actor.profilePath != null
                          ? NetworkImage('https://image.tmdb.org/t/p/w200${actor.profilePath}')
                          : null,
                      radius: 38,
                      child: actor.profilePath == null
                          ? const Icon(Icons.person, color: AppColors.textMuted)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 76,
                    child: Text(
                      actor.name ?? '',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.mMed.copyWith(fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ).animate(delay: (60 * i).ms).fadeIn(duration: 300.ms).slideX(begin: 0.1, end: 0);
        },
      ),
    );
  }
}
