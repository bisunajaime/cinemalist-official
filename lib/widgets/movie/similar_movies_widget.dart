import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:tmdbflutter/bloc/movies/similar/similar_movies_bloc.dart';
import 'package:tmdbflutter/models/generic_movies_model.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/views/movie_page.dart';

class SimilarMoviesWidget extends StatelessWidget {
  const SimilarMoviesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SimilarMoviesCubit>();
    final movies = cubit.state;
    if (cubit.initialLoading) {
      return CircularProgressIndicator();
    }
    movies!;
    movies.removeWhere((element) => element.posterPath == null);
    return SimilarMoviesList(movies: movies);
  }
}

class SimilarMoviesList extends StatefulWidget {
  final List<GenericMoviesModel> movies;
  const SimilarMoviesList({Key? key, required this.movies}) : super(key: key);

  @override
  State<SimilarMoviesList> createState() => _SimilarMoviesListState();
}

class _SimilarMoviesListState extends State<SimilarMoviesList> {
  final scrollThreshold = 200;

  @override
  Widget build(BuildContext context) {
    final pagedCubit = context.read<SimilarMoviesCubit>();
    return Container(
      height: 250,
      width: double.infinity,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          final maxScroll = notification.metrics.maxScrollExtent;
          final currentScroll = notification.metrics.pixels;
          if (maxScroll - currentScroll <= scrollThreshold) {
            pagedCubit.loadNextPage(onComplete: () {
              if (mounted) {
                setState(() {});
              }
            });
          }
          return true;
        },
        child: ListView.builder(
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: widget.movies.length,
          itemBuilder: (context, i) {
            final movie = widget.movies[i];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MoviePage(
                    model: movie,
                    tag: 'similar${movie.posterPath}',
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: 150,
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: (movie.posterPath == null
                                  ? AssetImage('assets/images/placeholder.png')
                                  : NetworkImage(
                                      'https://image.tmdb.org/t/p/w500${movie.posterPath}'))
                              as ImageProvider<Object>,
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black26,
                            BlendMode.darken,
                          ),
                        ),
                      ),
                      alignment: Alignment.bottomLeft,
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                            cacheManager: DefaultCacheManager(),
                            fit: BoxFit.cover,
                            fadeInCurve: Curves.ease,
                            fadeInDuration: Duration(milliseconds: 250),
                            fadeOutDuration: Duration(milliseconds: 250),
                            fadeOutCurve: Curves.ease,
                            height: double.infinity,
                            width: double.infinity,
                            colorBlendMode: BlendMode.darken,
                            color: Colors.black26,
                          ),
                          Positioned(
                            left: 0,
                            bottom: 0,
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
                                  movie.voteAverage.toString(),
                                  style: Styles.mMed.copyWith(),
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
