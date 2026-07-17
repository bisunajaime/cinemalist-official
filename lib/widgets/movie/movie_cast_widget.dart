import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinemalist/bloc/movies/cast/movie_cast_cubit.dart';
import 'package:cinemalist/models/generic_actor_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/models/actors_model.dart';
import 'package:cinemalist/views/actor_info_page.dart';
import 'package:cinemalist/widgets/generic/actor_preview_sheet.dart';

class MovieCastWidget extends StatelessWidget {
  const MovieCastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<MovieCastCubit>();
    final cast = cubit.state;

    if (cubit.isLoading) {
      return SizedBox(
        height: 190,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Shimmer.fromColors(
              baseColor: AppColors.shimmerBase,
              highlightColor: AppColors.shimmerHighlight,
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(height: 10, width: 70, decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 4),
                  Container(height: 8, width: 50, decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(4))),
                ],
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

    return SizedBox(
      height: 190,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: cast.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          final actor = cast[i];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              AppRoutes.slideUp(ActorInfoPage(
                id: actor.id,
                name: actor.name,
                model: GenericActorModel.fromCastModel(actor),
              )),
            ),
            onLongPress: () => showActorPreview(context, ActorsModel(
              id: actor.id,
              name: actor.name,
              profilePath: actor.profilePath,
              department: actor.knownForDepartment,
              popularity: actor.popularity,
            )),
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryLight.withValues(alpha: 0.2),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 42,
                      backgroundColor: AppColors.card,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: 'https://image.tmdb.org/t/p/w200${actor.profilePath}',
                          fit: BoxFit.cover,
                          width: 84,
                          height: 84,
                          errorWidget: (_, __, ___) => Image.asset(
                            'assets/images/placeholder_actor.png',
                            fit: BoxFit.cover,
                            width: 84,
                            height: 84,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    actor.name ?? '',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.mBold.copyWith(fontSize: 11),
                  ),
                  if (actor.character != null && actor.character!.isNotEmpty)
                    Text(
                      actor.character!,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.mReg.copyWith(fontSize: 9, color: AppColors.textMuted),
                    ),
                ],
              ),
            ),
          ).animate(delay: (50 * i).ms).fadeIn(duration: 250.ms).slideX(begin: 0.08, end: 0);
        },
      ),
    );
  }
}
