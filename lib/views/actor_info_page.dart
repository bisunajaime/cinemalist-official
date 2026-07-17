import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/bloc/actors/actor_info_cubit.dart';
import 'package:cinemalist/bloc/actors/actor_movies_cubit.dart';
import 'package:cinemalist/bloc/collections/collections_cubit.dart';
import 'package:cinemalist/models/collections/collection_models.dart';
import 'package:cinemalist/models/generic_actor_model.dart';
import 'package:cinemalist/repository/tmdb_repository/tmdb_repository.dart';
import 'package:cinemalist/utils/delayed_runner.dart';
import 'package:cinemalist/widgets/actor_info/actor_info_widget.dart';
import 'package:cinemalist/widgets/actor_info/actor_movies_widget.dart';
import 'package:cinemalist/widgets/chat/start_chat_button.dart';
import 'package:cinemalist/widgets/collections/collection_picker_sheet.dart';
import 'package:cinemalist/widgets/generic/fab_go_home.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';

class ActorInfoPage extends StatefulWidget {
  final int? id;
  final String? name;
  final GenericActorModel model;
  const ActorInfoPage({
    this.id,
    required this.name,
    required this.model,
  });
  @override
  State<ActorInfoPage> createState() => _ActorInfoPageState();
}

class _ActorInfoPageState extends State<ActorInfoPage> {
  final _runner = DelayedRunner(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    final tmdbRepo = context.read<TMDBRepository>();
    final hasPhoto = widget.model.profilePath != null;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ActorInfoCubit(tmdbRepo, widget.id)..loadData(),
        ),
        BlocProvider(
          create: (context) => ActorMoviesCubit(tmdbRepo, widget.id)..loadData(),
        ),
      ],
      child: Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'ai-${widget.id}',
              elevation: 4,
              backgroundColor: const Color(0xFF3949AB),
              onPressed: () => startActorChat(context, widget.name ?? '', widget.id!, widget.model.profilePath),
              child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            FloatingActionButton(
              heroTag: 'save-actor-${widget.id}',
              elevation: 4,
              backgroundColor: context.watch<CollectionsCubit>().state.isItemSaved(widget.id!, CollectionItemType.actor)
                  ? AppColors.primary
                  : AppColors.card,
              onPressed: () => showCollectionPicker(
                context,
                CollectionItem(
                  id: widget.id!,
                  type: CollectionItemType.actor,
                  title: widget.name ?? '',
                  posterPath: widget.model.profilePath,
                  addedAt: DateTime.now(),
                ),
              ),
              child: Icon(
                context.watch<CollectionsCubit>().state.isItemSaved(widget.id!, CollectionItemType.actor)
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_add_outlined,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            const FABGoHome(),
          ],
        ),
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                centerTitle: false,
                expandedHeight: MediaQuery.of(context).size.height * 0.25,
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.zero,
                  collapseMode: CollapseMode.parallax,
                  centerTitle: false,
                  title: Align(
                    alignment: Alignment.bottomLeft,
                    child: _buildTitle(),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (hasPhoto)
                        ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: CachedNetworkImage(
                            imageUrl: 'https://image.tmdb.org/t/p/w300${widget.model.profilePath}',
                            fit: BoxFit.cover,
                            color: Colors.black45,
                            colorBlendMode: BlendMode.darken,
                          ),
                        )
                      else
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF2C2458), Color(0xFF1A1640)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.6),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: ListView(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            children: [
              const ActorInfoWidget(),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'FILMOGRAPHY',
                  textAlign: TextAlign.center,
                  style: Styles.heading.copyWith(fontSize: 28),
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
              const SizedBox(height: 12),
              const ActorMoviesWidget(),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            widget.name ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Styles.mBold.copyWith(
              color: AppColors.gold,
              fontSize: 11,
            ),
          ),
          Text(
            'Actor Details',
            maxLines: 1,
            style: Styles.heading.copyWith(fontSize: 24),
          ),
        ],
      ),
    );
  }
}
