import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdbflutter/bloc/ranking/ranking_cubit.dart';
import 'package:tmdbflutter/bloc/watch_later/watch_later_cubit.dart';
import 'package:tmdbflutter/models/generic_movies_model.dart';
import 'package:tmdbflutter/widgets/ranking/ranking_movie_selection_widget.dart';
import 'package:tmdbflutter/widgets/saved/saved_movies_widget.dart';

final sTierColor = Color(0xffF08683);
final aTierColor = Color(0xffF5C188);
final bTierColor = Color(0xffFAE08C);
final cTierColor = Color(0xffFFFF91);
final dTierColor = Color(0xffCCFD8F);
final fTierColor = Color(0xffA0FD8E);

class RankingPage extends StatelessWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieRankingCubit = context.read<MovieRankingCubit>();
    return Scaffold(
      backgroundColor: Colors.black,
      body: RankingBody(),
    );
  }
}

class RankingBody extends StatelessWidget {
  const RankingBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // ranking widget
        SizedBox(
          height: MediaQuery.of(context).padding.top,
        ),
        Text(
          'Rank your movies, tv shows, or actors',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        VerticalRankingWidget(),
        // button group for selecting movies|tvshows|actors
        RankingFilterBar(),
        // saved movies and tv shows
        SizedBox(height: 8),
        Text(
          'Records List',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        RankingMovieSelectionWidget(),
      ],
    );
  }
}

// Ranking widget structure:
final structure = {
  "f": [
    {
      "id": "record_id",
      "title": "record_title",
      "type": "tv|movie|person", // can filter by type
      "image_url": "image_url"
    }
  ],
  "a": [
    {
      "id": "record_id",
      "title": "record_title",
    }
  ]
};

enum RankingFilter {
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

class HorizontalRankingWidget extends StatelessWidget {
  const HorizontalRankingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .6,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          VerticalRankingWidgetItem(letter: 'S', color: sTierColor),
          SizedBox(width: 8),
          VerticalRankingWidgetItem(letter: 'A', color: aTierColor),
          SizedBox(width: 8),
          VerticalRankingWidgetItem(letter: 'B', color: bTierColor),
          SizedBox(width: 8),
          VerticalRankingWidgetItem(letter: 'C', color: cTierColor),
          SizedBox(width: 8),
          VerticalRankingWidgetItem(letter: 'D', color: dTierColor),
          SizedBox(width: 8),
          VerticalRankingWidgetItem(letter: 'F', color: fTierColor),
          SizedBox(width: 8),
        ],
      ),
    );
  }
}

class VerticalRankingWidget extends StatelessWidget {
  const VerticalRankingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HorizontalRankingWidgetItem(letter: 's', color: sTierColor),
        HorizontalRankingWidgetItem(letter: 'a', color: aTierColor),
        HorizontalRankingWidgetItem(letter: 'b', color: bTierColor),
        HorizontalRankingWidgetItem(letter: 'c', color: cTierColor),
        HorizontalRankingWidgetItem(letter: 'd', color: dTierColor),
        HorizontalRankingWidgetItem(letter: 'f', color: fTierColor),
      ],
    );
  }
}

class VerticalRankingWidgetItem extends StatelessWidget {
  final String letter;
  final Color color;
  const VerticalRankingWidgetItem({
    Key? key,
    required this.letter,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(30),
          color: color,
          width: 100,
          child: Center(
            child: Text(
              letter,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Expanded(
          child: Container(
            width: 100,
            color: Colors.grey,
          ),
        )
      ],
    );
  }
}

class HorizontalRankingWidgetItem extends StatelessWidget {
  final String letter;
  final Color color;
  const HorizontalRankingWidgetItem({
    Key? key,
    required this.letter,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieRankingCubit = context.watch<MovieRankingCubit>();
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(30),
            color: color,
            width: 80,
            child: Center(
              child: Text(
                letter.toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: DragTarget<GenericMoviesModel>(
              onWillAccept: (data) {
                final movieRankingCubit = context.read<MovieRankingCubit>();
                final exists = movieRankingCubit.state[letter]?.contains(data);
                print(exists);
                return exists != true;
              },
              onAccept: (data) async {
                final movieRankingCubit = context.read<MovieRankingCubit>();
                final didSave = await movieRankingCubit.saveMovie(
                  letter,
                  RankingModel.fromGenericMovieModel(data),
                );
                if (!didSave) print('Movie was not saved');
                print('accepted | ${data.title}');
              },
              onLeave: (data) {
                print('onLeave | ${data?.title}');
              },
              builder: (context, _, __) {
                return Container(
                  height: 85,
                  color: Colors.grey,
                  child: ReorderableListView.builder(
                    onReorder: (oldIndex, newIndex) async {
                      final movieRankingCubit =
                          context.read<MovieRankingCubit>();
                      await movieRankingCubit.updateMovieIndex(
                        letter,
                        oldIndex,
                        newIndex,
                      );
                      print('$oldIndex | $newIndex');
                    },
                    itemCount: movieRankingCubit.state[letter]?.length ?? 0,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final movie = movieRankingCubit.state[letter]![index];
                      return GestureDetector(
                        key: Key('$letter|$index'),
                        onLongPress: () async {
                          final shouldRemove = await showDialog<bool?>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Delete from list?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: Text('Confirm'),
                                  ),
                                ],
                              );
                            },
                          );

                          if (shouldRemove == true) {
                            final movieRankingCubit =
                                context.read<MovieRankingCubit>();
                            await movieRankingCubit.removeMovie(letter, movie);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            movie.title ?? 'No title',
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
