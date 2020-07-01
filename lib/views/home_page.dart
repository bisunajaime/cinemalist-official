import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/barrels/genres_barrel.dart';
import 'package:tmdbflutter/barrels/popular_barrel.dart';
import 'package:tmdbflutter/bloc/actors/actors_bloc.dart';
import 'package:tmdbflutter/bloc/actors/actors_event.dart';
import 'package:tmdbflutter/bloc/actors/actors_state.dart';
import 'package:tmdbflutter/bloc/popular/popular_bloc.dart';
import 'package:tmdbflutter/bloc/popular/popular_state.dart';
import 'package:tmdbflutter/bloc/trending/trending_bloc.dart';
import 'package:tmdbflutter/bloc/trending/trending_event.dart';
import 'package:tmdbflutter/bloc/trending/trending_state.dart';
import 'package:tmdbflutter/bloc/upcoming/upcoming_bloc.dart';
import 'package:tmdbflutter/bloc/upcoming/upcoming_event.dart';
import 'package:tmdbflutter/bloc/upcoming/upcoming_state.dart';
import 'package:tmdbflutter/views/movie_page.dart';

import '../barrels/popular_barrel.dart';
import '../barrels/upcoming_barrel.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Image.asset(
          'assets/images/logo.png',
          height: 20,
        ),
        SizedBox(
          height: 10,
        ),
        buildPopularList(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Genres',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'See more',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        buildGenresList(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Upcoming',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'See more',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        buildUpcomingList(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Trending',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'See more',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        buildTrendingList(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Actors',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'See more',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        buildActorsList(),
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
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 1,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.redAccent[700],
                        Colors.pinkAccent[700],
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
                      state.genres[i].name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
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
                  baseColor: Colors.grey,
                  highlightColor: Colors.grey[400],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

BlocBuilder<ActorsBloc, ActorState> buildActorsList() {
  return BlocBuilder<ActorsBloc, ActorState>(
    builder: (context, state) {
      if (state is ActorEmpty) {
        BlocProvider.of<ActorsBloc>(context).add(FetchActors());
      }
      if (state is UpcomingError) {
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://image.tmdb.org/t/p/w500${state.actors[i].profilePath}'),
                      radius: 35,
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    Text(
                      state.actors[i].name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
          itemCount: 4,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: CircleAvatar(
                radius: 35,
                backgroundColor: Colors.grey,
                child: Shimmer.fromColors(
                  child: Container(),
                  baseColor: Colors.grey,
                  highlightColor: Colors.grey[400],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

BlocBuilder<UpcomingsBloc, UpcomingState> buildUpcomingList() {
  return BlocBuilder<UpcomingsBloc, UpcomingState>(
    builder: (context, state) {
      if (state is UpcomingEmpty) {
        BlocProvider.of<UpcomingsBloc>(context).add(FetchUpcomingMovies());
      }

      if (state is UpcomingError) {
        return Center(
          child: Text('Failed to load genres'),
        );
      }

      if (state is UpcomingLoaded) {
        return Container(
          height: MediaQuery.of(context).size.height * .2,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: state.upcomingMovies.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i) {
              return Container(
                height: double.infinity,
                width: 90,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  color: Colors.grey,
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                      Colors.black26,
                      BlendMode.darken,
                    ),
                    image: NetworkImage(
                      'https://image.tmdb.org/t/p/w500${state.upcomingMovies[i].posterPath}',
                    ),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 12,
                            ),
                            Text(
                              state.upcomingMovies[i].voteAverage.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
                baseColor: Colors.grey,
                highlightColor: Colors.grey[400],
              ),
            );
          },
        ),
      );
    },
  );
}

BlocBuilder<PopularsBloc, PopularState> buildPopularList() {
  return BlocBuilder<PopularsBloc, PopularState>(
    builder: (context, state) {
      if (state is PopularEmpty) {
        BlocProvider.of<PopularsBloc>(context).add(FetchPopularMovies());
      }

      if (state is PopularError) {
        return Center(
          child: Text('Failed to load genres'),
        );
      }

      if (state is PopularLoaded) {
        return Container(
          height: MediaQuery.of(context).size.height * .6,
          width: MediaQuery.of(context).size.width,
          child: CarouselSlider.builder(
            itemCount: state.popularMovies.length,
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MoviePage(
                      model: state.popularMovies[i],
                    ),
                  ),
                ),
                child: Container(
                  height: double.infinity,
                  child: Stack(
                    children: <Widget>[
                      Hero(
                        tag: state.popularMovies[i].posterPath,
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500${state.popularMovies[i].posterPath}',
                          fit: BoxFit.cover,
                          colorBlendMode: BlendMode.darken,
                          color: Colors.black12,
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
                              size: 20,
                            ),
                            Text(
                              state.popularMovies[i].voteAverage.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20,
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
            options: CarouselOptions(
              autoPlay: true,
              height: double.infinity,
              autoPlayCurve: Curves.easeInOutCirc,
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              enlargeStrategy: CenterPageEnlargeStrategy.scale,
              pauseAutoPlayOnTouch: true,
            ),
          ),
        );
      }
      return Container(
        height: MediaQuery.of(context).size.height * .5,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: 6,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, i) {
            return Container(
              height: double.infinity,
              width: 200,
              margin: EdgeInsets.all(5),
              color: Colors.grey,
              child: Shimmer.fromColors(
                child: Container(
                  color: Colors.white,
                ),
                baseColor: Colors.grey,
                highlightColor: Colors.grey[400],
              ),
            );
          },
        ),
      );
    },
  );
}

BlocBuilder<TrendingBloc, TrendingState> buildTrendingList() {
  return BlocBuilder<TrendingBloc, TrendingState>(
    builder: (context, state) {
      if (state is TrendingEmpty) {
        BlocProvider.of<TrendingBloc>(context).add(FetchTrendingMovies());
      }

      if (state is TrendingError) {
        return Center(
          child: Text('Failed to load genres'),
        );
      }

      if (state is TrendingLoaded) {
        return Container(
          height: MediaQuery.of(context).size.height * .4,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: state.trendingMovies.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i) {
              return Container(
                height: double.infinity,
                width: 150,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  color: Colors.grey,
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                      Colors.black26,
                      BlendMode.darken,
                    ),
                    image: NetworkImage(
                      'https://image.tmdb.org/t/p/w500${state.trendingMovies[i].posterPath}',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 12,
                            ),
                            Text(
                              state.trendingMovies[i].voteAverage.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
                baseColor: Colors.grey,
                highlightColor: Colors.grey[400],
              ),
            );
          },
        ),
      );
    },
  );
}
