import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/bloc/movies/popular/popular_movies_cubit.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/widgets/home/actors_list_widget.dart';
import 'package:cinemalist/widgets/home/genres_list_widget.dart';
import 'package:cinemalist/widgets/home/popular_movies_widget.dart';
import 'package:cinemalist/widgets/home/trending_movies_list_widget.dart';
import 'package:cinemalist/widgets/home/upcoming_movies_list_widget.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        context.read<PopularMoviesCubit>().refresh();
      },
      child: ListView(
        padding: EdgeInsets.zero,
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
