import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/bloc/tvshows/trending/populartvshows_bloc.dart';
import 'package:tmdbflutter/views/tvshow_page.dart';

class TvShowsListWidget extends StatefulWidget {
  const TvShowsListWidget({Key? key}) : super(key: key);

  @override
  State<TvShowsListWidget> createState() => _TvShowsListWidgetState();
}

class _TvShowsListWidgetState extends State<TvShowsListWidget> {
  ScrollController controller = new ScrollController();
  final scrollThreshold = 200;
  late final PopularTvShowsCubit _tvShowsCubit;

  @override
  void initState() {
    super.initState();

    controller.addListener(_onScroll);
    _tvShowsCubit = context.read<PopularTvShowsCubit>();
  }

  void _onScroll() {
    final maxScroll = controller.position.maxScrollExtent;
    final currentScroll = controller.position.pixels;
    if (maxScroll - currentScroll <= scrollThreshold) {
      _tvShowsCubit.loadNextPage(onComplete: () {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<PopularTvShowsCubit>();
    final tvShows = cubit.state;
    if (cubit.initialLoading) {
      return Expanded(
        child: RefreshIndicator(
          onRefresh: () async {
            cubit.refresh();
          },
          child: GridView.builder(
            padding: EdgeInsets.zero,
            itemCount: 7,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, i) {
              return Shimmer.fromColors(
                child: Container(color: Colors.black),
                baseColor: Color(0xff313131),
                highlightColor: Color(0xff4A4A4A),
              );
            },
          ),
        ),
      );
    }
    tvShows!;
    tvShows.removeWhere((element) => element?.posterPath == null);
    return Expanded(
      child: GridView.builder(
        controller: controller,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
          childAspectRatio: 0.7,
        ),
        itemCount: cubit.hasReachedMax ? tvShows.length : tvShows.length + 1,
        itemBuilder: (context, i) {
          if (i >= tvShows.length) {
            return Shimmer.fromColors(
              child: Container(
                color: Color(0xff232323),
              ),
              baseColor: Color(0xff313131),
              highlightColor: Color(0xff4A4A4A),
            );
          }
          final tvShow = tvShows[i]!;
          return GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TvShowPage(
                    model: tvShow,
                  ),
                )),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff232323),
              ),
              child: CachedNetworkImage(
                imageUrl: 'https://image.tmdb.org/t/p/w500${tvShow.posterPath}',
                cacheManager: DefaultCacheManager(),
                fadeInCurve: Curves.ease,
                fadeInDuration: Duration(milliseconds: 250),
                fadeOutDuration: Duration(milliseconds: 250),
                fadeOutCurve: Curves.ease,
                fit: BoxFit.cover,
                placeholder: (context, string) {
                  return Shimmer.fromColors(
                    child: Container(
                      color: Color(0xff232323),
                    ),
                    baseColor: Color(0xff313131),
                    highlightColor: Color(0xff4A4A4A),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
