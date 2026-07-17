import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cinemalist/models/ranking_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';

class RankingImageWidget extends StatelessWidget {
  final RankingModel model;
  const RankingImageWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    if (model.fullPhotoUrl == null) return const SizedBox(width: 60, height: 80);
    return Container(
      height: 80,
      width: 60,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: model.fullPhotoUrl!,
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 200),
              errorWidget: (_, __, ___) => Container(
                color: AppColors.card,
                child: const Icon(Icons.image_not_supported, color: AppColors.textMuted, size: 16),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
                  ),
                ),
                child: Text(
                  model.title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.mBold.copyWith(fontSize: 7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
