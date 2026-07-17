import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/bloc/ranking/actor_ranking_cubit.dart';
import 'package:cinemalist/bloc/ranking/movie_ranking_cubit.dart';
import 'package:cinemalist/bloc/ranking/ranking_cubit.dart';
import 'package:cinemalist/bloc/ranking/ranking_filter_cubit.dart';
import 'package:cinemalist/bloc/ranking/tvshow_ranking_cubit.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/widgets/ranking/ranking_actors_selection_widget.dart';
import 'package:cinemalist/widgets/ranking/ranking_filter_bar.dart';
import 'package:cinemalist/widgets/ranking/ranking_movie_selection_widget.dart';
import 'package:cinemalist/widgets/ranking/ranking_tvshow_selection_widget.dart';
import 'package:cinemalist/widgets/ranking/vertical_ranking_widget.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieRankingCubit>().initialLoad();
      context.read<ActorRankingCubit>().initialLoad();
      context.read<TvShowRankingCubit>().initialLoad();
    });
  }

  RankingCubit _activeCubit(BuildContext context) {
    final filter = context.watch<RankingFilterCubit>().state;
    if (filter == RankingFilter.actors) return context.watch<ActorRankingCubit>();
    if (filter == RankingFilter.tvShows) return context.watch<TvShowRankingCubit>();
    return context.watch<MovieRankingCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = _activeCubit(context);
    final count = cubit.rankedRecordsCount;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          children: [
            Text('Rankings', style: Styles.heading.copyWith(fontSize: 28)),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Text(
                '$count ranked',
                style: Styles.mBold.copyWith(
                  fontSize: 12,
                  color: AppColors.primaryLight,
                ),
              ),
            ),
          ],
        ),
        actions: [
          if (count > 0)
            IconButton(
              icon: const Icon(Icons.restart_alt_rounded, color: AppColors.textMuted),
              tooltip: 'Reset rankings',
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: AppColors.surface,
                    title: Text('Reset Rankings?', style: Styles.mBold),
                    content: Text(
                      'This will remove all ranked items.',
                      style: Styles.mReg.copyWith(color: AppColors.textSecondary),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('Cancel', style: Styles.mMed.copyWith(color: AppColors.textMuted)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('Reset', style: Styles.mBold.copyWith(color: AppColors.error)),
                      ),
                    ],
                  ),
                );
                if (confirm == true) await cubit.resetRankings();
              },
            ),
          const SizedBox(width: 4),
        ],
      ),
      body: const _RankingBody(),
    );
  }
}

class _RankingBody extends StatelessWidget {
  const _RankingBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: 8),
            child: const VerticalRankingWidget(),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text('Your Saved', style: Styles.mBold.copyWith(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      'drag to rank',
                      style: Styles.mReg.copyWith(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const _RankingSelectionWidget(),
              const SizedBox(height: 4),
              const RankingFilterBar(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}

class _RankingSelectionWidget extends StatelessWidget {
  const _RankingSelectionWidget();

  @override
  Widget build(BuildContext context) {
    final filter = context.watch<RankingFilterCubit>().state;
    if (filter == RankingFilter.movies) return const RankingMovieSelectionWidget();
    if (filter == RankingFilter.tvShows) return const RankingTvShowsSelectionWidget();
    if (filter == RankingFilter.actors) return const RankingActorsSelectionWidget();
    return const SizedBox.shrink();
  }
}
