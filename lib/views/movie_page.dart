import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/bloc/movies/cast/movie_cast_bloc.dart';
import 'package:tmdbflutter/bloc/movies/info/movie_info_bloc.dart';
import 'package:tmdbflutter/bloc/movies/info/movie_info_event.dart';
import 'package:tmdbflutter/bloc/movies/info/movie_info_state.dart';
import 'package:tmdbflutter/models/cast_model.dart';
import 'package:tmdbflutter/repository/tmdb_api_client.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:http/http.dart' as http;

import '../barrels/models.dart';

class MoviePage extends StatefulWidget {
  final GenericMoviesModel model;
  final String tag;

  MoviePage({
    this.model,
    this.tag,
  });

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
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
          create: (context) => MovieInfoBloc(tmdbRepository: tmdbRepo),
        ),
        BlocProvider(
          create: (context) => MovieCastBloc(tmdbRepository: tmdbRepo),
        ),
      ],
      child: Scaffold(
        backgroundColor: Color(0xff0E0E0E),
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * .7,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  color: Color(0xff0E0E0E),
                  height: double.infinity,
                  width: double.infinity,
                  child: Hero(
                    tag: widget.tag,
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black,
                            Colors.transparent,
                          ],
                        ).createShader(
                          Rect.fromLTRB(
                            0,
                            0,
                            rect.width,
                            rect.height,
                          ),
                        );
                      },
                      blendMode: BlendMode.dstIn,
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500${widget.model.posterPath}',
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.model.title,
                      style: Styles.mBold.copyWith(
                        fontSize: 20,
                        color: Colors.pinkAccent[100],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          DateFormat.yMMMd()
                              .format(DateTime.parse(widget.model.releaseDate)),
                          style: Styles.mMed.copyWith(
                            fontSize: 12,
                            color: Colors.amber,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 12,
                            ),
                            Text(
                              widget.model.voteAverage.toString(),
                              style: Styles.mBold.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.model.overview,
                      style: Styles.mReg.copyWith(
                        fontSize: 10,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Cast',
                      style: Styles.mBold.copyWith(
                        fontSize: 20,
                        color: Colors.pinkAccent[100],
                      ),
                    ),
                    BlocBuilder<MovieCastBloc, MovieCastState>(
                      builder: (context, state) {
                        if (state is MovieCastEmpty) {
                          BlocProvider.of<MovieCastBloc>(context)
                              .add(FetchMovieCast(id: widget.model.id));
                        }
                        if (state is MovieCastError) {
                          return Text('There was a problem');
                        }
                        if (state is MovieCastLoaded) {
                          return Container(
                            height: 100,
                            width: double.infinity,
                            child: ListView.builder(
                              itemCount: state.movieCast.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, i) {
                                CastModel model = state.movieCast[i];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        backgroundImage: NetworkImage(model
                                                    .profilePath !=
                                                null
                                            ? 'https://image.tmdb.org/t/p/w500${model.profilePath}'
                                            : 'https://via.placeholder.com/400'),
                                        radius: 35,
                                      ),
                                      SizedBox(
                                        height: 1,
                                      ),
                                      Text(
                                        model.name,
                                        style: Styles.mMed.copyWith(
                                          fontSize: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return Container(
                          height: 100,
                          width: double.infinity,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 10,
                            itemBuilder: (context, i) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Color(0xff313131),
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
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<MovieInfoBloc, MovieInfoState>(
                      builder: (context, state) {
                        if (state is MovieInfoEmpty) {
                          BlocProvider.of<MovieInfoBloc>(context)
                              .add(FetchMovieInfo(id: widget.model.id));
                        }
                        if (state is MovieInfoError) {
                          return Text('There was a problem');
                        }
                        if (state is MovieInfoLoaded) {
                          return Column(
                            children: <Widget>[
                              Text(
                                state.movieInfo.status,
                                style: Styles.mMed,
                              ),
                            ],
                          );
                        }
                        return Container(
                          height: 50,
                          width: double.infinity,
                          color: Colors.black,
                          child: Shimmer.fromColors(
                            child: Container(),
                            baseColor: Color(0xff313131),
                            highlightColor: Color(0xff4A4A4A),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 200),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
