import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdbflutter/barrels/genres_barrel.dart';
import 'package:tmdbflutter/barrels/popular_movies_barrel.dart';
import 'package:tmdbflutter/barrels/trending_movies_barrel.dart';
import 'package:tmdbflutter/barrels/upcoming_movies_barrel.dart';
import 'package:tmdbflutter/bloc/movies/nowplaying/nowplaying_movies_bloc.dart';
import 'package:tmdbflutter/repository/tmdb_api_client.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';
import 'package:http/http.dart' as http;
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/views/home_page.dart';
import 'package:tmdbflutter/views/movies_page.dart';

import 'barrels/genres_barrel.dart';
import 'barrels/actors_barrel.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
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
class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

class MyApp extends StatelessWidget {
  final TMDBRepository repository;

  MyApp({
    Key key,
    @required this.repository,
  })  : assert(repository != null),
        super(key: key);
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
  MainPage({@required this.repository});
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;
  PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(
      initialPage: 0,
      keepPage: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0E0E0E),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xff0E0E0E),
        selectedItemColor: Colors.white,
        selectedFontSize: 10,
        unselectedFontSize: 9,
        unselectedItemColor: Colors.white,
        currentIndex: index,
        onTap: (i) {
          controller.animateToPage(
            i,
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            title: Text(
              'Home',
              style: Styles.mMed,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.movie,
            ),
            title: Text(
              'Movie',
              style: Styles.mMed,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.tv,
            ),
            title: Text(
              'TV',
              style: Styles.mMed,
            ),
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
            create: (context) => NowPlayingMoviesBloc(
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
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
