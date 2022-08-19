import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/models/generic_movies_model.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/views/actor_info_page.dart';
import 'package:tmdbflutter/views/genres_page.dart';
import 'package:tmdbflutter/views/movie_page.dart';
import 'package:tmdbflutter/widgets/home/popular_movies_widget.dart';

import '../barrels/genres_barrel.dart';
import '../barrels/actors_barrel.dart';
import 'package:tmdbflutter/barrels/popular_movies_barrel.dart';
import 'package:tmdbflutter/barrels/trending_movies_barrel.dart';
import 'package:tmdbflutter/barrels/upcoming_movies_barrel.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        PopularMoviesWidget(),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Text(
        //     'Genres',
        //     style: Styles.mBold,
        //   ),
        // ),
        // buildGenresList(),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: <Widget>[
        //       Text(
        //         'Upcoming',
        //         style: Styles.mBold,
        //       ),
        //       Text(
        //         'See more',
        //         style: Styles.mReg.copyWith(
        //           color: Colors.pinkAccent,
        //           fontSize: 10,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // buildUpcomingList(),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: <Widget>[
        //       Text(
        //         'Actors',
        //         style: Styles.mBold,
        //       ),
        //       Text(
        //         'See more',
        //         style: Styles.mReg.copyWith(
        //           color: Colors.pinkAccent,
        //           fontSize: 10,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // buildActorsList(),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: <Widget>[
        //       Text(
        //         'Trending',
        //         style: Styles.mBold,
        //       ),
        //       Text(
        //         'See more',
        //         style: Styles.mReg.copyWith(
        //           color: Colors.pinkAccent,
        //           fontSize: 10,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // buildTrendingList(),
      ],
    );
  }

  BlocBuilder<GenresBloc, GenresState> buildGenresList() {
    return BlocBuilder<GenresBloc, GenresState>(
      builder: (context, state) {
        if (state is GenresEmpty) {
          BlocProvider.of<GenresBloc>(context).add(FetchGenres());
        }

        if (state is GenresError) {
          return Center(
            child: Text('Failed to load genres'),
          );
        }

        if (state is GenresLoaded) {
          return Container(
            height: MediaQuery.of(context).size.height * .05,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: state.genres.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GenresPage(
                        id: state.genres[i].id,
                        genre: state.genres[i].name,
                      ),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 1,
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.pinkAccent[400]!,
                          Colors.redAccent,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pinkAccent,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        state.genres[i].name!,
                        style: Styles.mBold.copyWith(
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }

        return Container(
          height: MediaQuery.of(context).size.height * .05,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: 6,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i) {
              return Container(
                height: double.infinity,
                width: 50,
                color: Colors.grey,
                margin: EdgeInsets.symmetric(horizontal: 2),
                child: Shimmer.fromColors(
                  child: Container(
                    color: Colors.white,
                  ),
                  baseColor: Color(0xff313131),
                  highlightColor: Color(0xff4A4A4A),
                ),
              );
            },
          ),
        );
      },
    );
  }

  BlocBuilder<ActorsBloc, ActorState> buildActorsList() {
    return BlocBuilder<ActorsBloc, ActorState>(
      builder: (context, state) {
        if (state is ActorEmpty) {
          BlocProvider.of<ActorsBloc>(context).add(FetchActors());
        }
        if (state is ActorError) {
          return Center(
            child: Text('Failed to load actors'),
          );
        }
        if (state is ActorLoaded) {
          return Container(
            height: 100,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.actors.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActorInfoPage(
                          id: state.actors[i].id,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Color(0xff2e2e2e),
                          backgroundImage:
                              NetworkImage(state.actors[i].profilePath!),
                          radius: 35,
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Text(
                          state.actors[i].name!,
                          style: Styles.mMed.copyWith(
                            fontSize: 8,
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
          height: 100,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.grey,
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
    );
  }

  BlocBuilder<UpcomingMoviesBloc, UpcomingMoviesState> buildUpcomingList() {
    return BlocBuilder<UpcomingMoviesBloc, UpcomingMoviesState>(
      builder: (context, state) {
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
          return Container(
            height: MediaQuery.of(context).size.height * .2,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: state.upcomingMovies.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MoviePage(
                        model: state.upcomingMovies[i],
                        tag: 'upcoming${state.upcomingMovies[i].posterPath}',
                      ),
                    ),
                  ),
                  child: Container(
                    height: double.infinity,
                    width: 90,
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1),
                      color: Colors.grey,
                    ),
                    child: Stack(
                      children: <Widget>[
                        Hero(
                          tag: 'upcoming${state.upcomingMovies[i].posterPath}',
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/placeholder_box.png',
                            image:
                                'https://image.tmdb.org/t/p/w500${state.upcomingMovies[i].posterPath}',
                            fit: BoxFit.cover,
                            fadeInCurve: Curves.ease,
                            fadeInDuration: Duration(milliseconds: 250),
                            fadeOutDuration: Duration(milliseconds: 250),
                            fadeOutCurve: Curves.ease,
                            height: double.infinity,
                            width: double.infinity,
                          ),
                        ),
                        Positioned(
                          bottom: 2,
                          left: 2,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 10,
                              ),
                              Text(
                                state.upcomingMovies[i].voteAverage.toString(),
                                style: Styles.mBold.copyWith(
                                  fontSize: 10,
                                ),
                              ),
                            ],
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
          height: MediaQuery.of(context).size.height * .2,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: 6,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i) {
              return Container(
                height: double.infinity,
                width: 90,
                margin: EdgeInsets.all(5),
                color: Colors.grey,
                child: Shimmer.fromColors(
                  child: Container(
                    color: Colors.white,
                  ),
                  baseColor: Color(0xff313131),
                  highlightColor: Color(0xff4A4A4A),
                ),
              );
            },
          ),
        );
      },
    );
  }

  BlocBuilder<TrendingMoviesBloc, TrendingMoviesState> buildTrendingList() {
    return BlocBuilder<TrendingMoviesBloc, TrendingMoviesState>(
      builder: (context, state) {
        if (state is TrendingMoviesEmpty) {
          BlocProvider.of<TrendingMoviesBloc>(context)
              .add(FetchTrendingMovies());
        }

        if (state is TrendingMoviesError) {
          return Center(
            child: Text('Failed to load trending'),
          );
        }

        if (state is TrendingMoviesLoaded) {
          return Container(
            height: MediaQuery.of(context).size.height * .4,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: state.trendingMovies.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MoviePage(
                        model: state.trendingMovies[i],
                        tag: 'trending${state.trendingMovies[i].posterPath}',
                      ),
                    ),
                  ),
                  child: Container(
                    height: double.infinity,
                    width: 180,
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1),
                      color: Color(0xff0e0e0e),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Hero(
                          tag: 'trending${state.trendingMovies[i].posterPath}',
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/placeholder_box.png',
                            image:
                                'https://image.tmdb.org/t/p/w500${state.trendingMovies[i].posterPath}',
                            fadeInCurve: Curves.ease,
                            fadeInDuration: Duration(milliseconds: 250),
                            fadeOutDuration: Duration(milliseconds: 250),
                            fadeOutCurve: Curves.ease,
                            height: double.infinity,
                            width: double.infinity,
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          left: 5,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 12,
                              ),
                              Text(
                                state.trendingMovies[i].voteAverage.toString(),
                                style: Styles.mBold.copyWith(
                                  fontSize: 12,
                                ),
                              ),
                            ],
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
          height: MediaQuery.of(context).size.height * .35,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: 6,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i) {
              return Container(
                height: double.infinity,
                width: 150,
                margin: EdgeInsets.all(5),
                color: Colors.grey,
                child: Shimmer.fromColors(
                  child: Container(
                    color: Colors.white,
                  ),
                  baseColor: Color(0xff313131),
                  highlightColor: Color(0xff4A4A4A),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
