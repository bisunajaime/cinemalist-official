import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cinemalist/barrels/actors_barrel.dart';
import 'package:cinemalist/barrels/genres_barrel.dart';
import 'package:cinemalist/barrels/popular_movies_barrel.dart';
import 'package:cinemalist/barrels/trending_movies_barrel.dart';
import 'package:cinemalist/barrels/upcoming_movies_barrel.dart';
import 'package:cinemalist/styles/theme.dart';

class SplashPage extends StatefulWidget {
  final Widget child;
  const SplashPage({super.key, required this.child});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  bool _ready = false;
  bool _minTimeElapsed = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _minTimeElapsed = true);
      _tryNavigate();
    });
  }

  void _tryNavigate() {
    if (_ready && _minTimeElapsed && !_navigated) {
      _navigated = true;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => widget.child,
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return MultiBlocListener(
      listeners: [
        BlocListener<GenresCubit, dynamic>(listener: (_, __) => _checkReady()),
        BlocListener<PopularMoviesCubit, dynamic>(listener: (_, __) => _checkReady()),
        BlocListener<UpcomingMoviesCubit, dynamic>(listener: (_, __) => _checkReady()),
        BlocListener<TrendingMoviesCubit, dynamic>(listener: (_, __) => _checkReady()),
        BlocListener<ActorsCubit, dynamic>(listener: (_, __) => _checkReady()),
      ],
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.movie_filter_rounded,
                size: 64,
                color: isDark ? AppColors.primaryLight : AppColors.lightPrimary,
              ).animate()
                  .fadeIn(duration: 600.ms)
                  .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1), curve: Curves.elasticOut, duration: 800.ms),
              const SizedBox(height: 20),
              Text(
                'CINEMALIST',
                style: GoogleFonts.bebasNeue(
                  fontSize: 36,
                  letterSpacing: 6,
                  color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                ),
              ).animate(delay: 200.ms).fadeIn(duration: 500.ms).slideY(begin: 0.3, end: 0),
              const SizedBox(height: 32),
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: isDark ? AppColors.primaryLight : AppColors.lightPrimary,
                ),
              ).animate(delay: 400.ms).fadeIn(duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }

  void _checkReady() {
    if (_ready) return;
    final genres = context.read<GenresCubit>();
    final popular = context.read<PopularMoviesCubit>();
    final upcoming = context.read<UpcomingMoviesCubit>();
    final trending = context.read<TrendingMoviesCubit>();
    final actors = context.read<ActorsCubit>();

    final allLoaded = !genres.isLoading &&
        !popular.isLoading &&
        !upcoming.isLoading &&
        !trending.isLoading &&
        !actors.isLoading;

    if (allLoaded) {
      setState(() => _ready = true);
      _tryNavigate();
    }
  }
}
