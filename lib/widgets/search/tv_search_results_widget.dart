import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinemalist/bloc/search/search_cubit.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/views/tvshow_page.dart';
import 'package:cinemalist/widgets/generic/tvshow_preview_sheet.dart';

class TvSearchResultsWidget extends StatelessWidget {
  const TvSearchResultsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SearchCubit>();
    final tvShows = cubit.tvResults;
    final height = MediaQuery.of(context).size.height * 0.2;

    if (cubit.loading || tvShows == null || tvShows.isEmpty) {
      return SizedBox(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: Shimmer.fromColors(
                baseColor: AppColors.shimmerBase,
                highlightColor: AppColors.shimmerHighlight,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    final filtered = tvShows.where((s) => s.posterPath != null).toList();

    return SizedBox(
      height: height,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: filtered.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          final show = filtered[i];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              AppRoutes.slideUp(TvShowPage(model: show)),
            ),
            onLongPress: () => showTvShowPreview(context, show),
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: Container(
                margin: const EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      FadeInImage.assetNetwork(
                        placeholder: 'assets/images/placeholder_box.png',
                        image: 'https://image.tmdb.org/t/p/w300${show.posterPath}',
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 250),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black87, Colors.transparent],
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.star_rounded, color: AppColors.gold, size: 11),
                              const SizedBox(width: 2),
                              Text(
                                (show.voteAverage ?? 0).toStringAsFixed(1),
                                style: Styles.mBold.copyWith(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
