import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinemalist/bloc/actors/actor_info_cubit.dart';
import 'package:cinemalist/models/actor_info_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';

class ActorInfoWidget extends StatelessWidget {
  const ActorInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ActorInfoCubit>();
    final actor = cubit.state;

    if (cubit.loading) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (cubit.error || actor == null) {
      return Center(
        child: IconButton(
          onPressed: () => cubit.loadFromServer(),
          icon: const Icon(Icons.refresh_rounded, color: AppColors.textMuted, size: 32),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
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
        const SizedBox(height: 16),
        Divider(color: AppColors.cardLight, indent: 40, endIndent: 40),
        const SizedBox(height: 16),
        _ActorDetailsGrid(actor: actor),
        const SizedBox(height: 24),
        Text('BIOGRAPHY', style: Styles.heading.copyWith(fontSize: 26))
            .animate().fadeIn(delay: 200.ms, duration: 400.ms),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            (actor.biography?.trim().isEmpty ?? true)
                ? 'Not Specified'
                : actor.biography!,
            textAlign: TextAlign.center,
            style: Styles.mReg.copyWith(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
      ],
    );
  }
}

class _ActorDetailsGrid extends StatelessWidget {
  final ActorInfoModel actor;
  const _ActorDetailsGrid({required this.actor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Row(
            children: [
              _DetailCard(label: 'Age', content: actor.age),
              const SizedBox(width: 6),
              _DetailCard(label: 'Department', content: actor.knownForDepartment ?? ''),
              const SizedBox(width: 6),
              _DetailCard(label: 'Status', content: actor.status),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _DetailCard(label: 'Birthplace', content: actor.placeOfBirth ?? 'Not Specified'),
              const SizedBox(width: 6),
              _DetailCard(label: 'Birthday', content: actor.dateOfBirth),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String label;
  final String content;
  const _DetailCard({required this.label, required this.content});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Styles.mBold.copyWith(fontSize: 11, color: AppColors.primaryLight),
            ),
            const SizedBox(height: 4),
            Text(
              content,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Styles.mMed.copyWith(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
