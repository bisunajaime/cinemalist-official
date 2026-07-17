import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinemalist/bloc/movies/cast/movie_cast_cubit.dart';
import 'package:cinemalist/models/generic_actor_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/views/actor_info_page.dart';

class MovieCastWidget extends StatelessWidget {
  const MovieCastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<MovieCastCubit>();
    final cast = cubit.state;

    if (cubit.isLoading) {
      return SizedBox(
        height: 160,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 6,
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Shimmer.fromColors(
              baseColor: AppColors.shimmerBase,
              highlightColor: AppColors.shimmerHighlight,
              child: Column(
                children: [
                  Container(
                    height: 120,
                    width: 90,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(height: 10, width: 60, color: AppColors.card),
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
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text('Cast not available', style: Styles.mMed.copyWith(color: AppColors.textMuted)),
        ),
      );
    }

    return SizedBox(
      height: 160,
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
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: 120,
                      width: 90,
                      child: CachedNetworkImage(
                        imageUrl: 'https://image.tmdb.org/t/p/w200${actor.profilePath}',
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Image.asset(
                          'assets/images/placeholder_actor.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 90,
                    child: Text(
                      actor.name ?? '',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.mMed.copyWith(fontSize: 10),
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
