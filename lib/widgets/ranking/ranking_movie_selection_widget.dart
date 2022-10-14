import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/bloc/ranking/movie_ranking_cubit.dart';
import 'package:tmdbflutter/bloc/watch_later/watch_later_cubit.dart';
import 'package:tmdbflutter/models/ranking_model.dart';
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
    if (cubit.state.length == rankingCubit.rankedRecordsCount) {
      return DragTarget<RankingModel>(
        onAccept: (data) async {
          final letter =
              RankingHelper.findLetterOfModel(rankingCubit.state, data);
          if (letter == null) return;
          await rankingCubit.removeRanking(letter, data);
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            margin: EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 8,
            ),
            height: 100,
            decoration: BoxDecoration(
              color: Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'Drag here or double tap\nitem to remove',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(.5),
                ),
              ),
            ),
          );
        },
      );
    }
    return DragTarget<RankingModel>(
      onAccept: (data) async {
        final letter =
            RankingHelper.findLetterOfModel(rankingCubit.state, data);
        if (letter == null) return;
        await rankingCubit.removeRanking(letter, data);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          height: 120,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: savedMovies.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i) {
              final movie = savedMovies[i];
              final alreadyRanked = RankingHelper.alreadyRanked(
                movie.id!,
                rankingCubit.state,
              );
              if (alreadyRanked) return Container();
              return Container(
                width: 200,
                height: 50,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff0E0E0E),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    children: [
                      ShaderMask(
                        shaderCallback: (rect) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black,
                              Colors.transparent,
                            ],
                          ).createShader(
                            Rect.fromLTRB(
                              0,
                              0,
                              rect.width,
                              rect.height,
                            ),
                          );
                        },
                        blendMode: BlendMode.dstIn,
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
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            width: 200,
                            child: Text(
                              movie.title!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Draggable<RankingModel>(
                          data: RankingModel.fromGenericMovieModel(movie),
                          feedback: Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1),
                              color: Colors.grey,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
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
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.menu,
                              color: Colors.pinkAccent,
                              size: 18,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
