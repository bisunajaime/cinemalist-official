import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/barrels/genres_barrel.dart';
import 'package:tmdbflutter/barrels/popular_barrel.dart';
import 'package:tmdbflutter/bloc/popular/popular_bloc.dart';
import 'package:tmdbflutter/bloc/popular/popular_state.dart';
import 'package:tmdbflutter/bloc/upcoming/upcoming_bloc.dart';
import 'package:tmdbflutter/bloc/upcoming/upcoming_event.dart';
import 'package:tmdbflutter/bloc/upcoming/upcoming_state.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Popular',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
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
          height: MediaQuery.of(context).size.height * .35,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: state.popularMovies.length,
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
                      'https://image.tmdb.org/t/p/w500${state.popularMovies[i].posterPath}',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Text(
                          state.popularMovies[i].title,
                          maxLines: 4,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ),
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
                              state.popularMovies[i].voteAverage.toString(),
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
