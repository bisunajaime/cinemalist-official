import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/bloc/ranking/ranking_cubit.dart';
import 'package:tmdbflutter/bloc/watch_later/watch_later_cubit.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/utils/delayed_runner.dart';
import 'package:tmdbflutter/views/movie_page.dart';
import 'package:tmdbflutter/widgets/dialogs/dialogs.dart';

final _runner = DelayedRunner(milliseconds: 250);

class RankingMovieSelectionWidget extends StatelessWidget {
  const RankingMovieSelectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<MoviesWatchLaterCubit>();
    final rankingCubit = context.watch<MovieRankingCubit>();
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
          final movie = savedMovies[i];
          final alreadyRanked = MovieRankingHelper.movieAlreadyRanked(
            movie.id!,
            rankingCubit.state,
          );
          if (alreadyRanked) return Container();
          return Draggable<GenericMoviesModel>(
            data: movie,
            feedback: Container(
              height: 200,
              width: 100,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1),
                color: Colors.grey,
              ),
              child: CachedNetworkImage(
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
            ),
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  color: Colors.grey,
                ),
                child: CachedNetworkImage(
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
              ),
            ),
          );
        },
      ),
    );
  }
}
