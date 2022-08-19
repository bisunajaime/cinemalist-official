import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/bloc/movies/byGenre/moviesbygenre_bloc.dart';
import 'package:tmdbflutter/models/generic_movies_model.dart';
import 'package:tmdbflutter/repository/tmdb_api_client.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:http/http.dart' as http;
import 'movie_page.dart';

class GenresPage extends StatefulWidget {
  final int? id;
  final String? genre;
  GenresPage({this.id, this.genre});
  @override
  _GenresPageState createState() => _GenresPageState();
}

class _GenresPageState extends State<GenresPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TMDBRepository tmdbRepo = TMDBRepository(
      tmdbApiClient: TMDBApiClient(
        httpClient: http.Client(),
      ),
    );
    return BlocProvider<MovieByGenreBloc>(
      create: (context) => MovieByGenreBloc(tmdbRepository: tmdbRepo),
      child: Scaffold(
        backgroundColor: Color(0xff0E0E0E),
        appBar: AppBar(
          title: Text(
            widget.genre!,
            style: Styles.mReg.copyWith(
              color: Colors.pinkAccent[100],
            ),
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
        ),
        body: buildMoviesByGenre(),
      ),
    );
  }

  BlocBuilder<MovieByGenreBloc, MovieByGenreState> buildMoviesByGenre() {
    return BlocBuilder<MovieByGenreBloc, MovieByGenreState>(
      builder: (context, state) {
        if (state is MovieByGenreInitial) {
          BlocProvider.of<MovieByGenreBloc>(context)
              .add(FetchMovieByGenreMovies(id: widget.id));
        }
        if (state is MovieByGenreFailed) {
          return Center(child: Text('Failed'));
        }

        if (state is MovieByGenreSuccess) {
          if (state.movieByGenreMovies!.isEmpty) {
            return Center(
              child: Text('None'),
            );
          }
          return Scrollbar(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: NotificationListener<ScrollEndNotification>(
                onNotification: (scroll) {
                  final scrollThreshold = 200;
                  final maxScroll = scroll.metrics.maxScrollExtent;
                  final currentScroll = scroll.metrics.pixels;
                  if (maxScroll - currentScroll <= scrollThreshold) {
                    BlocProvider.of<MovieByGenreBloc>(context)
                        .add(FetchMovieByGenreMovies(id: widget.id));
                    return true;
                  } else {
                    return false;
                  }
                },
                child: GridView.builder(
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: state.hasReachedMax!
                      ? state.movieByGenreMovies!.length
                      : state.movieByGenreMovies!.length + 1,
                  itemBuilder: (context, i) {
                    return i >= state.movieByGenreMovies!.length
                        ? Shimmer.fromColors(
                            child: Container(
                              color: Color(0xff232323),
                            ),
                            baseColor: Color(0xff313131),
                            highlightColor: Color(0xff4A4A4A),
                          )
                        : buildNowShowingMovies(
                            context, state.movieByGenreMovies![i]);
                  },
                ),
              ),
            ),
          );
        }
        return Center(
            child: CircularProgressIndicator(
          backgroundColor: Colors.pinkAccent[100],
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xff0E0E0E)),
        ));
      },
    );
  }

  GestureDetector buildNowShowingMovies(
      BuildContext context, GenericMoviesModel movies) {
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
  }
}
