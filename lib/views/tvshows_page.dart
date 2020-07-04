import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'package:tmdbflutter/bloc/tvshows/popular/popular_tvshows_bloc.dart';
import 'package:tmdbflutter/bloc/tvshows/popular/popular_tvshows_event.dart';
import 'package:tmdbflutter/bloc/tvshows/popular/popular_tvshows_state.dart';
import 'package:tmdbflutter/models/tvshow_model.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/views/tvshow_page.dart';

class TvShowsPage extends StatefulWidget {
  @override
  _TvShowsPageState createState() => _TvShowsPageState();
}

class _TvShowsPageState extends State<TvShowsPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController controller = new ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final popularTvBloc = BlocProvider.of<PopularTvShowsBloc>(context);
    controller.addListener(() {
      if (popularTvBloc.initialPage < 25) {
        if (controller.position.atEdge) {
          popularTvBloc.add(LoadNextPage());
          setState(() {});
        }
      }
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            top: 30,
            left: 10,
            bottom: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Popular',
                    style: Styles.mBold.copyWith(
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    'TV SHOWS',
                    style: Styles.mBold.copyWith(
                      color: Colors.pinkAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 1));
                popularTvBloc.add(FetchPopularTvShows());
              },
              child: buildNowPlaying(),
            ),
          ),
        ),
      ],
    );
  }

  BlocBuilder<PopularTvShowsBloc, PopularTvShowsState> buildNowPlaying() {
    return BlocBuilder<PopularTvShowsBloc, PopularTvShowsState>(
      builder: (context, state) {
        if (state is PopularTvShowsEmpty) {
          BlocProvider.of<PopularTvShowsBloc>(context)
              .add(FetchPopularTvShows());
        }

        if (state is PopularTvShowsError) {
          return Center(
            child: Text('Failed to load genres'),
          );
        }

        if (state is PopularTvShowsLoaded) {
          return GridView(
            controller: controller,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
              childAspectRatio: 0.7,
            ),
            children: List.generate(state.popularTvShows.length + 1, (i) {
              if (i == state.popularTvShows.length) {
                return Shimmer.fromColors(
                  child: Container(
                    color: Color(0xff232323),
                  ),
                  baseColor: Color(0xff313131),
                  highlightColor: Color(0xff4A4A4A),
                );
              }
              TVShowModel tvShows = state.popularTvShows[i];
              return GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TvShowPage(
                        model: tvShows,
                      ),
                    )),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff232323),
                    image: DecorationImage(
                      image: NetworkImage(
                        tvShows.posterPath != null
                            ? 'https://image.tmdb.org/t/p/w500${tvShows.posterPath}'
                            : 'https://via.placeholder.com/400',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }),
          );
        }
        return GridView.builder(
          itemCount: 7,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, i) {
            return Shimmer.fromColors(
              child: Container(color: Colors.black),
              baseColor: Color(0xff313131),
              highlightColor: Color(0xff4A4A4A),
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

/*
if (state is UpcomingMoviesEmpty) {
          BlocProvider.of<UpcomingMoviesBloc>(context)
              .add(FetchUpcomingMovies());
        }

        if (state is UpcomingMoviesError) {
          return Center(
            child: Text('Failed to load genres'),
          );
        }

        if (state is UpcomingMoviesLoaded) {


 */

/*
return GridView.builder(
            itemCount: state.nowPlayingMovies.length + 1,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
              childAspectRatio: 0.7,
            ),
            cacheExtent: 1000,
            itemBuilder: (context, i) {
              if (i == state.nowPlayingMovies.length) {
                return Shimmer.fromColors(
                  child: Container(
                    color: Color(0xff232323),
                  ),
                  baseColor: Color(0xff232323),
                  highlightColor: Color(0xff222222),
                );
              }
              GenericMoviesModel movies = state.nowPlayingMovies[i];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MoviePage(
                      tag: 'nowplaying${movies.posterPath}',
                      model: movies,
                    ),
                  ),
                ),
                child: AnimatedOpacity(
                  opacity: 1.0,
                  duration: Duration(
                    milliseconds: 250,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff232323),
                      image: DecorationImage(
                        image: NetworkImage(
                          movies.posterPath != null
                              ? 'https://image.tmdb.org/t/p/w500${movies.posterPath}'
                              : 'https://via.placeholder.com/400',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          );

 */
