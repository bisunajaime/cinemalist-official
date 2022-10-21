import 'package:cinemalist/utils/poster_path_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinemalist/bloc/actors/actor_movies_cubit.dart';
import 'package:cinemalist/models/generic_movies_model.dart';
import 'package:cinemalist/views/movie_page.dart';

class ActorMoviesWidget extends StatefulWidget {
  const ActorMoviesWidget({Key? key}) : super(key: key);

  @override
  State<ActorMoviesWidget> createState() => _ActorMoviesWidgetState();
}

class _ActorMoviesWidgetState extends State<ActorMoviesWidget> {
  final scrollThreshold = 200;
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ActorMoviesCubit>();
    final actorMovies = cubit.state;
    if (cubit.loading) {
      return Shimmer.fromColors(
        child: Container(
          color: Color(0xff232323),
          margin: EdgeInsets.all(5),
        ),
        baseColor: Color(0xff313131),
        highlightColor: Color(0xff4A4A4A),
      );
    }
    if (cubit.error) {
      return Text('Refresh');
    }
    actorMovies!;
    return Container(
      height: 250,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          final maxScroll = notification.metrics.maxScrollExtent;
          final currentScroll = notification.metrics.pixels;
          if (maxScroll - currentScroll <= scrollThreshold) {
            if (cubit.hasReachedMax) return true;
            cubit.loadNextPage(onComplete: () {
              if (mounted) {
                setState(() {});
              }
            });
          }
          return true;
        },
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: actorMovies.length,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, i) {
            GenericMoviesModel movie = actorMovies[i];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MoviePage(
                    model: movie,
                    tag: 'actor${movie.posterPath}',
                  ),
                ),
              ),
              child: AspectRatio(
                aspectRatio: 2 / 3,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  child: movie.posterPath == null
                      ? Image.asset('assets/images/placeholder.png')
                      : Image.network(
                          PosterPathHelper.generatePosterPath(movie.posterPath),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
