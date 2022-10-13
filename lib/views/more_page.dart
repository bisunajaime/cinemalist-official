import 'package:flutter/material.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/views/ranking_page.dart';

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

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
            centerTitle: false,
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
              // background: Sizedbox(
              //   color: Color(0xff0E0E0E),
              //   // child: MoviesSliverCarousel(),
              // ),
            ),
          ),
        ];
      },
      body: MoreBody(),
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
            'Check out some',
            style: Styles.mBold.copyWith(
              color: Colors.pinkAccent,
              fontSize: 10,
            ),
          ),
          Text(
            'More Features',
            style: Styles.mBold.copyWith(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class MoreBody extends StatelessWidget {
  const MoreBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MoreBodyItem(),
      ],
    );
  }
}

class MoreBodyItem extends StatelessWidget {
  const MoreBodyItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return RankingPage();
            },
          ),
        );
      },
      child: RankYourSavedMovies(),
    );
  }
}

class RankYourSavedMovies extends StatelessWidget {
  const RankYourSavedMovies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(18),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Color(0xffa2009a),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.bar_chart,
            color: Colors.white,
            size: 30,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Rank your saved\nmovies, tv shows, and actors',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
