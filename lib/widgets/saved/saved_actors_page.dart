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

class SavedActorsWidget extends StatelessWidget {
  const SavedActorsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SavedActorsCubit>();
    final actors = cubit.state;
    if (actors.isEmpty == true) {
      return Container();
    }

    return Container(
      height: 110,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
            ),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ActorInfoPage(
                    id: actors[i].id,
                    name: actors[i].name,
                    model: actors[i],
                  ),
                ),
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
                            'https://image.tmdb.org/t/p/w500${actors[i].profilePath!}'),
                        radius: 45,
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Text(
                        actors[i].name!,
                        style: Styles.mMed.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () async {
                        final result = await showDialog(
                          context: context,
                          builder: (context) => ShowRemoveConfirmationDialog(
                            type: actors[i].name!,
                          ),
                        );
                        if (result != true) return;
                        _runner.run(() async {
                          final rankingCubit =
                              context.read<ActorRankingCubit>();
                          await rankingCubit.removeRankingWithoutLetter(
                              RankingModel.fromGenericActorModel(actors[i]));
                          await cubit.save(actors[i]);
                        });
                      },
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
                          Icons.delete,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
