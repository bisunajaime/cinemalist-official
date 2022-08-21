import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/barrels/actors_barrel.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/views/actor_info_page.dart';

class ActorsListWidget extends StatelessWidget {
  const ActorsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ActorsCubit>();
    final actors = cubit.state;
    if (cubit.isLoading) {
      return Container(
        height: 100,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
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
    if (cubit.error) {
      return Text('todo reload');
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
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Color(0xff2e2e2e),
                    backgroundImage: NetworkImage(actors[i].profilePath!),
                    radius: 35,
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    actors[i].name!,
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
