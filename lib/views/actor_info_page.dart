import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdbflutter/bloc/actors/actor_info_cubit.dart';
import 'package:http/http.dart' as http;
import 'package:tmdbflutter/bloc/actors/actor_movies_cubit.dart';
import 'package:tmdbflutter/widgets/actor_info/actor_info_widget.dart';
import 'package:tmdbflutter/widgets/actor_info/actor_movies_widget.dart';

import '../repository/tmdb_api_client.dart';
import '../repository/tmdb_repository.dart';
import '../styles/styles.dart';

class ActorInfoPage extends StatefulWidget {
  final int? id;
  ActorInfoPage({this.id});
  @override
  _ActorInfoPageState createState() => _ActorInfoPageState();
}

class _ActorInfoPageState extends State<ActorInfoPage> {
  TMDBRepository tmdbRepo = TMDBRepository(
    tmdbApiClient: TMDBApiClient(
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
        appBar: buildAppBar(),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
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
            ActorInfoWidget(),
            SizedBox(height: 10),
            ActorMoviesWidget(),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(
        'Actor Info',
        style: Styles.mReg.copyWith(
          fontSize: 15,
        ),
      ),
    );
  }
}
