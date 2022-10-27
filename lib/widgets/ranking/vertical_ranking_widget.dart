import 'package:flutter/material.dart';
import 'package:cinemalist/bloc/ranking/actor_ranking_cubit.dart';
import 'package:cinemalist/bloc/ranking/movie_ranking_cubit.dart';
import 'package:provider/provider.dart';
import 'package:cinemalist/bloc/ranking/ranking_cubit.dart';
import 'package:cinemalist/bloc/ranking/ranking_filter_cubit.dart';
import 'package:cinemalist/bloc/ranking/tvshow_ranking_cubit.dart';
import 'package:cinemalist/models/ranking_model.dart';
import 'package:cinemalist/widgets/ranking/ranking_filter_bar.dart';
import 'package:cinemalist/widgets/ranking/ranking_image_widget.dart';

final sTierColor = Color(0xffF08683);
final aTierColor = Color(0xffF5C188);
final bTierColor = Color(0xffFAE08C);
final cTierColor = Color(0xffFFFF91);
final dTierColor = Color(0xffCCFD8F);
final fTierColor = Color(0xffA0FD8E);

class VerticalRankingWidget extends StatelessWidget {
  const VerticalRankingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          HorizontalRankingWidgetItem(letter: 's', color: sTierColor),
          HorizontalRankingWidgetItem(letter: 'a', color: aTierColor),
          HorizontalRankingWidgetItem(letter: 'b', color: bTierColor),
          HorizontalRankingWidgetItem(letter: 'c', color: cTierColor),
          HorizontalRankingWidgetItem(letter: 'd', color: dTierColor),
          HorizontalRankingWidgetItem(letter: 'f', color: fTierColor),
        ],
      ),
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

  RankingCubit loadRankingCubit(
      BuildContext context, RankingFilterCubit filterCubit) {
    switch (filterCubit.state) {
      case RankingFilter.movies:
        return context.watch<MovieRankingCubit>();
      case RankingFilter.actors:
        return context.watch<ActorRankingCubit>();
      case RankingFilter.tvShows:
        return context.watch<TvShowRankingCubit>();
      default:
        return context.watch<MovieRankingCubit>();
    }
  }

  @override
  Widget build(BuildContext context) {
    final rankingFilterCubit = context.watch<RankingFilterCubit>();
    RankingCubit rankingCubit = loadRankingCubit(context, rankingFilterCubit);

    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
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
            child: DragTarget<RankingModel>(
              onWillAccept: (data) {
                if (data == null) return false;
                final exists = rankingCubit.state[letter]?.contains(data);
                print(exists);
                return exists != true;
              },
              onAccept: (data) async {
                final didSave = await rankingCubit.saveRanking(
                  letter,
                  data,
                );
                if (!didSave) print('Movie was not saved');
                print('accepted | ${data.title}');
              },
              onLeave: (data) {
                print('onLeave | ${data?.title}');
              },
              builder: (context, _, __) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 85,
                    decoration: BoxDecoration(
                      color: Color(0xff202020),
                    ),
                    child: ReorderableListView.builder(
                      padding: EdgeInsets.zero,
                      onReorder: (oldIndex, newIndex) async {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        await rankingCubit.updateRankingIndex(
                          letter,
                          oldIndex,
                          newIndex,
                        );
                        print('$oldIndex | $newIndex');
                      },
                      itemCount: rankingCubit.state[letter]?.length ?? 0,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final movie = rankingCubit.state[letter]![index];
                        return GestureDetector(
                          key: Key('$letter|$index|${movie.id}'),
                          onDoubleTap: () async {
                            await rankingCubit.removeRanking(letter, movie);
                          },
                          child: Stack(
                            children: [
                              RankingImageWidget(model: movie),
                              Positioned(
                                bottom: 4,
                                left: 4,
                                child: Draggable<RankingModel>(
                                  data: movie,
                                  feedback: RankingImageWidget(model: movie),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.menu,
                                      color: Colors.pinkAccent,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 12,
                                child: ReorderableDragStartListener(
                                  index: index,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.pinkAccent,
                                    ),
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.back_hand,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
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
