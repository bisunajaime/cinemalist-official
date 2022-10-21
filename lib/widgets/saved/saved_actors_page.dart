import 'package:cinemalist/utils/poster_path_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/bloc/ranking/actor_ranking_cubit.dart';
import 'package:cinemalist/bloc/watch_later/watch_later_cubit.dart';
import 'package:cinemalist/models/ranking_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/utils/delayed_runner.dart';
import 'package:cinemalist/views/actor_info_page.dart';
import 'package:cinemalist/widgets/dialogs/dialogs.dart';

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
          final actor = actors[i];
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
            ),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ActorInfoPage(
                    id: actor.id,
                    name: actor.name,
                    model: actor,
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
                            PosterPathHelper.generatePosterPath(
                                actor.profilePath)),
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
                    child: GestureDetector(
                      onTap: () async {
                        final result = await showDialog(
                          context: context,
                          builder: (context) => ShowRemoveConfirmationDialog(
                            type: actor.name!,
                          ),
                        );
                        if (result != true) return;
                        _runner.run(() async {
                          final rankingCubit =
                              context.read<ActorRankingCubit>();
                          await rankingCubit.removeRankingWithoutLetter(
                              RankingModel.fromGenericActorModel(actor));
                          await cubit.save(actor);
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
