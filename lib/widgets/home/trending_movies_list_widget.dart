import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/barrels/trending_movies_barrel.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/views/movie_page.dart';

class TrendingMoviesListWidget extends StatelessWidget {
  const TrendingMoviesListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TrendingMoviesCubit>();
    final trendingMovies = cubit.state;
    if (cubit.isLoading) {
      return Container(
        height: MediaQuery.of(context).size.height * .4,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: 6,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, i) {
            return Container(
              height: double.infinity,
              width: 150,
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
    if (cubit.error) {
      return Text('todo error');
    }
    trendingMovies!;
    return Container(
      height: MediaQuery.of(context).size.height * .4,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: trendingMovies.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MoviePage(
                  model: trendingMovies[i],
                  tag: 'trending${trendingMovies[i].posterPath}',
                ),
              ),
            ),
            child: Container(
              height: double.infinity,
              width: 180,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1),
                color: Color(0xff0e0e0e),
              ),
              child: Stack(
                children: <Widget>[
                  Hero(
                    tag: 'trending${trendingMovies[i].posterPath}',
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/placeholder_box.png',
                      image:
                          'https://image.tmdb.org/t/p/w500${trendingMovies[i].posterPath}',
                      fadeInCurve: Curves.ease,
                      fadeInDuration: Duration(milliseconds: 250),
                      fadeOutDuration: Duration(milliseconds: 250),
                      fadeOutCurve: Curves.ease,
                      height: double.infinity,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    left: 5,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 12,
                        ),
                        Text(
                          trendingMovies[i].voteAverage.toString(),
                          style: Styles.mBold.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
