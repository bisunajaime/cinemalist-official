import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cinemalist/widgets/chat/start_chat_button.dart';
import 'package:cinemalist/widgets/generic/shimmer_gradient_text.dart';
import 'package:cinemalist/bloc/collections/collections_cubit.dart';
import 'package:cinemalist/bloc/tvshows/credits/tvshow_credits_bloc.dart';
import 'package:cinemalist/bloc/tvshows/seasons/tvseasons_bloc.dart';
import 'package:cinemalist/bloc/tvshows/similar/similar_tv_bloc.dart';
import 'package:cinemalist/models/collections/collection_models.dart';
import 'package:cinemalist/models/tvshow_model.dart';
import 'package:cinemalist/repository/tmdb_repository/tmdb_repository.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/utils/delayed_runner.dart';
import 'package:cinemalist/widgets/collections/collection_picker_sheet.dart';
import 'package:cinemalist/widgets/generic/expandable_text.dart';
import 'package:cinemalist/widgets/generic/fab_go_home.dart';
import 'package:cinemalist/widgets/generic/genres_of_movie_list_widget.dart';
import 'package:cinemalist/widgets/generic/info_chip.dart';
import 'package:cinemalist/widgets/tv/similar_tv_shows_widget.dart';
import 'package:cinemalist/widgets/tv/tv_show_credits_widget.dart';
import 'package:cinemalist/widgets/tv/tv_show_seasons_widget.dart';

class TvShowPage extends StatefulWidget {
  final TVShowModel? model;

  const TvShowPage({this.model});

  @override
  State<TvShowPage> createState() => _TvShowPageState();
}

class _TvShowPageState extends State<TvShowPage> {
  final _runner = DelayedRunner(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    final tmdbRepo = context.read<TMDBRepository>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TvShowCreditsCubit(tmdbRepo, widget.model?.id)..loadData(),
        ),
        BlocProvider(
          create: (context) => TvSeasonsCubit(tmdbRepo, widget.model?.id)..loadData(),
        ),
        BlocProvider(
          create: (context) => SimilarTvShowsCubit(tmdbRepo, widget.model?.id)..loadData(),
        ),
      ],
      child: Scaffold(
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(context),
            _buildBody(),
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'save-tv-${widget.model!.id}',
              elevation: 4,
              backgroundColor: context.watch<CollectionsCubit>().state.isItemSaved(widget.model!.id!, CollectionItemType.tvShow)
                  ? AppColors.primary
                  : AppColors.card,
              onPressed: () => showCollectionPicker(
                context,
                CollectionItem(
                  id: widget.model!.id!,
                  type: CollectionItemType.tvShow,
                  title: widget.model!.name ?? '',
                  posterPath: widget.model!.posterPath,
                  rating: widget.model!.voteAverage,
                  addedAt: DateTime.now(),
                ),
              ),
              child: Icon(
                context.watch<CollectionsCubit>().state.isItemSaved(widget.model!.id!, CollectionItemType.tvShow)
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_add_outlined,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            const FABGoHome(),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildBody() {
    final show = widget.model!;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              show.name ?? '',
              style: Styles.heading.copyWith(fontSize: 32, color: AppColors.primaryLight),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 8),
            GenresOfMovieListWidget(genreIds: show.genreIds),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (show.firstAirDate != null && show.firstAirDate!.isNotEmpty)
                  InfoChip(
                    icon: Icons.calendar_today_rounded,
                    label: DateFormat.yMMMd().format(DateTime.parse(show.firstAirDate!)),
                    iconColor: AppColors.amber,
                  ),
                InfoChip(
                  icon: Icons.star_rounded,
                  label: (show.voteAverage ?? 0).toStringAsFixed(1),
                  iconColor: AppColors.ratingColor(show.voteAverage ?? 0),
                ),
                if (show.voteCount != null)
                  InfoChip(
                    icon: Icons.how_to_vote_rounded,
                    label: '${_formatCount(show.voteCount!)} votes',
                  ),
              ],
            ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
            const SizedBox(height: 16),
            ExpandableText(text: show.overview ?? '')
                .animate().fadeIn(delay: 200.ms, duration: 400.ms),
            const SizedBox(height: 24),
            Text('CAST', style: Styles.heading.copyWith(fontSize: 26, color: AppColors.primaryLight))
                .animate().fadeIn(delay: 300.ms, duration: 400.ms),
            const SizedBox(height: 12),
            TvShowCreditsWidget(),
            const SizedBox(height: 24),
            TvShowSeasonsWidget(tvShowModel: show),
            const SizedBox(height: 24),
            Text('SIMILAR TV SHOWS', style: Styles.heading.copyWith(fontSize: 26, color: AppColors.primaryLight))
                .animate().fadeIn(delay: 400.ms, duration: 400.ms),
            const SizedBox(height: 12),
            SimilarTvShowsWidget(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return count.toString();
  }

  SliverAppBar _buildAppBar(BuildContext context) {
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
          onTap: () => startTvShowChat(context, widget.model!),
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF3949AB).withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
            child: ShimmerGradient(
              colors: const [Colors.white, Color(0xFFCE93D8), Colors.white],
              child: const Icon(Icons.auto_awesome_rounded, size: 16),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Share.share('Check out "${widget.model!.name}" on TMDB!\nhttps://www.themoviedb.org/tv/${widget.model!.id}');
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
              widget.model!.name ?? '',
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
            CachedNetworkImage(
              imageUrl: 'https://image.tmdb.org/t/p/w500${widget.model!.posterPath}',
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: AppColors.card),
              errorWidget: (_, __, ___) => Container(color: AppColors.card),
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
