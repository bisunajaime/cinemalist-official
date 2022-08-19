import 'package:flutter/material.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/widgets/home/actors_list_widget.dart';
import 'package:tmdbflutter/widgets/home/genres_list_widget.dart';
import 'package:tmdbflutter/widgets/home/popular_movies_widget.dart';
import 'package:tmdbflutter/widgets/home/trending_movies_list_widget.dart';
import 'package:tmdbflutter/widgets/home/upcoming_movies_list_widget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        PopularMoviesWidget(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Genres',
            style: Styles.mBold,
          ),
        ),
        GenresListWidget(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Upcoming',
                style: Styles.mBold,
              ),
              Text(
                'See more',
                style: Styles.mReg.copyWith(
                  color: Colors.pinkAccent,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        UpcomingMoviesListWidget(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Actors',
                style: Styles.mBold,
              ),
              Text(
                'See more',
                style: Styles.mReg.copyWith(
                  color: Colors.pinkAccent,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        ActorsListWidget(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Trending',
                style: Styles.mBold,
              ),
              Text(
                'See more',
                style: Styles.mReg.copyWith(
                  color: Colors.pinkAccent,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        TrendingMoviesListWidget(),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
