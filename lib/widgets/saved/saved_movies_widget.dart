import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cinemalist/bloc/ranking/movie_ranking_cubit.dart';
import 'package:cinemalist/bloc/watch_later/watch_later_cubit.dart';
import 'package:cinemalist/models/ranking_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/utils/delayed_runner.dart';
import 'package:cinemalist/views/movie_page.dart';
import 'package:cinemalist/widgets/dialogs/dialogs.dart';

final _runner = DelayedRunner(milliseconds: 250);

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
          return Stack(
            children: [
              AspectRatio(
                aspectRatio: 2 / 3,
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MoviePage(
                        model: savedMovies[i],
                        tag: 'upcoming${savedMovies[i].posterPath}',
                      ),
                    ),
                  ),
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
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (context) => ShowRemoveConfirmationDialog(
                        type: savedMovies[i].title!,
                      ),
                    );
                    if (result != true) return;
                    _runner.run(() async {
                      final rankingCubit = context.read<MovieRankingCubit>();
                      await rankingCubit.removeRankingWithoutLetter(
                          RankingModel.fromGenericMovieModel(savedMovies[i]));
                      await cubit.save(savedMovies[i]);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    margin: EdgeInsets.only(
                      right: 8,
                      bottom: 8,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.pinkAccent,
                    ),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
