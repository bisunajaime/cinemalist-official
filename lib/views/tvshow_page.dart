import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/bloc/tvshows/credits/tvshow_credits_bloc.dart';
import 'package:tmdbflutter/bloc/tvshows/seasons/tvseasons_bloc.dart';
import 'package:tmdbflutter/bloc/tvshows/similar/similar_tv_bloc.dart';
import 'package:tmdbflutter/models/cast_model.dart';
import 'package:tmdbflutter/models/season_model.dart';
import 'package:tmdbflutter/models/tvshow_model.dart';
import 'package:tmdbflutter/repository/tmdb_api_client.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:http/http.dart' as http;
import 'package:tmdbflutter/views/actor_info_page.dart';
import 'package:tmdbflutter/views/seasoninfo_page.dart';

import '../styles/styles.dart';

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
        BlocProvider(
          create: (context) => TvSeasonsBloc(tmdbRepository: tmdbRepo),
        ),
        BlocProvider(
          create: (context) => SimilarTvShowsBloc(tmdbRepository: tmdbRepo),
        ),
      ],
      child: Scaffold(
        backgroundColor: Color(0xff0E0E0E),
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            buildHeading(context),
            buildBody(),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter buildBody() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              widget.model.name,
              style: Styles.mBold.copyWith(
                fontSize: 20,
                color: Colors.pinkAccent[100],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: <Widget>[
                Text(
                  DateFormat.yMMMd()
                      .format(DateTime.parse(widget.model.firstAirDate)),
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
                          itemCount: state.tvShowCredits.casts.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, i) {
                            if (state.tvShowCredits.casts.length == 0) {}
                            CastModel model = state.tvShowCredits.casts[i];
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
                                    ),
                                  ),
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
          BlocBuilder<TvSeasonsBloc, TvSeasonsState>(
            builder: (context, state) {
              if (state is TvSeasonsEmpty) {
                BlocProvider.of<TvSeasonsBloc>(context)
                    .add(FetchTvSeasons(id: widget.model.id));
              }

              if (state is TvSeasonsEmpty) {
                return Text('Not Available');
              }

              if (state is TvSeasonsLoaded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '${state.tvSeasons.length} Seasons',
                        style: Styles.mBold.copyWith(
                          fontSize: 20,
                          color: Colors.pinkAccent[100],
                        ),
                      ),
                    ),
                    Container(
                      height: 200,
                      width: double.infinity,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: state.tvSeasons.length,
                        itemBuilder: (context, i) {
                          SeasonModel model = state.tvSeasons[i];
                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SeasonInfoPage(
                                  index: i,
                                  tvSeasons: state.tvSeasons,
                                  tvShow: model,
                                  name: widget.model.name,
                                ),
                              ),
                            ),
                            child: Container(
                              height: double.infinity,
                              width: 130,
                              margin: EdgeInsets.all(2),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Color(0xff2e2e2e),
                                image: DecorationImage(
                                    image: model.posterPath == null
                                        ? AssetImage(
                                            'assets/images/placeholder.png')
                                        : NetworkImage(
                                            'https://image.tmdb.org/t/p/w500${model.posterPath}'),
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                      Colors.black26,
                                      BlendMode.darken,
                                    )),
                              ),
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                model.name,
                                style: Styles.mBold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
              return CircularProgressIndicator();
            },
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Similar Tv Shows',
              style: Styles.mBold.copyWith(
                fontSize: 20,
                color: Colors.pinkAccent[100],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          BlocBuilder<SimilarTvShowsBloc, SimilarTvShowsState>(
            builder: (context, state) {
              if (state is SimilarTvShowsEmpty) {
                BlocProvider.of<SimilarTvShowsBloc>(context)
                    .add(FetchSimilarTvShows(id: widget.model.id));
              }

              if (state is SimilarTvShowsError) {
                return Center(
                  child: Text('There was a problem'),
                );
              }

              if (state is SimilarTvShowsLoaded) {
                if (state.similarTvShows.isEmpty) {
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
                    itemCount: state.similarTvShows.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TvShowPage(
                              model: state.similarTvShows[i],
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                width: 170,
                                margin: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: state.similarTvShows[i].posterPath ==
                                            null
                                        ? AssetImage(
                                            'assets/images/placeholder.png')
                                        : NetworkImage(
                                            'https://image.tmdb.org/t/p/w500${state.similarTvShows[i].posterPath}'),
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
                                      state.similarTvShows[i].voteAverage
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
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  SliverAppBar buildHeading(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * .7,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
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
    );
  }
}
