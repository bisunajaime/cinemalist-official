import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinemalist/barrels/popular_movies_barrel.dart';
import 'package:cinemalist/models/generic_movies_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/views/movie_page.dart';

class PopularMoviesWidget extends StatefulWidget {
  const PopularMoviesWidget({super.key});

  @override
  State<PopularMoviesWidget> createState() => _PopularMoviesWidgetState();
}

class _PopularMoviesWidgetState extends State<PopularMoviesWidget> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final PageController _thumbController = PageController(
    initialPage: 0,
    viewportFraction: 0.18,
  );

  @override
  void dispose() {
    _pageController.dispose();
    _thumbController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<PopularMoviesCubit>();
    final movies = cubit.state;

    if (cubit.isLoading) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Shimmer.fromColors(
          baseColor: AppColors.shimmerBase,
          highlightColor: AppColors.shimmerHighlight,
          child: Container(color: AppColors.background),
        ),
      );
    }

    if (cubit.error || movies == null) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: AppColors.textMuted, size: 48),
              const SizedBox(height: 8),
              Text('Failed to load movies', style: Styles.mMed.copyWith(color: AppColors.textMuted)),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.72,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: movies.length,
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemBuilder: (context, i) => _HeroCard(
                movie: movies[i],
                onTap: () => Navigator.push(
                  context,
                  AppRoutes.slideUp(MoviePage(
                    model: movies[i],
                    tag: 'popular${movies[i].posterPath}',
                  )),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 70,
            child: PageView.builder(
              controller: _thumbController,
              itemCount: movies.length,
              onPageChanged: (i) {
                _pageController.animateToPage(
                  i,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                );
              },
              itemBuilder: (context, i) {
                final isActive = _currentIndex == i;
                return GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(i,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic);
                    _thumbController.animateToPage(i,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: isActive
                          ? Border.all(color: AppColors.primaryLight, width: 2)
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          isActive ? Colors.transparent : Colors.black54,
                          isActive ? BlendMode.dst : BlendMode.darken,
                        ),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/placeholder_box.png',
                          image: 'https://image.tmdb.org/t/p/w200${movies[i].posterPath}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final GenericMoviesModel movie;
  final VoidCallback onTap;

  const _HeroCard({required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          FadeInImage.assetNetwork(
            placeholder: 'assets/images/placeholder_box.png',
            image: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 300),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  context.background.withValues(alpha: 0.3),
                  Colors.transparent,
                  context.background,
                ],
                stops: const [0.0, 0.35, 1.0],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title ?? '',
                  style: Styles.heading.copyWith(
                    fontSize: 30,
                    color: AppColors.textPrimary,
                    shadows: [
                      Shadow(color: Colors.black54, blurRadius: 8),
                    ],
                  ),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (movie.releaseDate != null && movie.releaseDate!.isNotEmpty) ...[
                      Icon(Icons.calendar_today_rounded, color: AppColors.amber, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat.yMMMd().format(DateTime.parse(movie.releaseDate!)),
                        style: Styles.mMed.copyWith(fontSize: 11, color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 12),
                    ],
                    _RatingBadge(rating: movie.voteAverage ?? 0),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  movie.overview ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.mReg.copyWith(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'View Details',
                    style: Styles.mBold.copyWith(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final double rating;
  const _RatingBadge({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.ratingColor(rating).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColors.ratingColor(rating).withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, color: AppColors.ratingColor(rating), size: 14),
          const SizedBox(width: 3),
          Text(
            rating.toStringAsFixed(1),
            style: Styles.mBold.copyWith(
              fontSize: 12,
              color: AppColors.ratingColor(rating),
            ),
          ),
        ],
      ),
    );
  }
}
