import 'package:flutter/material.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/widgets/saved/saved_records_widget.dart';

class SavedRecordsPage extends StatefulWidget {
  const SavedRecordsPage({super.key});

  @override
  State<SavedRecordsPage> createState() => _SavedRecordsPageState();
}

class _SavedRecordsPageState extends State<SavedRecordsPage>
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
      body: const SavedRecordsWidget(),
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
            'SAVED',
            style: Styles.mBold.copyWith(
              color: AppColors.primaryLight,
              fontSize: 10,
              letterSpacing: 2,
            ),
          ),
          Text(
            'Watch Later',
            style: Styles.heading.copyWith(fontSize: 28),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
