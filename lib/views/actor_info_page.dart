import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/bloc/actors/actor_info_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:tmdbflutter/bloc/actors/actor_movies_bloc.dart';
import 'package:tmdbflutter/models/actor_info_model.dart';
import 'package:tmdbflutter/views/movie_page.dart';

import '../models/cast_model.dart';
import '../repository/tmdb_api_client.dart';
import '../repository/tmdb_repository.dart';
import '../styles/styles.dart';
import '../styles/styles.dart';

class ActorInfoPage extends StatefulWidget {
  final int id;
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
    print(widget.id);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ActorInfoBloc(tmdbRepository: tmdbRepo),
        ),
        BlocProvider(
          create: (context) => ActorMoviesBloc(tmdbRepository: tmdbRepo),
        ),
      ],
      child: Scaffold(
        backgroundColor: Color(0xff0E0E0E),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Actor Info',
            style: Styles.mReg.copyWith(
              fontSize: 15,
            ),
          ),
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            BlocBuilder<ActorInfoBloc, ActorInfoState>(
              builder: (context, state) {
                if (state is ActorInfoEmpty) {
                  BlocProvider.of<ActorInfoBloc>(context).add(
                    FetchActorInfo(
                      id: widget.id,
                    ),
                  );
                }

                if (state is ActorInfoError) {
                  return Text('There was a problem');
                }

                if (state is ActorInfoLoaded) {
                  ActorInfoModel actorInfoModel = state.actorInfo;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: double.infinity,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: double.infinity,
                                margin: EdgeInsets.only(
                                  left: 10,
                                ),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: actorInfoModel.profilePath == null
                                      ? AssetImage(
                                          'assets/images/placeholder_actor.png')
                                      : NetworkImage(
                                          'https://image.tmdb.org/t/p/w500${actorInfoModel.profilePath}'),
                                  alignment: Alignment.center,
                                  fit: BoxFit.cover,
                                )),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                color: Colors.transparent,
                                padding: EdgeInsets.all(5),
                                child: ListView(
                                  children: <Widget>[
                                    Text(
                                      actorInfoModel.name,
                                      style: Styles.mBold.copyWith(
                                        fontSize: 20,
                                        color: Colors.pinkAccent[100],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "Birthplace",
                                      style: Styles.mBold.copyWith(
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      actorInfoModel.placeOfBirth == "?"
                                          ? "Not Specified"
                                          : actorInfoModel.placeOfBirth,
                                      style: Styles.mReg.copyWith(
                                        fontSize: 10,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "Department",
                                      style: Styles.mBold.copyWith(
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      actorInfoModel.knownForDepartment,
                                      style: Styles.mReg.copyWith(
                                        fontSize: 10,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "Birthday",
                                      style: Styles.mBold.copyWith(
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      actorInfoModel.birthday == "?"
                                          ? "Not Specified"
                                          : DateFormat.yMMMd().format(
                                              DateTime.tryParse(
                                                  actorInfoModel.birthday)),
                                      style: Styles.mReg.copyWith(
                                        fontSize: 10,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "Age",
                                      style: Styles.mBold.copyWith(
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      actorInfoModel.birthday == "?"
                                          ? "Not Specified"
                                          : (DateTime.now().year -
                                                  DateTime.parse(actorInfoModel
                                                          .birthday)
                                                      .year)
                                              .toString(),
                                      style: Styles.mReg.copyWith(
                                        fontSize: 10,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "Status",
                                      style: Styles.mBold.copyWith(
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      actorInfoModel.deathday == "?"
                                          ? "Alive"
                                          : actorInfoModel.deathday,
                                      style: Styles.mReg.copyWith(
                                        fontSize: 10,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "Popularity",
                                      style: Styles.mBold.copyWith(
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      actorInfoModel.popularity.toString(),
                                      style: Styles.mBold.copyWith(
                                        fontSize: 10,
                                        color: actorInfoModel.popularity > 5
                                            ? Colors.greenAccent
                                            : Colors.redAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(
                        color: Colors.white,
                        indent: 40.0,
                        endIndent: 40.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Biography",
                          style: Styles.mBold.copyWith(
                            fontSize: 15,
                            color: Colors.pinkAccent[100],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          actorInfoModel.biography.trim().length == 0
                              ? 'Not Specified'
                              : actorInfoModel.biography,
                          style: Styles.mReg.copyWith(
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
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
            Container(
              height: 250,
              width: double.infinity,
              child: BlocBuilder<ActorMoviesBloc, ActorMoviesState>(
                builder: (context, state) {
                  if (state is ActorMoviesEmpty) {
                    BlocProvider.of<ActorMoviesBloc>(context)
                        .add(FetchActorMovies(id: widget.id));
                  }

                  if (state is ActorMoviesError) {
                    return Text("There was a problem");
                  }
                  if (state is ActorMoviesLoaded) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.actorMovies.length,
                      itemBuilder: (context, i) {
                        GenericMoviesModel movie = state.actorMovies[i];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MoviePage(
                                model: movie,
                                tag: 'actor${movie.posterPath}',
                              ),
                            ),
                          ),
                          child: Container(
                            height: double.infinity,
                            width: 150,
                            margin: EdgeInsets.symmetric(
                                horizontal: 2, vertical: 2),
                            child: movie.posterPath == null
                                ? Image.asset('assets/images/placeholder.png')
                                : Image.network(
                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        );
                      },
                    );
                  }
                  return Shimmer.fromColors(
                    child: Container(
                      color: Color(0xff232323),
                      margin: EdgeInsets.all(5),
                    ),
                    baseColor: Color(0xff313131),
                    highlightColor: Color(0xff4A4A4A),
                  );
                },
              ),
            ),
            SizedBox(height: 50),
          ],
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
