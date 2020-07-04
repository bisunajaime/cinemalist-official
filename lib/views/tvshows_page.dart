import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/bloc/tvshows/trending/populartvshows_bloc.dart';
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
  final scrollThreshold = 200;
  PopularTvShowsBloc _popularTvShowsBloc;

  @override
  void initState() {
    super.initState();
    controller.addListener(_onScroll);
    _popularTvShowsBloc = BlocProvider.of<PopularTvShowsBloc>(context);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _onScroll() {
    final maxScroll = controller.position.maxScrollExtent;
    final currentScroll = controller.position.pixels;
    if (maxScroll - currentScroll <= scrollThreshold) {
      _popularTvShowsBloc.add(FetchPopularTvShows());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Column(
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
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: Container(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 1));
                _popularTvShowsBloc.add(FetchPopularTvShows());
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
        if (state is PopularTvShowsInitial) {
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
        }

        if (state is PopularTvShowsFailed) {
          return Center(
            child: Text('Failed to load tvshows'),
          );
        }

        if (state is PopularTvShowsSuccess) {
          return Scrollbar(
            child: GridView.builder(
              controller: controller,
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
                childAspectRatio: 0.7,
              ),
              itemCount: state.hasReachedMax
                  ? state.tvShowModel.length
                  : state.tvShowModel.length + 1,
              itemBuilder: (context, i) {
                return i >= state.tvShowModel.length
                    ? Shimmer.fromColors(
                        child: Container(
                          color: Color(0xff232323),
                        ),
                        baseColor: Color(0xff313131),
                        highlightColor: Color(0xff4A4A4A),
                      )
                    : GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TvShowPage(
                                model: state.tvShowModel[i],
                              ),
                            )),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xff232323),
                            image: DecorationImage(
                              image: NetworkImage(
                                state.tvShowModel[i].posterPath != null
                                    ? 'https://image.tmdb.org/t/p/w500${state.tvShowModel[i].posterPath}'
                                    : 'https://via.placeholder.com/400',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
              },
            ),
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
