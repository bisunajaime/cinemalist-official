import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/barrels/nowplaying_movies_barrel.dart';
import 'package:tmdbflutter/views/movie_page.dart';

class MoviesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 50,
            ),
            child: Text(
              'Now Playing',
              style: Styles.mBold.copyWith(
                fontSize: 30,
                letterSpacing: .5,
              ),
            ),
          ),
          buildNowPlaying(),
        ],
      ),
    );
  }
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
        return GridView.builder(
          itemCount: state.nowPlayingMovies.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, i) {
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
                color: Color(0xff232323),
                child: Stack(
                  children: <Widget>[
                    Hero(
                      tag: 'nowplaying${movies.posterPath}',
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500${movies.posterPath}',
                        color: Colors.black26,
                        colorBlendMode: BlendMode.darken,
                        fit: BoxFit.fitWidth,
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
      return Text('Shimmer');
    },
  );
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
