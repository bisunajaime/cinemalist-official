import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cinemalist/barrels/genres_barrel.dart';
import 'package:cinemalist/models/tvshow_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/utils/genre_utils.dart';
import 'package:cinemalist/views/tvshow_page.dart';

Future<void> showTvShowPreview(
  BuildContext context,
  TVShowModel show, {
  List<TVShowModel>? list,
  int? initialIndex,
}) async {
  HapticFeedback.mediumImpact();
  final shows = list ?? [show];
  final index = initialIndex ?? 0;
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _TvShowPreviewPager(
      shows: shows,
      initialIndex: index,
      parentContext: context,
    ),
  );
}

class _TvShowPreviewPager extends StatefulWidget {
  final List<TVShowModel> shows;
  final int initialIndex;
  final BuildContext parentContext;

  const _TvShowPreviewPager({required this.shows, required this.initialIndex, required this.parentContext});

  @override
  State<_TvShowPreviewPager> createState() => _TvShowPreviewPagerState();
}

class _TvShowPreviewPagerState extends State<_TvShowPreviewPager> {
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
    final hasMultiple = widget.shows.length > 1;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textMuted.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
          if (hasMultiple) ...[
            const SizedBox(height: 6),
            Text('${_currentIndex + 1} / ${widget.shows.length}', style: Styles.mReg.copyWith(fontSize: 11, color: AppColors.textMuted)),
          ],
          const SizedBox(height: 8),
          SizedBox(
            height: 420,
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.shows.length,
              onPageChanged: (i) {
                HapticFeedback.selectionClick();
                setState(() => _currentIndex = i);
              },
              itemBuilder: (_, i) => _TvShowContent(show: widget.shows[i], parentContext: widget.parentContext),
            ),
          ),
        ],
      ),
    );
  }
}

class _TvShowContent extends StatelessWidget {
  final TVShowModel show;
  final BuildContext parentContext;

  const _TvShowContent({required this.show, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    final rating = show.voteAverage ?? 0;
    final genreCubit = parentContext.read<GenresCubit>();
    final genres = genreCubit.state != null && show.genreIds != null ? loadGenreIds(show.genreIds!, genreCubit.state!) : [];
    final year = show.firstAirDate != null && show.firstAirDate!.length >= 4 ? show.firstAirDate!.substring(0, 4) : '';
    String formattedDate = '';
    if (show.firstAirDate != null && show.firstAirDate!.isNotEmpty) {
      try { formattedDate = DateFormat.yMMMd().format(DateTime.parse(show.firstAirDate!)); } catch (_) {}
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
                  width: 110, height: 165,
                  child: show.posterPath != null
                      ? CachedNetworkImage(imageUrl: 'https://image.tmdb.org/t/p/w300${show.posterPath}', fit: BoxFit.cover)
                      : Container(color: AppColors.card, child: const Icon(Icons.tv_rounded, color: AppColors.textMuted, size: 40)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(show.name ?? '', style: Styles.heading.copyWith(fontSize: 24, color: AppColors.primaryLight), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Row(children: [
                      _RatingBadge(rating: rating),
                      const SizedBox(width: 10),
                      if (year.isNotEmpty) Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(6)),
                        child: Text(year, style: Styles.mBold.copyWith(fontSize: 12, color: AppColors.textSecondary)),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    if (formattedDate.isNotEmpty) Row(children: [
                      const Icon(Icons.calendar_today_rounded, size: 12, color: AppColors.amber),
                      const SizedBox(width: 4),
                      Text(formattedDate, style: Styles.mReg.copyWith(fontSize: 12, color: AppColors.textSecondary)),
                    ]),
                    const SizedBox(height: 10),
                    if (genres.isNotEmpty) Wrap(
                      spacing: 6, runSpacing: 4,
                      children: genres.take(3).map((g) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(gradient: LinearGradient(colors: grabColorForGenre(g.name!)), borderRadius: BorderRadius.circular(6)),
                        child: Text(g.name!, style: Styles.mBold.copyWith(fontSize: 9)),
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (show.overview != null && show.overview!.isNotEmpty)
            Text(show.overview!, maxLines: 4, overflow: TextOverflow.ellipsis, style: Styles.mReg.copyWith(fontSize: 13, height: 1.5, color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(parentContext, AppRoutes.slideUp(TvShowPage(model: show)));
              },
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
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
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withValues(alpha: 0.4))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.star_rounded, color: color, size: 16),
        const SizedBox(width: 4),
        Text(rating.toStringAsFixed(1), style: Styles.mBold.copyWith(fontSize: 14, color: color)),
      ]),
    );
  }
}
