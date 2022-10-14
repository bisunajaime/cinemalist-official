import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinemalist/bloc/tvshows/similar/similar_tv_bloc.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/views/tvshow_page.dart';

class SimilarTvShowsWidget extends StatefulWidget {
  const SimilarTvShowsWidget({Key? key}) : super(key: key);

  @override
  State<SimilarTvShowsWidget> createState() => _SimilarTvShowsWidgetState();
}

class _SimilarTvShowsWidgetState extends State<SimilarTvShowsWidget> {
  @override
  Widget build(BuildContext context) {
    final scrollThreshold = 200;
    final cubit = context.watch<SimilarTvShowsCubit>();
    final similarTvShows = cubit.state;
    if (cubit.loading) {
      return Container(
        height: 250,
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
                    baseColor: Color(0xff313131),
                    highlightColor: Color(0xff4A4A4A),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
    similarTvShows!;

    return Container(
      height: 250,
      width: double.infinity,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          final maxScroll = notification.metrics.maxScrollExtent;
          final currentScroll = notification.metrics.pixels;
          if (maxScroll - currentScroll <= scrollThreshold) {
            cubit.loadNextPage(onComplete: () {
              if (mounted) {
                setState(() {});
              }
            });
          }
          return true;
        },
        child: ListView.builder(
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: similarTvShows.length,
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TvShowPage(
                    model: similarTvShows[i],
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: 170,
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: (similarTvShows[i].posterPath == null
                                  ? AssetImage('assets/images/placeholder.png')
                                  : NetworkImage(
                                      'https://image.tmdb.org/t/p/w500${similarTvShows[i].posterPath}'))
                              as ImageProvider<Object>,
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black26,
                            BlendMode.darken,
                          ),
                        ),
                      ),
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Colors.amberAccent,
                            size: 15,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            similarTvShows[i].voteAverage.toString(),
                            style: Styles.mMed.copyWith(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
