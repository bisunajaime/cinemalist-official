import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/bloc/watch_later/watch_later_cubit.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/widgets/saved/saved_actors_page.dart';
import 'package:cinemalist/widgets/saved/saved_movies_widget.dart';
import 'package:cinemalist/widgets/saved/saved_tv_shows_widget.dart';
import 'package:cinemalist/widgets/saved/title.dart';

class SavedRecordsWidget extends StatelessWidget {
  const SavedRecordsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesCubit = context.watch<MoviesWatchLaterCubit>();
    final actorsCubit = context.watch<SavedActorsCubit>();
    final tvCubit = context.watch<TvWatchLaterCubit>();

    final totalCount = moviesCubit.state.length + actorsCubit.state.length + tvCubit.state.length;

    if (totalCount == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.card,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.bookmark_outline_rounded, color: AppColors.textMuted, size: 56),
            ),
            const SizedBox(height: 20),
            Text(
              'Nothing saved yet',
              style: Styles.heading.copyWith(fontSize: 24, color: AppColors.textMuted),
            ),
            const SizedBox(height: 8),
            Text(
              'Browse movies, TV shows, and actors\nthen tap the bookmark to save them here.',
              textAlign: TextAlign.center,
              style: Styles.mReg.copyWith(fontSize: 14, color: AppColors.textMuted, height: 1.5),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms);
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 8),
        // Summary bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(icon: Icons.movie_rounded, count: moviesCubit.state.length, label: 'Movies'),
              Container(width: 1, height: 30, color: AppColors.cardLight),
              _StatItem(icon: Icons.tv_rounded, count: tvCubit.state.length, label: 'TV Shows'),
              Container(width: 1, height: 30, color: AppColors.cardLight),
              _StatItem(icon: Icons.person_rounded, count: actorsCubit.state.length, label: 'Actors'),
            ],
          ),
        ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0),
        const SizedBox(height: 20),
        if (moviesCubit.state.isNotEmpty) ...[
          SavedRecordsTitle(
            title: 'Movies',
            icon: Icons.movie_rounded,
            localCubit: moviesCubit,
            type: SavedRecordType.movie,
          ),
          const SizedBox(height: 8),
          const SavedMoviesWidget(),
          const SizedBox(height: 20),
        ],
        if (tvCubit.state.isNotEmpty) ...[
          SavedRecordsTitle(
            title: 'TV Shows',
            icon: Icons.tv_rounded,
            localCubit: tvCubit,
            type: SavedRecordType.tvShow,
          ),
          const SizedBox(height: 8),
          const SavedTvShowsWidget(),
          const SizedBox(height: 20),
        ],
        if (actorsCubit.state.isNotEmpty) ...[
          SavedRecordsTitle(
            title: 'Actors',
            icon: Icons.person_rounded,
            localCubit: actorsCubit,
            type: SavedRecordType.actor,
          ),
          const SizedBox(height: 8),
          const SavedActorsWidget(),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;
  const _StatItem({required this.icon, required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryLight),
        const SizedBox(height: 4),
        Text('$count', style: Styles.mBold.copyWith(fontSize: 18)),
        Text(label, style: Styles.mReg.copyWith(fontSize: 10, color: AppColors.textMuted)),
      ],
    );
  }
}
