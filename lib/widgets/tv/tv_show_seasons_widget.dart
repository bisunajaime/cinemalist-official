import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinemalist/bloc/tvshows/seasons/tvseasons_bloc.dart';
import 'package:cinemalist/models/tvshow_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/views/seasoninfo_page.dart';

class TvShowSeasonsWidget extends StatelessWidget {
  final TVShowModel tvShowModel;
  const TvShowSeasonsWidget({super.key, required this.tvShowModel});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TvSeasonsCubit>();
    final seasons = cubit.state;

    if (cubit.isLoading) {
      return SizedBox(
        height: 180,
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

    if (cubit.error || seasons == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${seasons.length} Seasons',
          style: Styles.heading.copyWith(fontSize: 26, color: AppColors.primaryLight),
        ).animate().fadeIn(duration: 400.ms),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: seasons.length,
            itemBuilder: (context, i) {
              final season = seasons[i];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  AppRoutes.slideUp(SeasonInfoPage(
                    index: i,
                    tvSeasons: seasons,
                    tvShow: season,
                    name: tvShowModel.name,
                  )),
                ),
                child: Container(
                  width: 130,
                  margin: const EdgeInsets.only(right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        season.posterPath != null
                            ? CachedNetworkImage(
                                imageUrl: 'https://image.tmdb.org/t/p/w300${season.posterPath}',
                                fit: BoxFit.cover,
                              )
                            : Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black87, Colors.transparent],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 8,
                          right: 8,
                          child: Text(
                            season.name ?? '',
                            style: Styles.mBold.copyWith(fontSize: 13),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate(delay: (50 * i).ms).fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0);
            },
          ),
        ),
      ],
    );
  }
}
