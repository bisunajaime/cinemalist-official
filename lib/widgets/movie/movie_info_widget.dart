import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinemalist/bloc/movies/info/movie_info_cubit.dart';
import 'package:cinemalist/models/movieinfo/MovieInfo.dart';
import 'package:cinemalist/models/movieinfo/Result.dart';
import 'package:cinemalist/utils/link_sharing.dart';
import 'package:cinemalist/utils/url_opener.dart';
import 'package:cinemalist/views/youtube_page.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';

class MovieInfoWidget extends StatelessWidget {
  const MovieInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<MovieInfoCubit>();
    final info = cubit.state;

    if (cubit.isLoading) {
      return SizedBox(
        height: 120,
        child: Shimmer.fromColors(
          baseColor: AppColors.shimmerBase,
          highlightColor: AppColors.shimmerHighlight,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    }

    if (cubit.error || info == null) {
      return const SizedBox.shrink();
    }

    if (info.videos?.results == null || (info.videos?.results?.isEmpty ?? true)) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.videocam_off_rounded, color: AppColors.textMuted, size: 24),
            const SizedBox(width: 12),
            Text('No trailers available', style: Styles.mMed.copyWith(color: AppColors.textMuted)),
          ],
        ),
      );
    }

    return SizedBox(
      height: 130,
      child: ListView.separated(
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: info.videos!.results!.length,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final video = info.videos?.results?[index];
          return _TrailerCard(
            info: info,
            video: video,
            index: index,
          ).animate(delay: (60 * index).ms).fadeIn(duration: 300.ms).slideX(begin: 0.1, end: 0);
        },
      ),
    );
  }
}

class _TrailerCard extends StatelessWidget {
  final MovieInfo info;
  final Result? video;
  final int index;

  const _TrailerCard({required this.info, this.video, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        AppRoutes.slideUp(YoutubePage(ytKey: video?.key, title: video?.name)),
      ),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, Color(0xFFAD1457)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.play_circle_filled_rounded, color: Colors.white, size: 28),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    if (video?.key != null) await openUrl(video!.youtubeTrailerUrl);
                  },
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(text: video?.youtubeTrailerUrl ?? ''))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Link copied!')),
                      );
                    });
                  },
                  child: const Icon(Icons.link_rounded, color: Colors.white70, size: 22),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => shareTrailerLink(
                    info.title ?? '',
                    video?.name ?? '',
                    video?.youtubeTrailerUrl ?? '',
                  ),
                  child: const Icon(Icons.share_rounded, color: Colors.white70, size: 20),
                ),
              ],
            ),
            const Spacer(),
            Text(
              'Trailer #${index + 1}',
              style: Styles.heading.copyWith(fontSize: 24),
            ),
            if (video?.name != null)
              Text(
                video!.name!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Styles.mReg.copyWith(fontSize: 11, color: Colors.white70),
              ),
          ],
        ),
      ),
    );
  }
}
