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
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (_, __) => Container(
            width: 240,
            margin: const EdgeInsets.only(right: 12),
            child: Shimmer.fromColors(
              baseColor: AppColors.shimmerBase,
              highlightColor: AppColors.shimmerHighlight,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (cubit.error || info == null) return const SizedBox.shrink();

    if (info.videos?.results == null || (info.videos?.results?.isEmpty ?? true)) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam_off_rounded, color: AppColors.textMuted, size: 28),
            const SizedBox(width: 12),
            Text('No trailers available', style: Styles.mMed.copyWith(color: AppColors.textMuted, fontSize: 14)),
          ],
        ),
      );
    }

    return SizedBox(
      height: 180,
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
            total: info.videos!.results!.length,
          ).animate(delay: (80 * index).ms).fadeIn(duration: 300.ms).slideX(begin: 0.1, end: 0);
        },
      ),
    );
  }
}

class _TrailerCard extends StatelessWidget {
  final MovieInfo info;
  final Result? video;
  final int index;
  final int total;

  const _TrailerCard({required this.info, this.video, required this.index, required this.total});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        AppRoutes.slideUp(YoutubePage(ytKey: video?.key, title: video?.name)),
      ),
      child: Container(
        width: 240,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.card,
              AppColors.cardLight,
            ],
          ),
          border: Border.all(color: AppColors.cardLight, width: 1),
        ),
        child: Stack(
          children: [
            // YouTube thumbnail background
            if (video?.key != null)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: ShaderMask(
                    shaderCallback: (rect) => LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.4),
                        Colors.black.withValues(alpha: 0.85),
                      ],
                    ).createShader(rect),
                    blendMode: BlendMode.darken,
                    child: Image.network(
                      'https://img.youtube.com/vi/${video!.key}/hqdefault.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: AppColors.card),
                    ),
                  ),
                ),
              ),
            // Content overlay
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 22),
                      ),
                      const Spacer(),
                      _ActionIcon(
                        icon: Icons.open_in_new_rounded,
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
                      ),
                      const SizedBox(width: 8),
                      _ActionIcon(
                        icon: Icons.share_rounded,
                        onTap: () => shareTrailerLink(
                          info.title ?? '',
                          video?.name ?? '',
                          video?.youtubeTrailerUrl ?? '',
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    video?.name ?? 'Trailer #${index + 1}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.mBold.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.play_circle_outline_rounded, color: AppColors.primaryLight, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${index + 1} of $total',
                        style: Styles.mReg.copyWith(fontSize: 11, color: AppColors.textMuted),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'YouTube',
                          style: Styles.mBold.copyWith(fontSize: 9, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _ActionIcon({required this.icon, required this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white70, size: 16),
      ),
    );
  }
}
