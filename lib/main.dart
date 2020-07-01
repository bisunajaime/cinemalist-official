import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdbflutter/barrels/genres_barrel.dart';
import 'package:tmdbflutter/bloc/popular/popular_bloc.dart';
import 'package:tmdbflutter/bloc/upcoming/upcoming_bloc.dart';
import 'package:tmdbflutter/repository/tmdb_api_client.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';
import 'package:http/http.dart' as http;
import 'package:tmdbflutter/views/home_page.dart';

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
      home: Scaffold(
        backgroundColor: Color(0xff1B1B1B),
        appBar: AppBar(
          title: Text('TMDB'),
          centerTitle: true,
          backgroundColor: Colors.pinkAccent[700],
        ),
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => GenresBloc(
                tmdbRepository: repository,
              ),
            ),
            BlocProvider(
              create: (context) => PopularsBloc(
                tmdbRepository: repository,
              ),
            ),
            BlocProvider(
              create: (context) => UpcomingsBloc(
                tmdbRepository: repository,
              ),
            ),
          ],
          child: HomePage(),
        ),
      ),
    );
  }
}
