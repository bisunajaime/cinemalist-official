import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cinemalist/models/ranking_model.dart';

class RankingImageWidget extends StatelessWidget {
  final RankingModel model;
  const RankingImageWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (model.fullPhotoUrl == null) return Container();
    return Container(
      height: 85,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(right: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: model.fullPhotoUrl!,
          cacheManager: DefaultCacheManager(),
          fit: BoxFit.cover,
          fadeInCurve: Curves.ease,
          fadeInDuration: Duration(milliseconds: 250),
          fadeOutDuration: Duration(milliseconds: 250),
          fadeOutCurve: Curves.ease,
          height: double.infinity,
          width: double.infinity,
        ),
      ),
    );
  }
}
