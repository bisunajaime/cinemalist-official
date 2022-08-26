import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:tmdbflutter/bloc/actors/actor_info_cubit.dart';
import 'package:tmdbflutter/bloc/actors/actor_movies_cubit.dart';
import 'package:tmdbflutter/bloc/watch_later/watch_later_cubit.dart';
import 'package:tmdbflutter/models/generic_actor_model.dart';
import 'package:tmdbflutter/repository/tmdb_repository/tmdb_api_repository.dart';
import 'package:tmdbflutter/utils/delayed_runner.dart';
import 'package:tmdbflutter/widgets/actor_info/actor_info_widget.dart';
import 'package:tmdbflutter/widgets/actor_info/actor_movies_widget.dart';
import 'package:tmdbflutter/widgets/generic/fab_go_home.dart';
import 'package:tmdbflutter/widgets/generic/fab_save_record.dart';

import '../repository/tmdb_client/tmdb_api_client.dart';
import '../repository/tmdb_repository/tmdb_repository.dart';
import '../styles/styles.dart';

class ActorInfoPage extends StatefulWidget {
  final int? id;
  final String? name;
  final GenericActorModel model;
  ActorInfoPage({
    this.id,
    required this.name,
    required this.model,
  });
  @override
  _ActorInfoPageState createState() => _ActorInfoPageState();
}

class _ActorInfoPageState extends State<ActorInfoPage> {
  final _runner = DelayedRunner(milliseconds: 250);
  TMDBRepository tmdbRepo = TMDBAPIRepository(
    tmdbClient: TMDBApiClient(
      httpClient: http.Client(),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ActorInfoCubit(tmdbRepo, widget.id)..loadData(),
        ),
        BlocProvider(
          create: (context) =>
              ActorMoviesCubit(tmdbRepo, widget.id)..loadData(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Color(0xff0E0E0E),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // TODO:
            FABSaveRecord<GenericActorModel>(
              tag: 'movie-${widget.id!}',
              isSaved: context.watch<SavedActorsCubit>().isSaved(widget.model),
              record: widget.model,
              onTap: (elem) async {
                _runner.run(() async {
                  await context.read<SavedActorsCubit>().save(elem);
                });
              },
            ),
            SizedBox(width: 8),
            FABGoHome(),
          ],
        ),
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Colors.pinkAccent,
                automaticallyImplyLeading: false,
                pinned: true,
                centerTitle: false,
                expandedHeight: MediaQuery.of(context).size.height * .2,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.zero,
                  stretchModes: [StretchMode.blurBackground],
                  collapseMode: CollapseMode.parallax,
                  centerTitle: false,
                  title: Align(
                    alignment: Alignment.bottomLeft,
                    child: buildTitle(),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      colors: [Colors.pinkAccent, Colors.redAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )),
                    // child: MoviesSliverCarousel(),
                  ),
                ),
              ),
            ];
          },
          body: ListView(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            children: <Widget>[
              ActorInfoWidget(),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Movies",
                  style: Styles.mBold.copyWith(
                    fontSize: 15,
                    color: Colors.pinkAccent[100],
                  ),
                ),
              ),
              SizedBox(height: 10),
              ActorMoviesWidget(),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        bottom: 10,
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  '${widget.name}',
                  maxLines: 999,
                  style: Styles.mBold.copyWith(
                    color: Colors.yellow,
                    fontSize: 10,
                  ),
                ),
                Text(
                  'Actor Details',
                  maxLines: 1,
                  style: Styles.mBold.copyWith(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
