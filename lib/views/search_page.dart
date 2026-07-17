import 'package:flutter/material.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/widgets/search/search_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage();
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
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
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.18,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              collapseMode: CollapseMode.none,
              title: Align(
                alignment: Alignment.bottomLeft,
                child: _buildTitle(),
              ),
            ),
          ),
          SliverPersistentHeader(
            delegate: SearchHeaderDelegate(62),
            pinned: true,
          ),
        ];
      },
      body: const SearchWidget(),
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
            'SEARCH',
            style: Styles.mBold.copyWith(
              color: AppColors.primaryLight,
              fontSize: 10,
              letterSpacing: 2,
            ),
          ),
          Text(
            'Find everything',
            style: Styles.heading.copyWith(fontSize: 28),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  SearchHeaderDelegate(this.height);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return const SearchField();
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
