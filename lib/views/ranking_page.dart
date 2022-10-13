import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdbflutter/bloc/ranking/movie_ranking_cubit.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/widgets/ranking/ranking_filter_bar.dart';
import 'package:tmdbflutter/widgets/ranking/ranking_movie_selection_widget.dart';
import 'package:tmdbflutter/widgets/ranking/vertical_ranking_widget.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieRankingCubit = context.read<MovieRankingCubit>();
    return NestedScrollView(
      physics: BouncingScrollPhysics(),
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            backgroundColor: Color(0xff0E0E0E),
            automaticallyImplyLeading: false,
            pinned: true,
            centerTitle: false,
            stretch: true,
            expandedHeight: MediaQuery.of(context).size.height * .2,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              stretchModes: [StretchMode.blurBackground],
              collapseMode: CollapseMode.parallax,
              centerTitle: false,
              title: Align(
                alignment: Alignment.bottomLeft,
                child: buildTitle(),
              ),
            ),
          ),
        ];
      },
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
                RankingMovieSelectionWidget(),
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
