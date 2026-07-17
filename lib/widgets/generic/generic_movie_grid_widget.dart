import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinemalist/library/cubit.dart';
import 'package:cinemalist/models/ranking_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/utils/delayed_runner.dart';
import 'package:cinemalist/widgets/generic/movie_preview_sheet.dart';

class GenericMovieGridWidget extends StatefulWidget {
  final PagedTMDBCubit pagedCubit;
  final LocalStorageCubit localCubit;
  final Function(dynamic) onTap;
  final Function(dynamic)? onLongPress;

  const GenericMovieGridWidget({
    super.key,
    required this.pagedCubit,
    required this.localCubit,
    required this.onTap,
    this.onLongPress,
  });

  @override
  State<GenericMovieGridWidget> createState() => _GenericMovieGridWidgetState();
}

class _GenericMovieGridWidgetState extends State<GenericMovieGridWidget> {
  final _runner = DelayedRunner(milliseconds: 250);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    await widget.pagedCubit.loadData();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final list = widget.pagedCubit.state;
    if (widget.pagedCubit.initialLoading) {
      return GridView.builder(
        padding: EdgeInsets.zero,
        itemCount: 9,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
          childAspectRatio: 0.67,
        ),
        itemBuilder: (context, i) => Shimmer.fromColors(
          baseColor: AppColors.shimmerBase,
          highlightColor: AppColors.shimmerHighlight,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    }

    if (list == null) return const SizedBox.shrink();

    final filtered = list.where((e) => e?.posterPath != null).toList();

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final maxScroll = notification.metrics.maxScrollExtent;
        final currentScroll = notification.metrics.pixels;
        if (maxScroll - currentScroll <= 200) {
          widget.pagedCubit.loadNextPage(onComplete: () {
            if (mounted) setState(() {});
          });
        }
        return true;
      },
      child: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        onRefresh: () async => await widget.pagedCubit.refresh(),
        child: GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(6),
          physics: const ClampingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 0.67,
          ),
          itemCount: widget.pagedCubit.hasReachedMax
              ? filtered.length
              : filtered.length + 1,
          itemBuilder: (context, i) {
            if (i >= filtered.length) {
              return Shimmer.fromColors(
                baseColor: AppColors.shimmerBase,
                highlightColor: AppColors.shimmerHighlight,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }

            final element = filtered[i]!;
            final isSaved = widget.localCubit.ids.contains(element.id);

            return GestureDetector(
              onTap: widget.onLongPress != null
                  ? () => widget.onLongPress!(element)
                  : () => showMoviePreview(context, element, list: filtered.cast(), initialIndex: i),
              onLongPress: () => widget.onTap(element),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: 'https://image.tmdb.org/t/p/w300${element.posterPath}',
                      cacheManager: DefaultCacheManager(),
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 250),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.card,
                        child: const Center(
                          child: Icon(Icons.image_not_supported, color: AppColors.textMuted),
                        ),
                      ),
                      placeholder: (_, __) => Shimmer.fromColors(
                        baseColor: AppColors.shimmerBase,
                        highlightColor: AppColors.shimmerHighlight,
                        child: Container(color: AppColors.card),
                      ),
                    ),
                    Positioned(
                      bottom: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: () {
                          _runner.run(() async {
                            await RankingHelper.removeRanking(context, element);
                            widget.localCubit.save(element);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSaved
                                ? AppColors.primary
                                : AppColors.card.withValues(alpha: 0.8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            isSaved ? Icons.bookmark_rounded : Icons.bookmark_add_outlined,
                            color: AppColors.textPrimary,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
