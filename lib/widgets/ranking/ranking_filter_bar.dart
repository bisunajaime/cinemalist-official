import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdbflutter/bloc/ranking/ranking_filter_cubit.dart';

enum RankingFilter {
  all, // todo: show ranking of all records
  movies,
  tvShows,
  actors,
}

class RankingFilterBar extends StatefulWidget {
  const RankingFilterBar({Key? key}) : super(key: key);

  @override
  State<RankingFilterBar> createState() => _RankingFilterBarState();
}

class _RankingFilterBarState extends State<RankingFilterBar> {
  int selectedIndex = 0;

  void setIndex(int index) {
    selectedIndex = index;
    setState(() {});
  }

  static final _indexToRankingFilter = <int, RankingFilter>{
    0: RankingFilter.movies,
    1: RankingFilter.tvShows,
    2: RankingFilter.actors,
  };

  @override
  Widget build(BuildContext context) {
    final rankingFilterCubit = context.watch<RankingFilterCubit>();
    return BottomNavigationBar(
      backgroundColor: Colors.transparent,
      unselectedItemColor: Color(0xf95d5d5d),
      selectedItemColor: Color(0xffff628b),
      selectedFontSize: 12,
      unselectedFontSize: 12,
      onTap: (value) {
        setIndex(value);
        rankingFilterCubit.updateFilter(_indexToRankingFilter[value]!);
      },
      currentIndex: selectedIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.movie),
          label: 'Movies',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.tv),
          label: 'TV Shows',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Actors',
        ),
      ],
    );
  }
}
