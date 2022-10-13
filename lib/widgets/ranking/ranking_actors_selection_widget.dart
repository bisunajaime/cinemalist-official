import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdbflutter/bloc/ranking/actor_ranking_cubit.dart';
import 'package:tmdbflutter/bloc/watch_later/watch_later_cubit.dart';
import 'package:tmdbflutter/models/ranking_model.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/utils/delayed_runner.dart';
import 'package:tmdbflutter/views/actor_info_page.dart';
import 'package:tmdbflutter/widgets/dialogs/dialogs.dart';

final _runner = DelayedRunner(milliseconds: 250);

class RankingActorsSelectionWidget extends StatelessWidget {
  const RankingActorsSelectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SavedActorsCubit>();
    final rankingCubit = context.watch<ActorRankingCubit>();
    final actors = cubit.state;
    if (cubit.state.length == rankingCubit.rankedRecordsCount) {
      return DragTarget<RankingModel>(
        onAccept: (data) async {
          final letter =
              RankingHelper.findLetterOfModel(rankingCubit.state, data);
          if (letter == null) return;
          await rankingCubit.removeRanking(letter, data);
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            margin: EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 8,
            ),
            height: 100,
            decoration: BoxDecoration(
              color: Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'Drag here or double tap\nitem to remove',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(.5),
                ),
              ),
            ),
          );
        },
      );
    }

    return DragTarget<RankingModel>(
      onAccept: (data) async {
        final letter =
            RankingHelper.findLetterOfModel(rankingCubit.state, data);
        if (letter == null) return;
        await rankingCubit.removeRanking(letter, data);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          height: 110,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: actors.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, i) {
              final actor = actors[i];
              final alreadyRanked = RankingHelper.alreadyRanked(
                actor.id!,
                rankingCubit.state,
              );
              if (alreadyRanked) return Container();
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Color(0xff2e2e2e),
                          backgroundImage: NetworkImage(
                              'https://image.tmdb.org/t/p/w500${actor.profilePath!}'),
                          radius: 45,
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Text(
                          actor.name!,
                          style: Styles.mMed.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Draggable<RankingModel>(
                        data: RankingModel.fromGenericActorModel(actor),
                        feedback: CircleAvatar(
                          backgroundColor: Color(0xff2e2e2e),
                          backgroundImage: NetworkImage(
                              'https://image.tmdb.org/t/p/w500${actor.profilePath!}'),
                          radius: 45,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(4),
                          margin: EdgeInsets.only(
                            right: 8,
                            bottom: 8,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.pinkAccent,
                          ),
                          child: Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
