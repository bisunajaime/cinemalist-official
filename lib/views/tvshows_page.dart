import 'package:flutter/material.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/widgets/tv/tv_shows_list_widget.dart';

class TvShowsPage extends StatefulWidget {
  const TvShowsPage();
  @override
  State<TvShowsPage> createState() => _TvShowsPageState();
}

class _TvShowsPageState extends State<TvShowsPage>
    with AutomaticKeepAliveClientMixin {
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
            expandedHeight: MediaQuery.of(context).size.height * 0.18,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              collapseMode: CollapseMode.parallax,
              title: Align(
                alignment: Alignment.bottomLeft,
                child: _buildTitle(),
              ),
            ),
          ),
        ];
      },
      body: const TvShowsListWidget(),
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
            'TV SHOWS',
            style: Styles.mBold.copyWith(
              color: AppColors.primaryLight,
              fontSize: 10,
              letterSpacing: 2,
            ),
          ),
          Text(
            'Discover',
            style: Styles.heading.copyWith(fontSize: 28),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
