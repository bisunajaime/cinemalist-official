import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/bloc/movies/nowshowing/nowshowing_bloc.dart';
import 'package:tmdbflutter/models/generic_movies_model.dart';
import 'package:tmdbflutter/views/movie_page.dart';

class NowShowingMoviesListWidget extends StatefulWidget {
  const NowShowingMoviesListWidget();

  @override
  State<NowShowingMoviesListWidget> createState() =>
      _NowShowingMoviesListWidgetState();
}

class _NowShowingMoviesListWidgetState
    extends State<NowShowingMoviesListWidget> {
  ScrollController controller = new ScrollController();
  final scrollThreshold = 200;
  late final NowShowingCubit _nowShowingCubit;

  @override
  void initState() {
    super.initState();

    controller.addListener(_onScroll);
    _nowShowingCubit = context.read<NowShowingCubit>();
  }

  void _onScroll() {
    final maxScroll = controller.position.maxScrollExtent;
    final currentScroll = controller.position.pixels;
    if (maxScroll - currentScroll <= scrollThreshold) {
      _nowShowingCubit.loadNextPage(onComplete: () {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<NowShowingCubit>();
    final nowShowingMovies = cubit.state;
    if (cubit.initialLoading) {
      return GridView.builder(
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
            baseColor: Color(0xff232323),
            highlightColor: Color(0xff222222),
          );
        },
      );
    }
    nowShowingMovies!;
    return RefreshIndicator(
      onRefresh: () async {
        cubit.refresh();
      },
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
          childAspectRatio: 0.7,
        ),
        itemCount: cubit.hasReachedMax
            ? nowShowingMovies.length
            : nowShowingMovies.length + 1,
        controller: controller,
        itemBuilder: (context, i) {
          nowShowingMovies
              .removeWhere((element) => element?.posterPath == null);
          return i >= nowShowingMovies.length
              ? Shimmer.fromColors(
                  child: Container(
                    color: Color(0xff232323),
                  ),
                  baseColor: Color(0xff313131),
                  highlightColor: Color(0xff4A4A4A),
                )
              : buildNowShowingMovies(
                  context,
                  nowShowingMovies[i]!,
                );
        },
      ),
    );
  }

  GestureDetector buildNowShowingMovies(
      BuildContext context, GenericMoviesModel movies) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MoviePage(
            tag: 'nowplaying${movies.posterPath}',
            model: movies,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff232323),
        ),
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/images/placeholder_box.png',
          image: 'https://image.tmdb.org/t/p/w500${movies.posterPath}',
          fit: BoxFit.cover,
          fadeInCurve: Curves.ease,
          fadeInDuration: Duration(milliseconds: 250),
          fadeOutDuration: Duration(milliseconds: 250),
          fadeOutCurve: Curves.ease,
        ),
      ),
    );
  }
}
