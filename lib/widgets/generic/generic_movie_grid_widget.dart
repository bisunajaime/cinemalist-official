import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/library/cubit.dart';

class GenericMovieGridWidget extends StatefulWidget {
  final PagedTMDBCubit pagedCubit;
  final Function(dynamic) onTap;
  const GenericMovieGridWidget({
    Key? key,
    required this.pagedCubit,
    required this.onTap,
  }) : super(key: key);

  @override
  State<GenericMovieGridWidget> createState() => _GenericMovieGridWidgetState();
}

class _GenericMovieGridWidgetState extends State<GenericMovieGridWidget> {
  final scrollThreshold = 200;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    await widget.pagedCubit.loadData();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = widget.pagedCubit.state;
    if (widget.pagedCubit.initialLoading) {
      return GridView.builder(
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
      );
    }
    list!;
    return RefreshIndicator(
      onRefresh: () async {
        widget.pagedCubit.refresh();
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          final maxScroll = notification.metrics.maxScrollExtent;
          final currentScroll = notification.metrics.pixels;
          if (maxScroll - currentScroll <= scrollThreshold) {
            widget.pagedCubit.loadNextPage(onComplete: () {
              if (mounted) {
                setState(() {});
              }
            });
          }
          return true;
        },
        child: GridView.builder(
          // controller: controller,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            childAspectRatio: 0.7,
          ),
          itemCount:
              widget.pagedCubit.hasReachedMax ? list.length : list.length + 1,
          itemBuilder: (context, i) {
            if (i >= list.length) {
              return Shimmer.fromColors(
                child: Container(
                  color: Color(0xff232323),
                ),
                baseColor: Color(0xff313131),
                highlightColor: Color(0xff4A4A4A),
              );
            }
            final element = list[i]!;
            return GestureDetector(
              onTap: () => widget.onTap(element),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff232323),
                ),
                child: CachedNetworkImage(
                  imageUrl:
                      'https://image.tmdb.org/t/p/w500${element.posterPath}',
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
      ),
    );
  }
}
