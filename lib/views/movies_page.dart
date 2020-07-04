import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/barrels/nowplaying_movies_barrel.dart';
import 'package:tmdbflutter/views/movie_page.dart';

class MoviesPage extends StatefulWidget {
  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController controller = new ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final nowPlayingMovBloc = BlocProvider.of<NowPlayingMoviesBloc>(context);
    controller.addListener(() {
      if (nowPlayingMovBloc.initialPage < 25) {
        if (controller.position.atEdge) {
          nowPlayingMovBloc.add(LoadNextPage());
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Now Showing',
                style: Styles.mBold.copyWith(
                  fontSize: 30,
                ),
              ),
              Text('MOVIES',
                  style: Styles.mBold.copyWith(
                    color: Colors.pinkAccent,
                  )),
            ],
          ),
        ),
        Expanded(
          child: Container(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 1));
                nowPlayingMovBloc.add(FetchNowPlayingMovies());
              },
              child: buildNowPlaying(),
            ),
          ),
        ),
      ],
    );
  }

  BlocBuilder<NowPlayingMoviesBloc, NowPlayingMoviesState> buildNowPlaying() {
    return BlocBuilder<NowPlayingMoviesBloc, NowPlayingMoviesState>(
      builder: (context, state) {
        if (state is NowPlayingMoviesEmpty) {
          BlocProvider.of<NowPlayingMoviesBloc>(context)
              .add(FetchNowPlayingMovies());
        }

        if (state is NowPlayingMoviesError) {
          return Center(
            child: Text('Failed to load genres'),
          );
        }

        if (state is NowPlayingMoviesLoaded) {
          return GridView(
            controller: controller,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
              childAspectRatio: 0.7,
            ),
            children: List.generate(state.nowPlayingMovies.length + 1, (i) {
              if (i == state.nowPlayingMovies.length) {
                return Shimmer.fromColors(
                  child: Container(
                    color: Color(0xff232323),
                  ),
                  baseColor: Color(0xff313131),
                  highlightColor: Color(0xff4A4A4A),
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
              baseColor: Color(0xff232323),
              highlightColor: Color(0xff222222),
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
