import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/bloc/search/search_cubit.dart';
import 'package:tmdbflutter/bloc/watch_later/watch_later_cubit.dart';
import 'package:tmdbflutter/models/generic_actor_model.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/views/actor_info_page.dart';

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
              child: Column(
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
            ),
          );
        },
      ),
    );
  }
}
