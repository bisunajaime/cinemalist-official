import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cinemalist/barrels/genres_barrel.dart';
import 'package:cinemalist/models/generic_movies_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/utils/genre_utils.dart';
import 'package:cinemalist/views/movie_page.dart';

Future<void> showMoviePreview(
  BuildContext context,
  GenericMoviesModel movie, {
  List<GenericMoviesModel>? list,
  int? initialIndex,
}) async {
  HapticFeedback.mediumImpact();
  final movies = list ?? [movie];
  final index = initialIndex ?? 0;
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _MoviePreviewPager(
      movies: movies,
      initialIndex: index,
      parentContext: context,
    ),
  );
}

class _MoviePreviewPager extends StatefulWidget {
  final List<GenericMoviesModel> movies;
  final int initialIndex;
  final BuildContext parentContext;

  const _MoviePreviewPager({
    required this.movies,
    required this.initialIndex,
    required this.parentContext,
  });

  @override
  State<_MoviePreviewPager> createState() => _MoviePreviewPagerState();
}

class _MoviePreviewPagerState extends State<_MoviePreviewPager> {
  late final PageController _controller;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasMultiple = widget.movies.length > 1;
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
          if (hasMultiple) ...[
            const SizedBox(height: 6),
            Text(
              '${_currentIndex + 1} / ${widget.movies.length}',
              style: Styles.mReg.copyWith(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
          const SizedBox(height: 8),
          SizedBox(
            height: 420,
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.movies.length,
              onPageChanged: (i) {
                HapticFeedback.selectionClick();
                setState(() => _currentIndex = i);
              },
              itemBuilder: (_, i) => _MoviePreviewContent(
                movie: widget.movies[i],
                parentContext: widget.parentContext,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoviePreviewContent extends StatelessWidget {
  final GenericMoviesModel movie;
  final BuildContext parentContext;

  const _MoviePreviewContent({required this.movie, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    final rating = movie.voteAverage ?? 0;
    final genreCubit = parentContext.read<GenresCubit>();
    final genres = genreCubit.state != null && movie.genreIds != null
        ? loadGenreIds(movie.genreIds!, genreCubit.state!)
        : [];

    final year = movie.releaseDate != null && movie.releaseDate!.length >= 4
        ? movie.releaseDate!.substring(0, 4)
        : '';

    String formattedDate = '';
    if (movie.releaseDate != null && movie.releaseDate!.isNotEmpty) {
      try {
        formattedDate = DateFormat.yMMMd().format(DateTime.parse(movie.releaseDate!));
      } catch (_) {}
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 110,
                  height: 165,
                  child: movie.posterPath != null
                      ? CachedNetworkImage(
                          imageUrl: 'https://image.tmdb.org/t/p/w300${movie.posterPath}',
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: AppColors.card,
                          child: const Icon(Icons.movie_rounded, color: AppColors.textMuted, size: 40),
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      movie.title ?? '',
                      style: Styles.heading.copyWith(fontSize: 24, color: AppColors.primaryLight),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _RatingBadge(rating: rating),
                        const SizedBox(width: 10),
                        if (year.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(year, style: Styles.mBold.copyWith(fontSize: 12, color: AppColors.textSecondary)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (formattedDate.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 12, color: AppColors.amber),
                          const SizedBox(width: 4),
                          Text(formattedDate, style: Styles.mReg.copyWith(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    const SizedBox(height: 10),
                    if (genres.isNotEmpty)
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: genres.take(3).map((g) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: grabColorForGenre(g.name!)),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(g.name!, style: Styles.mBold.copyWith(fontSize: 9)),
                        )).toList(),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (movie.overview != null && movie.overview!.isNotEmpty)
            Text(
              movie.overview!,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: Styles.mReg.copyWith(fontSize: 13, height: 1.5, color: AppColors.textSecondary),
            ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  parentContext,
                  AppRoutes.slideUp(MoviePage(
                    model: movie,
                    tag: 'preview${movie.posterPath}',
                  )),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('View Full Details', style: Styles.mBold.copyWith(fontSize: 14)),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
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
    final color = AppColors.ratingColor(rating);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, color: color, size: 16),
          const SizedBox(width: 4),
          Text(rating.toStringAsFixed(1), style: Styles.mBold.copyWith(fontSize: 14, color: color)),
        ],
      ),
    );
  }
}
