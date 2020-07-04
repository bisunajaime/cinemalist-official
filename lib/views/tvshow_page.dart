import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/bloc/movies/cast/movie_cast_bloc.dart';
import 'package:tmdbflutter/bloc/tvshows/credits/tvshow_credits_bloc.dart';
import 'package:tmdbflutter/models/cast_model.dart';
import 'package:tmdbflutter/models/crew_model.dart';
import 'package:tmdbflutter/models/tvshow_model.dart';
import 'package:tmdbflutter/repository/tmdb_api_client.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:http/http.dart' as http;

class TvShowPage extends StatefulWidget {
  final TVShowModel model;

  TvShowPage({this.model});

  @override
  _TvShowPageState createState() => _TvShowPageState();
}

class _TvShowPageState extends State<TvShowPage> {
  TMDBRepository tmdbRepo = TMDBRepository(
    tmdbApiClient: TMDBApiClient(
      httpClient: http.Client(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    print(widget.model.id);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TvShowCreditsBloc(tmdbRepository: tmdbRepo),
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
                      widget.model.name,
                      style: Styles.mBold.copyWith(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          widget.model.firstAirDate,
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
                      'Overview',
                      style: Styles.mBold.copyWith(
                        fontSize: 12,
                      ),
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
                    SizedBox(height: 10),
                    Text(
                      'Cast & Crew',
                      style: Styles.mBold.copyWith(
                        fontSize: 20,
                        color: Colors.pinkAccent[100],
                      ),
                    ),
                    BlocBuilder<TvShowCreditsBloc, TvShowCreditsState>(
                      builder: (context, state) {
                        if (state is TvShowCreditsEmpty) {
                          BlocProvider.of<TvShowCreditsBloc>(context)
                              .add(FetchTvShowCredits(id: widget.model.id));
                        }
                        if (state is TvShowCreditsError) {
                          return Text('There was a problem');
                        }
                        if (state is TvShowCreditsLoaded) {
                          int castsSize = state.tvShowCredits.casts.length;
                          int crewSize = state.tvShowCredits.crew.length;
                          return Container(
                            height: castsSize == 0 || crewSize == 0 ? 100 : 200,
                            width: double.infinity,
                            child: Column(
                              children: <Widget>[
                                castsSize == 0
                                    ? Container()
                                    : Expanded(
                                        child: ListView.builder(
                                          itemCount:
                                              state.tvShowCredits.casts.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, i) {
                                            CastModel model =
                                                state.tvShowCredits.casts[i];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 5,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        Colors.grey,
                                                    backgroundImage: model
                                                                .profilePath ==
                                                            null
                                                        ? AssetImage(
                                                            'assets/images/placeholder_actor.png')
                                                        : NetworkImage(
                                                            'https://image.tmdb.org/t/p/w500${model.profilePath}'),
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
                                      ),
                                crewSize == 0
                                    ? Container()
                                    : Expanded(
                                        child: ListView.builder(
                                          itemCount:
                                              state.tvShowCredits.crew.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, i) {
                                            CrewModel model =
                                                state.tvShowCredits.crew[i];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 5,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        Colors.grey,
                                                    backgroundImage: model
                                                                .profilePath ==
                                                            null
                                                        ? AssetImage(
                                                            'assets/images/placeholder_actor.png')
                                                        : NetworkImage(
                                                            'https://image.tmdb.org/t/p/w500${model.profilePath}'),
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
                                      ),
                              ],
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
                      height: 200,
                    ),
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
