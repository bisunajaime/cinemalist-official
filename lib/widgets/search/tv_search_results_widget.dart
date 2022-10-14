import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinemalist/bloc/search/search_cubit.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/views/tvshow_page.dart';

class TvSearchResultsWidget extends StatelessWidget {
  const TvSearchResultsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SearchCubit>();
    final tvShows = cubit.tvResults;
    if (cubit.loading) {
      return Container(
        height: 150,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 9,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                color: Colors.grey,
                height: double.infinity,
                child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: Shimmer.fromColors(
                    child: Container(),
                    baseColor: Colors.red,
                    highlightColor: Colors.blue,
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
    if (cubit.didSearch && tvShows?.isEmpty == true) {
      return Container();
    }
    tvShows!;
    tvShows.removeWhere((element) => element.posterPath == null);
    return Container(
      height: MediaQuery.of(context).size.height * .2,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: tvShows.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TvShowPage(
                  model: tvShows[i],
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
                      tag: 'upcoming${tvShows[i].posterPath}',
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/placeholder_box.png',
                        image:
                            'https://image.tmdb.org/t/p/w500${tvShows[i].posterPath}',
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
                            tvShows[i].voteAverage.toString(),
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
