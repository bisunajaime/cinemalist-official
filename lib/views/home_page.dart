import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/bloc/movies/popular/popular_movies_cubit.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/widgets/home/actors_list_widget.dart';
import 'package:cinemalist/widgets/home/genres_list_widget.dart';
import 'package:cinemalist/widgets/home/popular_movies_widget.dart';
import 'package:cinemalist/widgets/home/trending_movies_list_widget.dart';
import 'package:cinemalist/widgets/home/upcoming_movies_list_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage();
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      onRefresh: () async {
        context.read<PopularMoviesCubit>().refresh();
      },
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: [
          const PopularMoviesWidget(),
          _SectionHeader(title: 'Genres').animate()
              .fadeIn(delay: 200.ms, duration: 400.ms)
              .slideX(begin: -0.05, end: 0),
          const GenresListWidget(),
          _SectionHeader(title: 'Upcoming', showSeeMore: true).animate()
              .fadeIn(delay: 300.ms, duration: 400.ms)
              .slideX(begin: -0.05, end: 0),
          const UpcomingMoviesListWidget(),
          _SectionHeader(title: 'Popular Actors', showSeeMore: true).animate()
              .fadeIn(delay: 400.ms, duration: 400.ms)
              .slideX(begin: -0.05, end: 0),
          const ActorsListWidget(),
          _SectionHeader(title: 'Trending This Week', showSeeMore: true).animate()
              .fadeIn(delay: 500.ms, duration: 400.ms)
              .slideX(begin: -0.05, end: 0),
          const TrendingMoviesListWidget(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool showSeeMore;

  const _SectionHeader({required this.title, this.showSeeMore = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Styles.heading.copyWith(fontSize: 24),
          ),
          if (showSeeMore)
            Text(
              'See more',
              style: Styles.mMed.copyWith(
                color: AppColors.primaryLight,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}
