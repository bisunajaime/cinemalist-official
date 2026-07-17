import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinemalist/bloc/movies/cast/movie_cast_cubit.dart';
import 'package:cinemalist/models/actors_model.dart';
import 'package:cinemalist/models/generic_actor_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/widgets/generic/actor_preview_sheet.dart';

class MovieCastWidget extends StatelessWidget {
  const MovieCastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<MovieCastCubit>();
    final cast = cubit.state;

    if (cubit.isLoading) {
      return SizedBox(
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Shimmer.fromColors(
              baseColor: AppColors.shimmerBase,
              highlightColor: AppColors.shimmerHighlight,
              child: Container(
                width: 110,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (cubit.error || cast == null) return const SizedBox.shrink();

    if (cast.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline_rounded, color: AppColors.textMuted, size: 28),
            const SizedBox(width: 12),
            Text('Cast not available', style: Styles.mMed.copyWith(color: AppColors.textMuted, fontSize: 14)),
          ],
        ),
      );
    }

    final castAsActors = cast.map((c) => ActorsModel(
      id: c.id, name: c.name, profilePath: c.profilePath,
      department: c.knownForDepartment, popularity: c.popularity,
    )).toList();

    return SizedBox(
      height: 180,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: cast.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          final actor = cast[i];
          return GestureDetector(
            onTap: () => showActorPreview(context, castAsActors[i], list: castAsActors, initialIndex: i),
            child: Container(
              width: 110,
              margin: const EdgeInsets.only(right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: 'https://image.tmdb.org/t/p/w200${actor.profilePath}',
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Container(
                              color: AppColors.card,
                              child: Image.asset('assets/images/placeholder_actor.png', fit: BoxFit.cover),
                            ),
                          ),
                          Positioned(
                            bottom: 0, left: 0, right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    actor.name ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Styles.mBold.copyWith(fontSize: 10),
                                  ),
                                  if (actor.character != null && actor.character!.isNotEmpty)
                                    Text(
                                      actor.character!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Styles.mReg.copyWith(fontSize: 8, color: AppColors.primaryLight),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ).animate(delay: (40 * i).ms).fadeIn(duration: 250.ms).slideX(begin: 0.08, end: 0);
        },
      ),
    );
  }
}
