import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cinemalist/models/season_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/widgets/generic/fab_go_home.dart';

class SeasonInfoPage extends StatelessWidget {
  final List<SeasonModel>? tvSeasons;
  final SeasonModel? tvShow;
  final int? index;
  final String? name;

  const SeasonInfoPage({this.tvSeasons, this.tvShow, this.index, this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          _buildContent(),
        ],
      ),
      floatingActionButton: const FABGoHome(),
    );
  }

  SliverToBoxAdapter _buildContent() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name ?? '',
              style: Styles.heading.copyWith(fontSize: 28, color: AppColors.primaryLight),
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 8),
            Text(
              tvShow?.name ?? '',
              style: Styles.mMed.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Text(
              tvShow?.overview ?? '',
              style: Styles.mReg.copyWith(
                fontSize: 13,
                height: 1.6,
                color: AppColors.textSecondary,
              ),
            ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
            const SizedBox(height: 24),
            Text(
              'Other Seasons',
              style: Styles.heading.copyWith(fontSize: 26, color: AppColors.primaryLight),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: tvSeasons?.length ?? 0,
                itemBuilder: (context, i) {
                  final season = tvSeasons![i];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      AppRoutes.slideUp(SeasonInfoPage(
                        tvShow: season,
                        index: i,
                        tvSeasons: tvSeasons,
                        name: name,
                      )),
                    ),
                    child: Container(
                      width: 140,
                      margin: const EdgeInsets.only(right: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
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
                  ).animate(delay: (60 * i).ms).fadeIn(duration: 300.ms).slideX(begin: 0.1, end: 0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.6,
      backgroundColor: AppColors.background,
      pinned: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Stack(
          fit: StackFit.expand,
          children: [
            tvShow?.posterPath != null
                ? CachedNetworkImage(
                    imageUrl: 'https://image.tmdb.org/t/p/w500${tvShow!.posterPath}',
                    fit: BoxFit.cover,
                  )
                : Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.background.withValues(alpha: 0.3),
                    AppColors.background,
                  ],
                  stops: const [0.3, 0.7, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
