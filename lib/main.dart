import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:tmdbflutter/barrels/genres_barrel.dart';
import 'package:tmdbflutter/barrels/popular_movies_barrel.dart';
import 'package:tmdbflutter/barrels/trending_movies_barrel.dart';
import 'package:tmdbflutter/barrels/upcoming_movies_barrel.dart';
import 'package:tmdbflutter/bloc/movies/nowshowing/nowshowing_bloc.dart';
import 'package:tmdbflutter/bloc/ranking/movie_ranking_cubit.dart';
import 'package:tmdbflutter/bloc/search/search_cubit.dart';
import 'package:tmdbflutter/bloc/watch_later/watch_later_cubit.dart';
import 'package:tmdbflutter/repository/tmdb_client/tmdb_api_client.dart';
import 'package:tmdbflutter/repository/tmdb_repository/tmdb_api_repository.dart';
import 'package:tmdbflutter/repository/tmdb_repository/tmdb_repository.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/views/home_page.dart';
import 'package:tmdbflutter/views/more_page.dart';
import 'package:tmdbflutter/views/movies_page.dart';
import 'package:tmdbflutter/views/saved_records_view.dart';
import 'package:tmdbflutter/views/search_page.dart';
import 'package:tmdbflutter/views/tvshows_page.dart';

import 'barrels/actors_barrel.dart';
import 'barrels/genres_barrel.dart';
import 'bloc/tvshows/trending/populartvshows_bloc.dart';

void main() {
  // BlocSupervisor.delegate = SimpleBlocDelegate();
  final TMDBRepository repository = TMDBAPIRepository(
    tmdbClient: TMDBApiClient(
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GenresCubit(repository)..loadData(),
        ),
        BlocProvider(
          create: (context) => PopularMoviesCubit(repository)..loadData(),
        ),
        BlocProvider(
          create: (context) => UpcomingMoviesCubit(repository)..loadData(),
        ),
        BlocProvider(
          create: (context) => TrendingMoviesCubit(repository)..loadData(),
        ),
        BlocProvider(
          create: (context) => ActorsCubit(repository)..loadData(),
        ),
        BlocProvider(
          create: (context) => NowShowingCubit(repository),
        ),
        BlocProvider(
          create: (context) => PopularTvShowsCubit(repository),
        ),
        BlocProvider(
          create: (context) => SearchCubit(repository),
        ),
        BlocProvider(
          create: (context) => MoviesWatchLaterCubit(),
        ),
        BlocProvider(
          create: (context) => TvWatchLaterCubit(),
        ),
        BlocProvider(
          create: (context) => SavedActorsCubit(),
        ),
        BlocProvider(
          create: (context) => MovieRankingCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'TheMovieDB',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage();
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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                Icons.bookmark,
              ),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.more_horiz,
              ),
              label: 'More',
            ),
          ],
        ),
        body: PageView(
          controller: controller,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            HomePage(),
            MoviesPage(),
            TvShowsPage(),
            SavedRecordsPage(),
            SearchPage(),
            MorePage(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
