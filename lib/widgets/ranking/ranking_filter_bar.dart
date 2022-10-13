import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdbflutter/bloc/ranking/ranking_filter_cubit.dart';

enum RankingFilter {
  all, // todo: show ranking of all records
  movies,
  tvShows,
  actors,
}

class RankingFilterBar extends StatelessWidget {
  const RankingFilterBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rankingFilterCubit = context.watch<RankingFilterCubit>();
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: TextButton.styleFrom(
            backgroundColor: rankingFilterCubit.isSelected(RankingFilter.movies)
                ? Colors.blue
                : Colors.blue.withOpacity(.25),
          ),
          onPressed: () {
            rankingFilterCubit.updateFilter(RankingFilter.movies);
          },
          child: Text('Movies'),
        ),
        ElevatedButton(
          style: TextButton.styleFrom(
            backgroundColor:
                rankingFilterCubit.isSelected(RankingFilter.tvShows)
                    ? Colors.blue
                    : Colors.blue.withOpacity(.25),
          ),
          onPressed: () {
            rankingFilterCubit.updateFilter(RankingFilter.tvShows);
          },
          child: Text('Tv Shows'),
        ),
        ElevatedButton(
          style: TextButton.styleFrom(
            backgroundColor: rankingFilterCubit.isSelected(RankingFilter.actors)
                ? Colors.blue
                : Colors.blue.withOpacity(.25),
          ),
          onPressed: () {
            rankingFilterCubit.updateFilter(RankingFilter.actors);
          },
          child: Text('Actors'),
        ),
      ],
    );
  }
}
