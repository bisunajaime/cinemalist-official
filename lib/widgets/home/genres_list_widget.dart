import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinemalist/barrels/genres_barrel.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/utils/genre_utils.dart';
import 'package:cinemalist/views/genres_page.dart';

class GenresListWidget extends StatelessWidget {
  const GenresListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<GenresCubit>();
    final genres = cubit.state;

    if (cubit.isLoading) {
      return SizedBox(
        height: 180,
        child: ListView.builder(
          itemCount: 6,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemBuilder: (context, i) => Container(
            width: 140,
            margin: const EdgeInsets.symmetric(horizontal: 4),
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
          ),
        ),
      );
    }

    if (cubit.error || genres == null) {
      return const SizedBox(
        height: 60,
        child: Center(child: Text('Failed to load genres')),
      );
    }

    return SizedBox(
      height: 180,
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: genres.length,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 100,
          childAspectRatio: 0.45,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, i) {
          final genre = genres[i];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              AppRoutes.slideUp(GenresPage(id: genre.id, genre: genre.name)),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: grabColorForGenre(genre.name!),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: grabColorForGenre(genre.name!).first.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(12),
              child: Text(
                genre.name!,
                style: Styles.mBold.copyWith(fontSize: 14),
              ),
            ),
          ).animate(delay: (50 * i).ms).fadeIn(duration: 300.ms).scale(
                begin: const Offset(0.95, 0.95),
                end: const Offset(1, 1),
              );
        },
      ),
    );
  }
}
