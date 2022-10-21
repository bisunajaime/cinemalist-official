import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinemalist/utils/poster_path_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinemalist/bloc/movies/nowshowing/nowshowing_bloc.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/widgets/movies/now_showing_movies_list_widget.dart';

class MoviesPage extends StatefulWidget {
  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage>
    with AutomaticKeepAliveClientMixin<MoviesPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
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
      body: NowShowingMoviesListWidget(),
    );
  }

  Padding buildTitle() {
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
            'MOVIES',
            style: Styles.mBold.copyWith(
              color: Colors.pinkAccent,
              fontSize: 10,
            ),
          ),
          Text(
            'Now Playing',
            style: Styles.mBold.copyWith(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MoviesSliverCarousel extends StatefulWidget {
  const MoviesSliverCarousel({Key? key}) : super(key: key);

  @override
  State<MoviesSliverCarousel> createState() => _MoviesSliverCarouselState();
}

class _MoviesSliverCarouselState extends State<MoviesSliverCarousel> {
  final pageController = PageController(initialPage: 0);
  int index = 0;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Timer.periodic(Duration(seconds: 4), (timer) {
      if (!mounted) return;
      final cubit = context.read<NowShowingCubit>();
      if (cubit.state == null || cubit.state?.isEmpty == true) return;
      if (index == cubit.state!.length - 1) {
        pageController.jumpTo(0);
        return;
      }
      pageController.nextPage(
          duration: Duration(milliseconds: 1500), curve: Curves.fastOutSlowIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pagedCubit = context.watch<NowShowingCubit>();
    final state = pagedCubit.state;
    if (pagedCubit.initialLoading) {
      return Container(
        height: double.infinity,
        color: Color(0xff0E0E0E),
      );
    }
    state!;
    return PageView.builder(
      itemCount: state.length,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      controller: pageController,
      onPageChanged: (page) {
        setState(() => index = page);
      },
      itemBuilder: (BuildContext context, int index) {
        final movie = state[index];
        return ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff0E0E0E),
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
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xff0E0E0E),
            ),
            child: CachedNetworkImage(
              imageUrl: PosterPathHelper.generatePosterPath(movie?.posterPath),
              fit: BoxFit.cover,
              cacheManager: DefaultCacheManager(),
              placeholder: (context, _) {
                return Shimmer.fromColors(
                  child: Container(
                    height: double.infinity,
                  ),
                  baseColor: Color(0xff313131),
                  highlightColor: Color(0xff4A4A4A),
                );
                // return Image.asset('assets/images/placeholder_box.png');
              },
            ),
          ),
        );
      },
    );
  }
}
