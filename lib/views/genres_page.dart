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
import 'package:tmdbflutter/widgets/home/genres_list_widget.dart';
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
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              expandedHeight: MediaQuery.of(context).size.height * .2,
              backgroundColor: grabColorForGenre(widget.genre!).first,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                title: Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        widget.genre!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                titlePadding: EdgeInsets.all(18),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: grabColorForGenre(widget.genre!),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: MoviesByGenreListWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
