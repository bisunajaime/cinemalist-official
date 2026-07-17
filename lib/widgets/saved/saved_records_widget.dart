import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/bloc/watch_later/watch_later_cubit.dart';
import 'package:cinemalist/library/cubit.dart';
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

    final hasRecords = moviesCubit.state.isNotEmpty ||
        actorsCubit.state.isNotEmpty ||
        tvCubit.state.isNotEmpty;

    if (!hasRecords) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_outline_rounded, color: AppColors.textMuted, size: 80),
            const SizedBox(height: 16),
            Text(
              'No saved items yet.\nBrowse and tap the bookmark icon\nto save for later.',
              textAlign: TextAlign.center,
              style: Styles.mReg.copyWith(
                fontSize: 15,
                color: AppColors.textMuted,
                height: 1.5,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms);
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        const SizedBox(height: 8),
        SavedRecordsTitle(
          title: 'Movies',
          localCubit: moviesCubit,
          type: SavedRecordType.movie,
        ),
        const SizedBox(height: 4),
        const SavedMoviesWidget(),
        const SizedBox(height: 12),
        SavedRecordsTitle(
          title: 'Actors',
          localCubit: actorsCubit,
          type: SavedRecordType.actor,
        ),
        const SizedBox(height: 4),
        const SavedActorsWidget(),
        const SizedBox(height: 12),
        SavedRecordsTitle(
          title: 'TV Shows',
          localCubit: tvCubit,
          type: SavedRecordType.tvShow,
        ),
        const SizedBox(height: 4),
        const SavedTvShowsWidget(),
        const SizedBox(height: 20),
      ],
    );
  }
}
