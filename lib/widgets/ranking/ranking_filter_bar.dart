import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/bloc/ranking/ranking_filter_cubit.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';

enum RankingFilter {
  all,
  movies,
  tvShows,
  actors,
}

class RankingFilterBar extends StatelessWidget {
  const RankingFilterBar({super.key});

  static const _filters = [
    (RankingFilter.movies, Icons.movie_rounded, 'Movies'),
    (RankingFilter.tvShows, Icons.tv_rounded, 'TV Shows'),
    (RankingFilter.actors, Icons.person_rounded, 'Actors'),
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<RankingFilterCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: _filters.map((f) {
          final isSelected = cubit.state == f.$1;
          return Expanded(
            child: GestureDetector(
              onTap: () => cubit.updateFilter(f.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.4)
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      f.$2,
                      size: 16,
                      color: isSelected ? AppColors.primaryLight : AppColors.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      f.$3,
                      style: Styles.mMed.copyWith(
                        fontSize: 12,
                        color: isSelected ? AppColors.primaryLight : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
