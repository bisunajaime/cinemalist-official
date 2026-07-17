import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/bloc/ranking/actor_ranking_cubit.dart';
import 'package:cinemalist/bloc/watch_later/watch_later_cubit.dart';
import 'package:cinemalist/models/ranking_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/utils/delayed_runner.dart';
import 'package:cinemalist/widgets/generic/actor_preview_sheet.dart';
import 'package:cinemalist/widgets/dialogs/dialogs.dart';

class SavedActorsWidget extends StatelessWidget {
  const SavedActorsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SavedActorsCubit>();
    final actors = cubit.state;
    if (actors.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, i) {
          final actor = actors[i];
          return GestureDetector(
            onTap: () => showGenericActorPreview(context, actor, list: actors, initialIndex: i),
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
                        ),
                        child: CircleAvatar(
                          backgroundColor: AppColors.card,
                          backgroundImage: actor.profilePath != null
                              ? NetworkImage('https://image.tmdb.org/t/p/w200${actor.profilePath}')
                              : null,
                          radius: 38,
                          child: actor.profilePath == null
                              ? const Icon(Icons.person_rounded, color: AppColors.textMuted)
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
                  Positioned(
                    top: 0, right: 0,
                    child: GestureDetector(
                      onTap: () async {
                        final result = await showDialog(
                          context: context,
                          builder: (_) => ShowRemoveConfirmationDialog(type: actor.name!),
                        );
                        if (result != true) return;
                        final runner = DelayedRunner(milliseconds: 250);
                        runner.run(() async {
                          await context.read<ActorRankingCubit>().removeRankingWithoutLetter(
                              RankingModel.fromGenericActorModel(actor));
                          await cubit.save(actor);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(Icons.close_rounded, color: AppColors.error, size: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ).animate(delay: (50 * i).ms).fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0);
        },
      ),
    );
  }
}
