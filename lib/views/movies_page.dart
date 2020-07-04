import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/bloc/movies/nowshowing/nowshowing_bloc.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/views/movie_page.dart';

class MoviesPage extends StatefulWidget {
  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  ScrollController controller = new ScrollController();
  final scrollThreshold = 200;
  NowShowingBloc _nowShowingBloc;

  @override
  void initState() {
    super.initState();
    controller.addListener(_onScroll);
    _nowShowingBloc = BlocProvider.of<NowShowingBloc>(context);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = controller.position.maxScrollExtent;
    final currentScroll = controller.position.pixels;
    if (maxScroll - currentScroll <= scrollThreshold) {
      _nowShowingBloc.add(FetchNowShowingMovies());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Now Playing',
                style: Styles.mBold.copyWith(
                  fontSize: 30,
                ),
              ),
              Text(
                'MOVIES',
                style: Styles.mBold.copyWith(
                  color: Colors.pinkAccent,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: BlocBuilder<NowShowingBloc, NowShowingState>(
            builder: (context, state) {
              if (state is NowShowingInitial) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is NowShowingFailed) {
                return Center(
                  child: Text('Failed to fetch posts'),
                );
              }
              if (state is NowShowingSuccess) {
                if (state.nowShowingMovies.isEmpty) {
                  return Center(
                    child: Text('No Posts'),
                  );
                }
                return Scrollbar(
                  child: GridView.builder(
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: state.hasReachedMax
                        ? state.nowShowingMovies.length
                        : state.nowShowingMovies.length + 1,
                    controller: controller,
                    itemBuilder: (context, i) {
                      return i >= state.nowShowingMovies.length
                          ? Shimmer.fromColors(
                              child: Container(
                                color: Color(0xff232323),
                              ),
                              baseColor: Color(0xff313131),
                              highlightColor: Color(0xff4A4A4A),
                            )
                          : buildNowShowingMovies(
                              context, state.nowShowingMovies[i]);
                    },
                  ),
                );
              }
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
            },
          ),
        ),
      ],
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
          image: DecorationImage(
            image: NetworkImage(
              movies.posterPath != null
                  ? 'https://image.tmdb.org/t/p/w500${movies.posterPath}'
                  : 'https://via.placeholder.com/400',
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
