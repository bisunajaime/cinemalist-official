import 'package:cinemalist/utils/poster_path_helper.dart';
import 'package:flutter/material.dart';
import 'package:cinemalist/models/season_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/widgets/generic/fab_go_home.dart';

class SeasonInfoPage extends StatefulWidget {
  final List<SeasonModel>? tvSeasons;
  final SeasonModel? tvShow;
  final int? index;
  final String? name;
  SeasonInfoPage({
    this.tvSeasons,
    this.tvShow,
    this.index,
    this.name,
  });

  @override
  _SeasonInfoPageState createState() => _SeasonInfoPageState();
}

class _SeasonInfoPageState extends State<SeasonInfoPage> {
  List<SeasonModel>? tv;
  @override
  void initState() {
    super.initState();
    tv = widget.tvSeasons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0E0E0E),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          buildSliverAppBar(context),
          buildSliverToBoxAdapter()
        ],
      ),
      floatingActionButton: FABGoHome(),
    );
  }

  SliverToBoxAdapter buildSliverToBoxAdapter() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              widget.name!,
              style: Styles.mBold.copyWith(
                fontSize: 20,
                color: Colors.pinkAccent[100],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '${widget.tvShow!.name}',
              style: Styles.mReg,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              widget.tvShow!.overview!,
              style: Styles.mReg.copyWith(
                fontSize: 10,
                height: 1.6,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Other Seasons",
              style: Styles.mBold.copyWith(
                fontSize: 20,
                color: Colors.pinkAccent[100],
              ),
            ),
          ),
          Container(
            height: 250,
            width: double.infinity,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: tv!.length,
              itemBuilder: (context, i) {
                final tvRecord = tv![i];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SeasonInfoPage(
                        tvShow: tvRecord,
                        index: i,
                        tvSeasons: widget.tvSeasons,
                        name: widget.name,
                      ),
                    ),
                  ),
                  child: Container(
                    height: double.infinity,
                    width: 150,
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color(0xff2e2e2e),
                      image: DecorationImage(
                          image: NetworkImage(
                              PosterPathHelper.generatePosterPath(
                                  tvRecord.posterPath)),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black26,
                            BlendMode.darken,
                          )),
                    ),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      tvRecord.name!,
                      style: Styles.mBold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * .7,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Container(
          color: Color(0xff0E0E0E),
          height: double.infinity,
          width: double.infinity,
          child: ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black,
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
            child: widget.tvShow!.posterPath == null
                ? Image.asset(
                    'assets/images/placeholder.png',
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    PosterPathHelper.generatePosterPath(
                        widget.tvShow?.posterPath),
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }
}
