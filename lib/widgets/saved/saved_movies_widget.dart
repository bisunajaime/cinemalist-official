import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/bloc/watch_later/watch_later_cubit.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/views/movie_page.dart';

class SavedMoviesWidget extends StatelessWidget {
  const SavedMoviesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<MoviesWatchLaterCubit>();
    final savedMovies = cubit.state;
    if (cubit.state.isEmpty) {
      return Container();
    }
    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: savedMovies.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MoviePage(
                  model: savedMovies[i],
                  tag: 'upcoming${savedMovies[i].posterPath}',
                ),
              ),
            ),
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  color: Colors.grey,
                ),
                child: Stack(
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl:
                          'https://image.tmdb.org/t/p/w500${savedMovies[i].posterPath}',
                      cacheManager: DefaultCacheManager(),
                      fit: BoxFit.cover,
                      fadeInCurve: Curves.ease,
                      fadeInDuration: Duration(milliseconds: 250),
                      fadeOutDuration: Duration(milliseconds: 250),
                      fadeOutCurve: Curves.ease,
                      height: double.infinity,
                      width: double.infinity,
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
                            savedMovies[i].voteAverage.toString(),
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
            ),
          );
        },
      ),
    );
  }
}
