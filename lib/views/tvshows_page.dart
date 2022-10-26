import 'package:cinemalist/widgets/sliver/cinemalist_sliver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/widgets/tv/tv_shows_list_widget.dart';

class TvShowsPage extends StatefulWidget {
  @override
  State<TvShowsPage> createState() => _TvShowsPageState();
}

class _TvShowsPageState extends State<TvShowsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CinemalistSliverAppBar(
      body: TvShowsListWidget(),
      topText: 'TV SHOWS',
      bottomText: 'Discover',
    );
  }

  @override
  bool get wantKeepAlive => true;
}
