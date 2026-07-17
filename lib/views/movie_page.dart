import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cinemalist/widgets/chat/start_chat_button.dart';
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
import 'package:cinemalist/widgets/generic/expandable_text.dart';
import 'package:cinemalist/widgets/generic/fab_go_home.dart';
import 'package:cinemalist/widgets/generic/fab_save_record.dart';
import 'package:cinemalist/widgets/generic/genres_of_movie_list_widget.dart';
import 'package:cinemalist/widgets/generic/info_chip.dart';
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
      child: Builder(
        builder: (context) => Scaffold(
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(context),
              _buildContent(context),
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
                  HapticFeedback.lightImpact();
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
      ),
    );
  }

  SliverToBoxAdapter _buildContent(BuildContext context) {
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
            const SizedBox(height: 12),
            // Metadata chips
            _buildMetadataChips(context).animate().fadeIn(delay: 100.ms, duration: 400.ms),
            const SizedBox(height: 16),
            // Expandable overview
            ExpandableText(text: widget.model!.overview ?? '')
                .animate().fadeIn(delay: 200.ms, duration: 400.ms),
            const SizedBox(height: 24),
            Text('TRAILERS', style: Styles.heading.copyWith(fontSize: 26, color: AppColors.primaryLight))
                .animate().fadeIn(delay: 300.ms, duration: 400.ms),
            const SizedBox(height: 12),
            const MovieInfoWidget(),
            const SizedBox(height: 24),
            Text('CAST', style: Styles.heading.copyWith(fontSize: 26, color: AppColors.primaryLight))
                .animate().fadeIn(delay: 400.ms, duration: 400.ms),
            const SizedBox(height: 12),
            const MovieCastWidget(),
            const SizedBox(height: 24),
            Text('SIMILAR MOVIES', style: Styles.heading.copyWith(fontSize: 26, color: AppColors.primaryLight))
                .animate().fadeIn(delay: 500.ms, duration: 400.ms),
            const SizedBox(height: 12),
            const SimilarMoviesWidget(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataChips(BuildContext context) {
    final movie = widget.model!;
    final infoCubit = context.watch<MovieInfoCubit>();
    final info = infoCubit.state;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (movie.releaseDate != null && movie.releaseDate!.isNotEmpty)
          InfoChip(
            icon: Icons.calendar_today_rounded,
            label: DateFormat.yMMMd().format(DateTime.parse(movie.releaseDate!)),
            iconColor: AppColors.amber,
          ),
        InfoChip(
          icon: Icons.star_rounded,
          label: (movie.voteAverage ?? 0).toStringAsFixed(1),
          iconColor: AppColors.ratingColor(movie.voteAverage ?? 0),
        ),
        if (info?.runtime != null && info!.runtime! > 0)
          InfoChip(
            icon: Icons.schedule_rounded,
            label: '${info.runtime! ~/ 60}h ${info.runtime! % 60}m',
          ),
        if (info?.vote_count != null)
          InfoChip(
            icon: Icons.how_to_vote_rounded,
            label: '${_formatCount(info!.vote_count!)} votes',
          ),
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return count.toString();
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.6,
      backgroundColor: AppColors.background,
      pinned: true,
      stretch: true,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => startMovieChat(context, widget.model!),
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF3949AB).withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 16),
          ),
        ),
        GestureDetector(
          onTap: () {
            Share.share('Check out "${widget.model!.title}" on TMDB!\nhttps://www.themoviedb.org/movie/${widget.model!.id}');
          },
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.share_rounded, color: Colors.white, size: 18),
          ),
        ),
      ],
      title: Builder(
        builder: (context) {
          final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
          final collapsed = settings != null && settings.currentExtent <= kToolbarHeight + MediaQuery.of(context).padding.top + 20;
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: collapsed ? 1.0 : 0.0,
            child: Text(
              widget.model!.title ?? '',
              style: Styles.mBold.copyWith(fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ),
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
