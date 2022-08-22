import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/bloc/tvshows/credits/tvshow_credits_bloc.dart';
import 'package:tmdbflutter/bloc/tvshows/seasons/tvseasons_bloc.dart';
import 'package:tmdbflutter/bloc/tvshows/similar/similar_tv_bloc.dart';
import 'package:tmdbflutter/bloc/watch_later/watch_later_cubit.dart';
import 'package:tmdbflutter/models/cast_model.dart';
import 'package:tmdbflutter/models/season_model.dart';
import 'package:tmdbflutter/models/tvshow_model.dart';
import 'package:tmdbflutter/repository/tmdb_client/tmdb_api_client.dart';
import 'package:tmdbflutter/repository/tmdb_repository/tmdb_api_repository.dart';
import 'package:tmdbflutter/repository/tmdb_repository/tmdb_repository.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:http/http.dart' as http;
import 'package:tmdbflutter/utils/delayed_runner.dart';
import 'package:tmdbflutter/views/actor_info_page.dart';
import 'package:tmdbflutter/views/seasoninfo_page.dart';
import 'package:tmdbflutter/widgets/generic/fab_go_home.dart';
import 'package:tmdbflutter/widgets/generic/fab_save_record.dart';
import 'package:tmdbflutter/widgets/generic/genres_of_movie_list_widget.dart';
import 'package:tmdbflutter/widgets/tv/similar_tv_shows_widget.dart';
import 'package:tmdbflutter/widgets/tv/tv_show_credits_widget.dart';
import 'package:tmdbflutter/widgets/tv/tv_show_seasons_widget.dart';

import '../styles/styles.dart';

class TvShowPage extends StatefulWidget {
  final TVShowModel? model;

  TvShowPage({this.model});

  @override
  _TvShowPageState createState() => _TvShowPageState();
}

class _TvShowPageState extends State<TvShowPage> {
  final _runner = DelayedRunner(milliseconds: 250);
  TMDBRepository tmdbRepo = TMDBAPIRepository(
    tmdbClient: TMDBApiClient(
      httpClient: http.Client(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    print(widget.model!.id);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              TvShowCreditsCubit(tmdbRepo, widget.model?.id)..loadData(),
        ),
        BlocProvider(
          create: (context) =>
              TvSeasonsCubit(tmdbRepo, widget.model?.id)..loadData(),
        ),
        BlocProvider(
          create: (context) =>
              SimilarTvShowsCubit(tmdbRepo, widget.model?.id)..loadData(),
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
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FABSaveRecord<TVShowModel>(
              tag: 'movie-${widget.model!.id!}',
              isSaved:
                  context.watch<TvWatchLaterCubit>().isSaved(widget.model!),
              record: widget.model!,
              onTap: (elem) async {
                _runner.run(() async {
                  await context.read<TvWatchLaterCubit>().save(elem);
                });
              },
            ),
            SizedBox(width: 8),
            FABGoHome(),
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
              widget.model!.name!,
              style: Styles.mBold.copyWith(
                fontSize: 20,
                color: Colors.pinkAccent[100],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          GenresOfMovieListWidget(genreIds: widget.model?.genreIds),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: <Widget>[
                Text(
                  DateFormat.yMMMd()
                      .format(DateTime.parse(widget.model!.firstAirDate!)),
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
                      widget.model!.voteAverage.toString(),
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
              widget.model!.overview!,
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
          TvShowCreditsWidget(),
          SizedBox(
            height: 10,
          ),
          TvShowSeasonsWidget(tvShowModel: widget.model!),
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
          SimilarTvShowsWidget(),
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
              'https://image.tmdb.org/t/p/w500${widget.model!.posterPath}',
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
