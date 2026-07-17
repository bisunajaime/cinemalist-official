import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinemalist/bloc/movies/nowshowing/nowshowing_bloc.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/widgets/movies/now_showing_movies_list_widget.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage();
  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage>
    with AutomaticKeepAliveClientMixin<MoviesPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NestedScrollView(
      physics: const BouncingScrollPhysics(),
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            backgroundColor: AppColors.background,
            automaticallyImplyLeading: false,
            pinned: true,
            centerTitle: false,
            expandedHeight: MediaQuery.of(context).size.height * 0.18,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              collapseMode: CollapseMode.parallax,
              centerTitle: false,
              title: Align(
                alignment: Alignment.bottomLeft,
                child: _buildTitle(),
              ),
            ),
          ),
        ];
      },
      body: const NowShowingMoviesListWidget(),
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
            'MOVIES',
            style: Styles.mBold.copyWith(
              color: AppColors.primaryLight,
              fontSize: 10,
              letterSpacing: 2,
            ),
          ),
          Text(
            'Now Playing',
            style: Styles.heading.copyWith(fontSize: 28),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
