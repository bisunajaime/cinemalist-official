import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdbflutter/bloc/ranking/movie_ranking_cubit.dart';
import 'package:tmdbflutter/bloc/ranking/ranking_filter_cubit.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/widgets/ranking/ranking_actors_selection_widget.dart';
import 'package:tmdbflutter/widgets/ranking/ranking_filter_bar.dart';
import 'package:tmdbflutter/widgets/ranking/ranking_movie_selection_widget.dart';
import 'package:tmdbflutter/widgets/ranking/ranking_tvshow_selection_widget.dart';
import 'package:tmdbflutter/widgets/ranking/vertical_ranking_widget.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieRankingCubit = context.read<MovieRankingCubit>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0E0E0E),
        centerTitle: false,
        titleSpacing: 0.0,
        title: Text(
          'Rankings',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: RankingBody(),
    );
  }

  Widget buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        bottom: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            // 'Decide the best shows with',
            'Choose your favorites through',
            style: Styles.mBold.copyWith(
              color: Colors.pinkAccent,
              fontSize: 10,
            ),
          ),
          Text(
            'Rankings',
            style: Styles.mBold.copyWith(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class RankingBody extends StatelessWidget {
  const RankingBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xff0E0E0E),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: VerticalRankingWidget(),
            ),
          ),
          Container(
            color: Colors.black,
            child: Column(
              children: [
                SizedBox(height: 16),
                RankingSelectionWidget(),
                RankingFilterBar(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RankingSelectionWidget extends StatelessWidget {
  const RankingSelectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rankingFilterCubit = context.watch<RankingFilterCubit>();
    switch (rankingFilterCubit.state) {
      case RankingFilter.movies:
        return RankingMovieSelectionWidget();
      case RankingFilter.tvShows:
        return RankingTvShowsSelectionWidget();
      case RankingFilter.actors:
        return RankingActorsSelectionWidget();
      default:
        return Container();
    }
  }
}
