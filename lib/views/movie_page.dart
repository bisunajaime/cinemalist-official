import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/bloc/movies/cast/movie_cast_bloc.dart';
import 'package:tmdbflutter/bloc/movies/info/movie_info_bloc.dart';
import 'package:tmdbflutter/bloc/movies/info/movie_info_event.dart';
import 'package:tmdbflutter/bloc/movies/info/movie_info_state.dart';
import 'package:tmdbflutter/bloc/movies/similar/similar_movies_bloc.dart';
import 'package:tmdbflutter/models/cast_model.dart';
import 'package:tmdbflutter/models/movieinfo/Result.dart';
import 'package:tmdbflutter/repository/tmdb_api_client.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:http/http.dart' as http;
import 'package:tmdbflutter/views/actor_info_page.dart';
import 'package:tmdbflutter/views/youtube_page.dart';
import 'package:url_launcher/url_launcher.dart';

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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.model.id);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MovieInfoBloc(tmdbRepository: tmdbRepo),
        ),
        BlocProvider(
          create: (context) => MovieCastBloc(tmdbRepository: tmdbRepo),
        ),
        BlocProvider(
          create: (context) => SimilarMoviesBloc(tmdbRepository: tmdbRepo),
        ),
        BlocProvider(
          create: (context) => MovieInfoBloc(tmdbRepository: tmdbRepo),
        ),
      ],
      child: Scaffold(
        backgroundColor: Color(0xff0E0E0E),
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            buildSliverAppBar(context),
            buildSliverToBoxAdapter(),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter buildSliverToBoxAdapter() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              widget.model.title,
              style: Styles.mBold.copyWith(
                fontSize: 20,
                color: Colors.pinkAccent[100],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
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
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              widget.model.overview,
              style: Styles.mReg.copyWith(
                fontSize: 10,
                height: 1.6,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Trailers',
              style: Styles.mBold.copyWith(
                fontSize: 20,
                color: Colors.pinkAccent[100],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          BlocBuilder<MovieInfoBloc, MovieInfoState>(builder: (context, state) {
            if (state is MovieInfoEmpty) {
              BlocProvider.of<MovieInfoBloc>(context)
                  .add(FetchMovieInfo(id: widget.model.id));
            }
            if (state is MovieInfoError) {
              return Center(child: Text('There was a problem'));
            }
            if (state is MovieInfoLoaded) {
              return Container(
                height: 80,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: state.movieInfo.videos.results.length,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, i) {
                    Result videoResult = state.movieInfo.videos.results[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                      ),
                      child: FlatButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => YoutubePage(
                              ytKey: videoResult.key,
                            ),
                          ),
                        ),
                        color: Colors.pinkAccent[100],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.play_arrow,
                              color: Colors.black,
                            ),
                            Text(
                              videoResult.name,
                              style: Styles.mMed.copyWith(
                                color: Colors.black,
                                fontSize: 10,
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
            return CircularProgressIndicator();
          }),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Cast',
              style: Styles.mBold.copyWith(
                fontSize: 20,
                color: Colors.pinkAccent[100],
              ),
            ),
          ),
          SizedBox(
            height: 5,
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
                int castsSize = state.movieCast.length;
                return Container(
                  height: 150,
                  width: double.infinity,
                  child: castsSize == 0
                      ? Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Color(0xff252525),
                          child: Center(
                            child: Text(
                              'Casts Not Updated',
                              style: Styles.mBold,
                            ),
                          ),
                        )
                      : ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: state.movieCast.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, i) {
                            if (state.movieCast.length == 0) {}
                            CastModel model = state.movieCast[i];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ActorInfoPage(
                                            id: model.id,
                                          )),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        height: double.infinity,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Color(0xff252525),
                                          image: DecorationImage(
                                            image: model.profilePath == null
                                                ? AssetImage(
                                                    'assets/images/placeholder_actor.png')
                                                : NetworkImage(
                                                    'https://image.tmdb.org/t/p/w500${model.profilePath}'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      model.name,
                                      style: Styles.mReg.copyWith(
                                        fontSize: 10,
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
              return Container(
                height: 150,
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Shimmer.fromColors(
                        child: Container(
                          height: double.infinity,
                          width: 100,
                        ),
                        baseColor: Color(0xff313131),
                        highlightColor: Color(0xff4A4A4A),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Similar Movies',
              style: Styles.mBold.copyWith(
                fontSize: 20,
                color: Colors.pinkAccent[100],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          BlocBuilder<SimilarMoviesBloc, SimilarMoviesState>(
            builder: (context, state) {
              if (state is SimilarMoviesEmpty) {
                BlocProvider.of<SimilarMoviesBloc>(context)
                    .add(FetchSimilarMoviesMovies(id: widget.model.id));
              }

              if (state is SimilarMoviesError) {
                return Center(
                  child: Text('There was a problem'),
                );
              }

              if (state is SimilarMoviesLoaded) {
                if (state.similarMoviesMovies.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 20,
                      ),
                      child: Text(
                        'None',
                        style: Styles.mBold.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }
                return Container(
                  height: 250,
                  width: double.infinity,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.similarMoviesMovies.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MoviePage(
                              model: state.similarMoviesMovies[i],
                              tag:
                                  'similar${state.similarMoviesMovies[i].posterPath}',
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                width: 150,
                                margin: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: state.similarMoviesMovies[i]
                                                .posterPath ==
                                            null
                                        ? AssetImage(
                                            'assets/images/placeholder.png')
                                        : NetworkImage(
                                            'https://image.tmdb.org/t/p/w500${state.similarMoviesMovies[i].posterPath}'),
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                      Colors.black26,
                                      BlendMode.darken,
                                    ),
                                  ),
                                ),
                                alignment: Alignment.bottomLeft,
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.star,
                                      color: Colors.amberAccent,
                                      size: 15,
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      state.similarMoviesMovies[i].voteAverage
                                          .toString(),
                                      style: Styles.mMed.copyWith(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
              return CircularProgressIndicator();
            },
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }

  SliverAppBar buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * .7,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
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
    );
  }
}
