import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/bloc/search/search_cubit.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/utils/delayed_runner.dart';
import 'package:cinemalist/widgets/search/actor_search_results_widget.dart';
import 'package:cinemalist/widgets/search/movie_search_results_widget.dart';
import 'package:cinemalist/widgets/search/tv_search_results_widget.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SearchCubit>();

    if (!cubit.hasResults && !cubit.didSearch) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_rounded, color: AppColors.textMuted, size: 80),
            const SizedBox(height: 16),
            Text(
              'Search for movies, TV shows,\nor actors',
              textAlign: TextAlign.center,
              style: Styles.mReg.copyWith(
                fontSize: 16,
                color: AppColors.textMuted,
                height: 1.5,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms);
    }

    if (!cubit.hasResults && cubit.didSearch) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, color: AppColors.textMuted, size: 80),
            const SizedBox(height: 16),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                  text: 'No results for\n',
                  style: Styles.mReg.copyWith(fontSize: 16, color: AppColors.textMuted),
                ),
                TextSpan(
                  text: '"${cubit.query}"',
                  style: Styles.mBold.copyWith(fontSize: 16, color: AppColors.textPrimary),
                ),
              ]),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms);
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      children: [
        _SearchSection(
          title: 'Actors',
          count: cubit.actorResults?.length ?? 0,
          child: const ActorSearchResultsWidget(),
        ),
        const SizedBox(height: 16),
        _SearchSection(
          title: 'Movies',
          count: cubit.movieResults?.length ?? 0,
          child: const MovieSearchResultsWidget(),
        ),
        const SizedBox(height: 16),
        _SearchSection(
          title: 'TV Shows',
          count: cubit.tvResults?.length ?? 0,
          child: const TvSearchResultsWidget(),
        ),
      ],
    );
  }
}

class _SearchSection extends StatelessWidget {
  final String title;
  final int count;
  final Widget child;

  const _SearchSection({
    required this.title,
    required this.count,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: Styles.mBold.copyWith(fontSize: 16)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: Styles.mBold.copyWith(fontSize: 12, color: AppColors.primaryLight),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final _runner = DelayedRunner(milliseconds: 700);
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          _runner.run(() async => await cubit.search(_controller.text));
        },
        style: Styles.mReg.copyWith(fontSize: 16),
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap: () {
              _controller.clear();
              _runner.run(() async => await cubit.search(''));
            },
            child: const Icon(Icons.clear_rounded, color: AppColors.textMuted),
          ),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
          hintText: 'Search movies, shows, actors...',
          hintStyle: Styles.mReg.copyWith(color: AppColors.textMuted, fontSize: 15),
        ),
      ),
    );
  }
}
