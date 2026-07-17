import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:cinemalist/barrels/genres_barrel.dart';
import 'package:cinemalist/barrels/popular_movies_barrel.dart';
import 'package:cinemalist/barrels/trending_movies_barrel.dart';
import 'package:cinemalist/barrels/upcoming_movies_barrel.dart';
import 'package:cinemalist/bloc/movies/nowshowing/nowshowing_bloc.dart';
import 'package:cinemalist/bloc/ranking/actor_ranking_cubit.dart';
import 'package:cinemalist/bloc/ranking/movie_ranking_cubit.dart';
import 'package:cinemalist/bloc/ranking/ranking_filter_cubit.dart';
import 'package:cinemalist/bloc/ranking/tvshow_ranking_cubit.dart';
import 'package:cinemalist/bloc/search/search_cubit.dart';
import 'package:cinemalist/bloc/theme/theme_cubit.dart';
import 'package:cinemalist/bloc/watch_later/watch_later_cubit.dart';
import 'package:cinemalist/repository/tmdb_client/tmdb_api_client.dart';
import 'package:cinemalist/repository/tmdb_repository/tmdb_api_repository.dart';
import 'package:cinemalist/repository/tmdb_repository/tmdb_repository.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/views/home_page.dart';
import 'package:cinemalist/views/splash_page.dart';
import 'package:cinemalist/views/more_page.dart';
import 'package:cinemalist/views/movies_page.dart';
import 'package:cinemalist/views/saved_records_view.dart';
import 'package:cinemalist/views/search_page.dart';
import 'package:cinemalist/views/tvshows_page.dart';

import 'barrels/actors_barrel.dart';
import 'bloc/tvshows/trending/populartvshows_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  const apiKey = String.fromEnvironment(
    'TMDB_API_KEY',
    defaultValue: 'efd2f9bdbe60bbb9414be9a5a20296b0',
  );

  final TMDBRepository repository = TMDBAPIRepository(
    tmdbClient: TMDBApiClient(
      httpClient: http.Client(),
      apiKey: apiKey,
    ),
  );
  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final TMDBRepository repository;

  const MyApp({required this.repository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: repository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(create: (_) => GenresCubit(repository)..loadData()),
          BlocProvider(create: (_) => PopularMoviesCubit(repository)..loadData()),
          BlocProvider(create: (_) => UpcomingMoviesCubit(repository)..loadData()),
          BlocProvider(create: (_) => TrendingMoviesCubit(repository)..loadData()),
          BlocProvider(create: (_) => ActorsCubit(repository)..loadData()),
          BlocProvider(create: (_) => NowShowingCubit(repository)),
          BlocProvider(create: (_) => PopularTvShowsCubit(repository)),
          BlocProvider(create: (_) => SearchCubit(repository)),
          BlocProvider(create: (_) => MoviesWatchLaterCubit()),
          BlocProvider(create: (_) => TvWatchLaterCubit()),
          BlocProvider(create: (_) => SavedActorsCubit()),
          BlocProvider(create: (_) => MovieRankingCubit()),
          BlocProvider(create: (_) => ActorRankingCubit()),
          BlocProvider(create: (_) => TvShowRankingCubit()),
          BlocProvider(create: (_) => RankingFilterCubit()),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            _updateSystemUI(themeMode);
            return MaterialApp(
              title: 'Cinemalist',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              home: const SplashPage(child: MainPage()),
            );
          },
        ),
      ),
    );
  }

  void _updateSystemUI(ThemeMode mode) {
    final isDark = mode == ThemeMode.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: isDark ? AppColors.surface : AppColors.lightSurface,
      systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    ));
  }
}

class MainPage extends StatefulWidget {
  const MainPage();
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late final PageController _pageController;
  late final AnimationController _navAnimController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, keepPage: true);
    _navAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _navAnimController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const <Widget>[
            HomePage(),
            MoviesPage(),
            TvShowsPage(),
            SavedRecordsPage(),
            SearchPage(),
            MorePage(),
          ],
        ),
        bottomNavigationBar: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _navAnimController,
            curve: Curves.easeOutCubic,
          )),
          child: Container(
            decoration: BoxDecoration(
              color: context.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: context.isDark ? 0.3 : 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  activeIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.movie_rounded),
                  activeIcon: Icon(Icons.movie_rounded),
                  label: 'Movies',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.tv_rounded),
                  activeIcon: Icon(Icons.tv_rounded),
                  label: 'TV',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark_outline_rounded),
                  activeIcon: Icon(Icons.bookmark_rounded),
                  label: 'Saved',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search_rounded),
                  activeIcon: Icon(Icons.search_rounded),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.more_horiz_rounded),
                  activeIcon: Icon(Icons.more_horiz_rounded),
                  label: 'More',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
