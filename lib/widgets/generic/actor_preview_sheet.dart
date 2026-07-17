import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cinemalist/models/actors_model.dart';
import 'package:cinemalist/models/generic_actor_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/views/actor_info_page.dart';

Future<void> showActorPreview(BuildContext context, ActorsModel actor) async {
  HapticFeedback.mediumImpact();
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _ActorPreviewSheet(actor: actor, parentContext: context),
  );
}

Future<void> showGenericActorPreview(BuildContext context, GenericActorModel actor) async {
  HapticFeedback.mediumImpact();
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _GenericActorPreviewSheet(actor: actor, parentContext: context),
  );
}

class _ActorPreviewSheet extends StatelessWidget {
  final ActorsModel actor;
  final BuildContext parentContext;

  const _ActorPreviewSheet({required this.actor, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return _ActorPreviewContent(
      name: actor.name ?? '',
      profilePath: actor.profilePath,
      department: actor.department,
      popularity: actor.popularity,
      onViewDetails: () {
        Navigator.pop(context);
        Navigator.push(
          parentContext,
          AppRoutes.slideUp(ActorInfoPage(
            id: actor.id,
            name: actor.name,
            model: GenericActorModel.fromActorModel(actor),
          )),
        );
      },
    );
  }
}

class _GenericActorPreviewSheet extends StatelessWidget {
  final GenericActorModel actor;
  final BuildContext parentContext;

  const _GenericActorPreviewSheet({required this.actor, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return _ActorPreviewContent(
      name: actor.name ?? '',
      profilePath: actor.profilePath,
      onViewDetails: () {
        Navigator.pop(context);
        Navigator.push(
          parentContext,
          AppRoutes.slideUp(ActorInfoPage(
            id: actor.id,
            name: actor.name,
            model: actor,
          )),
        );
      },
    );
  }
}

class _ActorPreviewContent extends StatelessWidget {
  final String name;
  final String? profilePath;
  final String? department;
  final double? popularity;
  final VoidCallback onViewDetails;

  const _ActorPreviewContent({
    required this.name,
    this.profilePath,
    this.department,
    this.popularity,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textMuted.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          // Avatar
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.3), width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 20,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 56,
              backgroundColor: AppColors.card,
              child: profilePath != null
                  ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: 'https://image.tmdb.org/t/p/w300$profilePath',
                        fit: BoxFit.cover,
                        width: 112,
                        height: 112,
                      ),
                    )
                  : const Icon(Icons.person_rounded, color: AppColors.textMuted, size: 48),
            ),
          ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.85, 0.85)),
          const SizedBox(height: 16),
          // Name
          Text(
            name,
            style: Styles.heading.copyWith(fontSize: 28, color: AppColors.primaryLight),
            textAlign: TextAlign.center,
          ).animate(delay: 100.ms).fadeIn(duration: 300.ms),
          const SizedBox(height: 12),
          // Info chips
          Wrap(
            spacing: 8,
            alignment: WrapAlignment.center,
            children: [
              if (department != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.work_rounded, size: 14, color: AppColors.primaryLight),
                      const SizedBox(width: 5),
                      Text(department!, style: Styles.mMed.copyWith(fontSize: 12)),
                    ],
                  ),
                ),
              if (popularity != null && popularity! > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_up_rounded,
                        size: 14,
                        color: popularity! > 10 ? AppColors.success : AppColors.amber,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        popularity!.toStringAsFixed(1),
                        style: Styles.mMed.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
            ],
          ).animate(delay: 150.ms).fadeIn(duration: 300.ms),
          const SizedBox(height: 24),
          // Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onViewDetails,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('View Full Profile', style: Styles.mBold.copyWith(fontSize: 14)),
              ),
            ),
          ).animate(delay: 200.ms).fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}
