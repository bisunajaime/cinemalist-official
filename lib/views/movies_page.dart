import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/bloc/movies/nowshowing/nowshowing_bloc.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/views/movie_page.dart';
import 'package:tmdbflutter/widgets/movies/now_showing_movies_list_widget.dart';

class MoviesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        buildTitle(),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: NowShowingMoviesListWidget(),
        ),
      ],
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Now Playing',
            style: Styles.mBold.copyWith(
              fontSize: 30,
            ),
          ),
          Text(
            'MOVIES',
            style: Styles.mBold.copyWith(
              color: Colors.pinkAccent,
            ),
          ),
        ],
      ),
    );
  }
}
