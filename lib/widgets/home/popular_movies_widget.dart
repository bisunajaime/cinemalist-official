import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinemalist/barrels/popular_movies_barrel.dart';
import 'package:cinemalist/models/generic_movies_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/views/movie_page.dart';

class PopularMoviesWidget extends StatefulWidget {
  const PopularMoviesWidget({Key? key}) : super(key: key);

  @override
  State<PopularMoviesWidget> createState() => _PopularMoviesWidgetState();
}

class _PopularMoviesWidgetState extends State<PopularMoviesWidget> {
  int index = 0;
  PageController smallPage =
      PageController(initialPage: 0, viewportFraction: 0.18);
  PageController pageController = PageController(
    initialPage: 0,
  );
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<PopularMoviesCubit>();
    final popularMovies = cubit.state;
    if (cubit.isLoading) {
      return Container(
        height: MediaQuery.of(context).size.height * .6,
        width: MediaQuery.of(context).size.width,
        child: Container(
          height: double.infinity,
          child: Shimmer.fromColors(
            child: Container(
              color: Colors.white,
            ),
            baseColor: Color(0xff313131),
            highlightColor: Color(0xff4A4A4A),
          ),
        ),
      );
    }
    if (cubit.error) {
      return Text('there was a problem');
    }
    popularMovies!;
    return Container(
      height: MediaQuery.of(context).size.height * .8,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: PageView.builder(
              itemCount: popularMovies.length,
              scrollDirection: Axis.horizontal,
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (int i) {
                // smallPage.animateToPage(i,
                //     duration: Duration(milliseconds: 250),
                //     curve: Curves.ease);
                setState(() {
                  index = i;
                });
              },
              itemBuilder: (context, i) {
                GenericMoviesModel movie = popularMovies[i];
                return Stack(
                  children: <Widget>[
                    ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xff0E0E0E),
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
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xff0E0E0E),
                        ),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/placeholder_box.png',
                          image:
                              "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Text(
                                movie.title!,
                                style: Styles.mMed.copyWith(
                                  color: Colors.pinkAccent[100],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Row(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.calendar_today,
                                        color: Colors.amber,
                                        size: 10,
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        DateFormat.yMMMd().format(
                                            DateTime.parse(movie.releaseDate!)),
                                        style: Styles.mMed.copyWith(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    child: Text(
                                      ' - ',
                                      style: Styles.mBold,
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 10,
                                      ),
                                      Text(
                                        movie.voteAverage.toString(),
                                        style: Styles.mMed.copyWith(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Text(
                                movie.overview!,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Styles.mReg.copyWith(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MoviePage(
                                            model: movie,
                                            tag: 'popular${movie.posterPath}',
                                          ))),
                              child: Text(
                                'Details',
                                style: Styles.mBold.copyWith(
                                  fontSize: 10,
                                  color: Colors.pinkAccent[100],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          Container(
            height: 80,
            child: PageView.builder(
              controller: smallPage,
              itemCount: popularMovies.length,
              scrollDirection: Axis.horizontal,
              onPageChanged: (i) {
                pageController.animateToPage(
                  i,
                  duration: Duration(milliseconds: 250),
                  curve: Curves.ease,
                );
              },
              itemBuilder: (context, i) {
                GenericMoviesModel movie = popularMovies[i];
                return GestureDetector(
                  onTap: () {
                    pageController.jumpToPage(i);
                    smallPage.jumpToPage(i);
                    setState(() {
                      index = i;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        index == i
                            ? Colors.transparent
                            : Colors.black.withOpacity(0.5),
                        index == i ? BlendMode.lighten : BlendMode.darken,
                      ),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/placeholder_box.png',
                        image:
                            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
