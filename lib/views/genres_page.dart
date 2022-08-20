import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/bloc/movies/byGenre/moviesbygenre_cubit.dart';
import 'package:tmdbflutter/models/generic_movies_model.dart';
import 'package:tmdbflutter/repository/tmdb_api_client.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:http/http.dart' as http;
import 'package:tmdbflutter/widgets/genre/movies_by_genre_list.dart';
import 'movie_page.dart';

class GenresPage extends StatefulWidget {
  final int? id;
  final String? genre;
  GenresPage({this.id, this.genre});
  @override
  _GenresPageState createState() => _GenresPageState();
}

class _GenresPageState extends State<GenresPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TMDBRepository tmdbRepo = TMDBRepository(
      tmdbApiClient: TMDBApiClient(
        httpClient: http.Client(),
      ),
    );
    return BlocProvider<MoviesByGenreCubit>(
      create: (context) => MoviesByGenreCubit(tmdbRepo, widget.id!),
      child: Scaffold(
        backgroundColor: Color(0xff0E0E0E),
        appBar: AppBar(
          title: Text(
            widget.genre!,
            style: Styles.mReg.copyWith(
              color: Colors.pinkAccent[100],
            ),
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
        ),
        body: MoviesByGenreListWidget(),
      ),
    );
  }
}
