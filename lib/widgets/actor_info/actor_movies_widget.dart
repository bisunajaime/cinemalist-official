import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/bloc/actors/actor_movies_cubit.dart';
import 'package:tmdbflutter/models/generic_movies_model.dart';
import 'package:tmdbflutter/views/movie_page.dart';

class ActorMoviesWidget extends StatelessWidget {
  const ActorMoviesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ActorMoviesCubit>();
    final actorMovies = cubit.state;
    if (cubit.isLoading) {
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
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: actorMovies.length,
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
          child: Container(
            height: double.infinity,
            width: 150,
            margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            child: movie.posterPath == null
                ? Image.asset('assets/images/placeholder.png')
                : Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    fit: BoxFit.cover,
                  ),
          ),
        );
      },
    );
  }
}
