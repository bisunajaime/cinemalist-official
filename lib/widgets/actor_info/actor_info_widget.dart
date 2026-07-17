import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/bloc/actors/actor_info_cubit.dart';
import 'package:cinemalist/models/actor_info_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/widgets/generic/expandable_text.dart';
import 'package:cinemalist/widgets/generic/info_chip.dart';

class ActorInfoWidget extends StatelessWidget {
  const ActorInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ActorInfoCubit>();
    final actor = cubit.state;

    if (cubit.loading) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (cubit.error || actor == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, color: AppColors.textMuted, size: 32),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => cubit.loadFromServer(),
              icon: const Icon(Icons.refresh_rounded),
              label: Text('Retry', style: Styles.mMed),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: MediaQuery.of(context).size.height * 0.18,
              child: AspectRatio(
                aspectRatio: 2 / 3,
                child: actor.hasProfilePic
                    ? CachedNetworkImage(
                        imageUrl: 'https://image.tmdb.org/t/p/w300${actor.profilePath}',
                        fit: BoxFit.cover,
                      )
                    : Image.asset('assets/images/placeholder_actor.png', fit: BoxFit.cover),
              ),
            ),
          ),
        ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.95, 0.95)),
        const SizedBox(height: 20),
        // Info chips in Wrap
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              if (actor.hasBirthday)
                InfoChip(icon: Icons.cake_rounded, label: actor.age),
              InfoChip(icon: Icons.work_rounded, label: actor.knownForDepartment ?? 'N/A'),
              InfoChip(
                icon: actor.deathday == null ? Icons.favorite_rounded : Icons.heart_broken_rounded,
                label: actor.status,
                iconColor: actor.deathday == null ? AppColors.success : AppColors.error,
              ),
              if (actor.placeOfBirth != null)
                InfoChip(icon: Icons.location_on_rounded, label: actor.placeOfBirth!),
              if (actor.hasBirthday)
                InfoChip(icon: Icons.calendar_today_rounded, label: actor.dateOfBirth, iconColor: AppColors.amber),
            ],
          ),
        ).animate(delay: 100.ms).fadeIn(duration: 400.ms),
        const SizedBox(height: 24),
        Text('BIOGRAPHY', style: Styles.heading.copyWith(fontSize: 26))
            .animate(delay: 200.ms).fadeIn(duration: 400.ms),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ExpandableText(
            text: (actor.biography?.trim().isEmpty ?? true) ? 'Not specified.' : actor.biography!,
            maxLines: 4,
          ),
        ).animate(delay: 300.ms).fadeIn(duration: 400.ms),
      ],
    );
  }
}
