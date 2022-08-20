import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/bloc/tvshows/trending/populartvshows_bloc.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/views/tvshow_page.dart';
import 'package:tmdbflutter/widgets/tv/tv_shows_list_widget.dart';

class TvShowsPage extends StatelessWidget {
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
          child: TvShowsListWidget(),
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
            'Discover',
            style: Styles.mBold.copyWith(
              fontSize: 30,
            ),
          ),
          Text(
            'TV SHOWS',
            style: Styles.mBold.copyWith(
              color: Colors.pinkAccent,
            ),
          ),
        ],
      ),
    );
  }
}
