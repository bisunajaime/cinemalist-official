import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tmdbflutter/bloc/movies/cast/movie_cast_cubit.dart';
import 'package:tmdbflutter/bloc/movies/info/movie_info_cubit.dart';
import 'package:tmdbflutter/bloc/movies/similar/similar_movies_bloc.dart';
import 'package:tmdbflutter/repository/tmdb_client/tmdb_api_client.dart';
import 'package:tmdbflutter/repository/tmdb_repository/tmdb_api_repository.dart';
import 'package:tmdbflutter/repository/tmdb_repository/tmdb_repository.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:http/http.dart' as http;
import 'package:tmdbflutter/widgets/generic/fab_go_home.dart';
import 'package:tmdbflutter/widgets/generic/genres_of_movie_list_widget.dart';
import 'package:tmdbflutter/widgets/generic/fab_save_record.dart';
import 'package:tmdbflutter/widgets/movie/movie_cast_widget.dart';
import 'package:tmdbflutter/widgets/movie/movie_info_widget.dart';
import 'package:tmdbflutter/widgets/movie/similar_movies_widget.dart';

import '../barrels/models.dart';

class MoviePage extends StatefulWidget {
  final GenericMoviesModel? model;
  final String? tag;

  MoviePage({
    this.model,
    this.tag,
  });

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  TMDBRepository tmdbRepo = TMDBAPIRepository(
    tmdbClient: TMDBApiClient(
      httpClient: http.Client(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    print(widget.model!.id);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              MovieInfoCubit(tmdbRepo, widget.model?.id)..loadData(),
        ),
        BlocProvider(
          create: (context) =>
              MovieCastCubit(tmdbRepo, widget.model?.id)..loadData(),
        ),
        BlocProvider(
          create: (context) =>
              SimilarMoviesCubit(tmdbRepo, widget.model?.id)..loadData(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Color(0xff0E0E0E),
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            buildSliverAppBar(context),
            buildSliverToBoxAdapter(),
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FABSaveRecord<GenericMoviesModel>(
              type: RecordType.movie,
              record: widget.model!,
              onTap: (elem) async {
                // TODO: save
              },
            ),
            SizedBox(width: 8),
            FABGoHome(),
          ],
        ),
      ),
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
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              widget.model!.title!,
              style: Styles.mBold.copyWith(
                fontSize: 20,
                color: Colors.pinkAccent[100],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          GenresOfMovieListWidget(genreIds: widget.model?.genreIds),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Text(
                  DateFormat.yMMMd()
                      .format(DateTime.parse(widget.model!.releaseDate!)),
                  style: Styles.mMed.copyWith(
                    fontSize: 12,
                    color: Colors.amber,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 12,
                    ),
                    Text(
                      widget.model!.voteAverage.toString(),
                      style: Styles.mBold.copyWith(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              widget.model!.overview!,
              style: Styles.mReg.copyWith(
                fontSize: 10,
                height: 1.6,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Trailers',
              style: Styles.mBold.copyWith(
                fontSize: 20,
                color: Colors.pinkAccent[100],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          MovieInfoWidget(),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Cast',
              style: Styles.mBold.copyWith(
                fontSize: 20,
                color: Colors.pinkAccent[100],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          MovieCastWidget(),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Similar Movies',
              style: Styles.mBold.copyWith(
                fontSize: 20,
                color: Colors.pinkAccent[100],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          SimilarMoviesWidget(),
          SizedBox(height: 100),
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
          child: Hero(
            tag: widget.tag!,
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
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${widget.model!.posterPath}',
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
