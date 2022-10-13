import 'package:flutter/material.dart';

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
  var rankingFilter = RankingFilter.movies;

  void setRankingFilter(RankingFilter filter) {
    if (filter == rankingFilter) return;
    rankingFilter = filter;
    setState(() {});
  }

  bool isSelected(RankingFilter filter) => filter == rankingFilter;

  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: TextButton.styleFrom(
            backgroundColor: isSelected(RankingFilter.movies)
                ? Colors.blue
                : Colors.blue.withOpacity(.25),
          ),
          onPressed: () {
            setRankingFilter(RankingFilter.movies);
          },
          child: Text('Movies'),
        ),
        ElevatedButton(
          style: TextButton.styleFrom(
            backgroundColor: isSelected(RankingFilter.tvShows)
                ? Colors.blue
                : Colors.blue.withOpacity(.25),
          ),
          onPressed: () {
            setRankingFilter(RankingFilter.tvShows);
          },
          child: Text('Tv Shows'),
        ),
        ElevatedButton(
          style: TextButton.styleFrom(
            backgroundColor: isSelected(RankingFilter.actors)
                ? Colors.blue
                : Colors.blue.withOpacity(.25),
          ),
          onPressed: () {
            setRankingFilter(RankingFilter.actors);
          },
          child: Text('Actors'),
        ),
      ],
    );
  }
}
