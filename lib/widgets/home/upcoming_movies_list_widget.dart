import 'package:cinemalist/utils/poster_path_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinemalist/barrels/upcoming_movies_barrel.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/views/movie_page.dart';

class UpcomingMoviesListWidget extends StatelessWidget {
  const UpcomingMoviesListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<UpcomingMoviesCubit>();
    final upcomingMovies = cubit.state;
    if (cubit.isLoading) {
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
                baseColor: Color(0xff313131),
                highlightColor: Color(0xff4A4A4A),
              ),
            );
          },
        ),
      );
    }
    upcomingMovies!;
    return Container(
      height: MediaQuery.of(context).size.height * .2,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: upcomingMovies.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          final movie = upcomingMovies[i];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MoviePage(
                  model: movie,
                  tag: 'upcoming${movie.posterPath}',
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
                    Hero(
                      tag: 'upcoming${movie.posterPath}',
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/placeholder_box.png',
                        image: PosterPathHelper.generatePosterPath(
                            movie.posterPath),
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
                            movie.voteAverage.toString(),
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
