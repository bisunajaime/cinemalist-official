import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/bloc/actors/actor_info_cubit.dart';
import 'package:http/http.dart' as http;
import 'package:tmdbflutter/bloc/actors/actor_movies_cubit.dart';
import 'package:tmdbflutter/models/actor_info_model.dart';
import 'package:tmdbflutter/views/movie_page.dart';
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
          create: (context) => ActorInfoCubit(tmdbRepo)..loadData(),
        ),
        BlocProvider(
          create: (context) => ActorMoviesCubit(tmdbRepo, widget.id),
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

/*
BlocBuilder<ActorMoviesBloc, ActorMoviesState>(
              builder: (context, state) {
                if (state is ActorMoviesEmpty) {
                  BlocProvider.of<ActorMoviesBloc>(context).add(
                    FetchActorMovies(
                      id: widget.id,
                    ),
                  );
                }

                if (state is ActorMoviesError) {
                  return Text('There was a problem');
                }

                if (state is ActorMoviesLoaded) {
                  return Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.redAccent,
                  );
                }
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(5),
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.pinkAccent[100],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xff2e2e2e),
                      ),
                    ),
                  ),
                );
              },
            ),


*/
