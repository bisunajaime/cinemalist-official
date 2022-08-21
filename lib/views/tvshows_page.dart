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
    return NestedScrollView(
      physics: BouncingScrollPhysics(),
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            backgroundColor: Color(0xff0E0E0E),
            automaticallyImplyLeading: false,
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * .2,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: [StretchMode.blurBackground],
              collapseMode: CollapseMode.parallax,
              title: Align(
                alignment: Alignment.bottomLeft,
                child: buildTitle(),
              ),
              background: Container(
                color: Color(0xff0E0E0E),
                // child: MoviesSliverCarousel(),
              ),
            ),
          ),
        ];
      },
      body: TvShowsListWidget(),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            'TV SHOWS',
            style: Styles.mBold.copyWith(
              color: Colors.pinkAccent,
              fontSize: 10,
            ),
          ),
          Text(
            'Discover',
            style: Styles.mBold.copyWith(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
