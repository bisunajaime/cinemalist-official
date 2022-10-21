import 'package:cinemalist/utils/poster_path_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinemalist/bloc/search/search_cubit.dart';
import 'package:cinemalist/models/generic_actor_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/views/actor_info_page.dart';

class ActorSearchResultsWidget extends StatelessWidget {
  const ActorSearchResultsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SearchCubit>();
    final actors = cubit.actorResults;
    if (cubit.loading || actors?.isEmpty == true) {
      return Container(
        height: 100,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 9,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: CircleAvatar(
                radius: 35,
                backgroundColor: Colors.grey,
                child: Shimmer.fromColors(
                  child: Container(),
                  baseColor: Color(0xff313131),
                  highlightColor: Color(0xff4A4A4A),
                ),
              ),
            );
          },
        ),
      );
    }

    if (cubit.didSearch && actors?.isEmpty == true) {
      return Container();
    }
    actors!;
    return Container(
      height: 100,
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
                    model: GenericActorModel.fromActorModel(actor),
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Color(0xff2e2e2e),
                    backgroundImage: NetworkImage(
                        PosterPathHelper.generatePosterPath(actor.profilePath)),
                    radius: 35,
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    actor.name!,
                    style: Styles.mMed.copyWith(
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
