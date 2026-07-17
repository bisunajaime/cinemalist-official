import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cinemalist/bloc/movies/cast/movie_cast_cubit.dart';
import 'package:cinemalist/bloc/movies/info/movie_info_cubit.dart';
import 'package:cinemalist/bloc/movies/similar/similar_movies_bloc.dart';
import 'package:cinemalist/bloc/ranking/movie_ranking_cubit.dart';
import 'package:cinemalist/bloc/watch_later/watch_later_cubit.dart';
import 'package:cinemalist/models/ranking_model.dart';
import 'package:cinemalist/repository/tmdb_repository/tmdb_repository.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/utils/delayed_runner.dart';
import 'package:cinemalist/widgets/generic/fab_go_home.dart';
import 'package:cinemalist/widgets/generic/fab_save_record.dart';
import 'package:cinemalist/widgets/generic/genres_of_movie_list_widget.dart';
import 'package:cinemalist/widgets/movie/movie_cast_widget.dart';
import 'package:cinemalist/widgets/movie/movie_info_widget.dart';
import 'package:cinemalist/widgets/movie/similar_movies_widget.dart';

import '../barrels/models.dart';

class MoviePage extends StatefulWidget {
  final GenericMoviesModel? model;
  final String? tag;

  const MoviePage({this.model, this.tag});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final _runner = DelayedRunner(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    final tmdbRepo = context.read<TMDBRepository>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MovieInfoCubit(tmdbRepo, widget.model?.id)..loadData(),
        ),
        BlocProvider(
          create: (context) => MovieCastCubit(tmdbRepo, widget.model?.id)..loadData(),
        ),
        BlocProvider(
          create: (context) => SimilarMoviesCubit(tmdbRepo, widget.model?.id)..loadData(),
        ),
      ],
      child: Scaffold(
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(context),
            _buildContent(),
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FABSaveRecord<GenericMoviesModel>(
              tag: 'movie-${widget.model!.id!}',
              isSaved: context.watch<MoviesWatchLaterCubit>().isSaved(widget.model!),
              record: widget.model!,
              onTap: (elem) async {
                _runner.run(() async {
                  final rankingCubit = context.read<MovieRankingCubit>();
                  await rankingCubit.removeRankingWithoutLetter(
                      RankingModel.fromGenericMovieModel(elem));
                  await context.read<MoviesWatchLaterCubit>().save(elem);
                });
              },
            ),
            const SizedBox(width: 8),
            const FABGoHome(),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildContent() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              widget.model!.title ?? '',
              style: Styles.heading.copyWith(fontSize: 32, color: AppColors.primaryLight),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 8),
            GenresOfMovieListWidget(genreIds: widget.model?.genreIds),
            const SizedBox(height: 8),
            Row(
              children: [
                if (widget.model?.releaseDate != null &&
                    widget.model!.releaseDate!.isNotEmpty) ...[
                  Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.amber),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat.yMMMd().format(DateTime.parse(widget.model!.releaseDate!)),
                    style: Styles.mMed.copyWith(fontSize: 13, color: AppColors.amber),
                  ),
                  const SizedBox(width: 16),
                ],
                Icon(Icons.star_rounded, color: AppColors.gold, size: 16),
                const SizedBox(width: 4),
                Text(
                  (widget.model!.voteAverage ?? 0).toStringAsFixed(1),
                  style: Styles.mBold.copyWith(fontSize: 13),
                ),
              ],
            ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
            const SizedBox(height: 12),
            Text(
              widget.model!.overview ?? '',
              style: Styles.mReg.copyWith(
                fontSize: 13,
                height: 1.6,
                color: AppColors.textSecondary,
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
            const SizedBox(height: 24),
            Text('Trailers', style: Styles.heading.copyWith(fontSize: 26, color: AppColors.primaryLight))
                .animate().fadeIn(delay: 300.ms, duration: 400.ms),
            const SizedBox(height: 12),
            const MovieInfoWidget(),
            const SizedBox(height: 24),
            Text('Cast', style: Styles.heading.copyWith(fontSize: 26, color: AppColors.primaryLight))
                .animate().fadeIn(delay: 400.ms, duration: 400.ms),
            const SizedBox(height: 12),
            const MovieCastWidget(),
            const SizedBox(height: 24),
            Text('Similar Movies', style: Styles.heading.copyWith(fontSize: 26, color: AppColors.primaryLight))
                .animate().fadeIn(delay: 500.ms, duration: 400.ms),
            const SizedBox(height: 12),
            const SimilarMoviesWidget(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.6,
      backgroundColor: AppColors.background,
      pinned: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: widget.tag ?? '',
              child: CachedNetworkImage(
                imageUrl: 'https://image.tmdb.org/t/p/w500${widget.model!.posterPath}',
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: AppColors.card),
                errorWidget: (_, __, ___) => Container(color: AppColors.card),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.background.withValues(alpha: 0.3),
                    AppColors.background,
                  ],
                  stops: const [0.3, 0.7, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
