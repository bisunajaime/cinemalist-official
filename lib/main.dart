import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdbflutter/barrels/genres_barrel.dart';
import 'package:tmdbflutter/barrels/popular_movies_barrel.dart';
import 'package:tmdbflutter/barrels/trending_movies_barrel.dart';
import 'package:tmdbflutter/barrels/upcoming_movies_barrel.dart';
import 'package:tmdbflutter/bloc/movies/cast/movie_cast_bloc.dart';
import 'package:tmdbflutter/bloc/movies/nowshowing/nowshowing_bloc.dart';
import 'package:tmdbflutter/repository/tmdb_api_client.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';
import 'package:http/http.dart' as http;
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/views/home_page.dart';
import 'package:tmdbflutter/views/movies_page.dart';
import 'package:tmdbflutter/views/search_page.dart';
import 'package:tmdbflutter/views/tvshows_page.dart';

import 'barrels/genres_barrel.dart';
import 'barrels/actors_barrel.dart';
import 'bloc/tvshows/trending/populartvshows_bloc.dart';

void main() {
  // BlocSupervisor.delegate = SimpleBlocDelegate();
  final TMDBRepository repository = TMDBRepository(
    tmdbApiClient: TMDBApiClient(
      httpClient: http.Client(),
    ),
  );
  runApp(MyApp(
    repository: repository,
  ));
}

// BLoc Delegate
// class SimpleBlocDelegate extends BlocDelegate {
//   @override
//   void onTransition(Bloc bloc, Transition transition) {
//     super.onTransition(bloc, transition);
//     print(transition);
//   }
// }

class MyApp extends StatelessWidget {
  final TMDBRepository repository;

  MyApp({
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TheMovieDB',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(
        repository: repository,
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  final TMDBRepository repository;
  MainPage({required this.repository});
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with AutomaticKeepAliveClientMixin {
  int index = 0;
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(
      initialPage: 0,
      keepPage: true,
    );
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0E0E0E),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xff0E0E0E),
        selectedItemColor: Colors.pinkAccent,
        selectedFontSize: 10,
        selectedLabelStyle: Styles.mBold.copyWith(
          color: Colors.pinkAccent,
        ),
        unselectedFontSize: 9,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (i) {
          controller.animateToPage(
            i,
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
          );
          setState(() {
            index = i;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.movie,
            ),
            label: 'Movie',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.tv,
            ),
            label: 'TV',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            label: 'Search',
          ),
        ],
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => GenresBloc(
              tmdbRepository: widget.repository,
            ),
          ),
          BlocProvider(
            create: (context) => PopularMoviesBloc(
              tmdbRepository: widget.repository,
            ),
          ),
          BlocProvider(
            create: (context) => UpcomingMoviesBloc(
              tmdbRepository: widget.repository,
            ),
          ),
          BlocProvider(
            create: (context) => TrendingMoviesBloc(
              tmdbRepository: widget.repository,
            ),
          ),
          BlocProvider(
            create: (context) => ActorsBloc(
              tmdbRepository: widget.repository,
            ),
          ),
          BlocProvider(
            create: (context) => NowShowingBloc(
              tmdbRepository: widget.repository,
            )..add(FetchNowShowingMovies()),
          ),
          BlocProvider(
            create: (context) => PopularTvShowsBloc(
              tmdbRepository: widget.repository,
            )..add(FetchPopularTvShows()),
          ),
          BlocProvider(
            create: (context) => MovieCastBloc(
              tmdbRepository: widget.repository,
            ),
          ),
        ],
        child: PageView(
          controller: controller,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            HomePage(),
            MoviesPage(),
            TvShowsPage(),
            SearchPage(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
