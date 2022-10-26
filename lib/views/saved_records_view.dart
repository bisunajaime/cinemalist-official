import 'package:cinemalist/widgets/sliver/cinemalist_sliver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/widgets/saved/saved_records_widget.dart';

class SavedRecordsPage extends StatefulWidget {
  const SavedRecordsPage({Key? key}) : super(key: key);

  @override
  State<SavedRecordsPage> createState() => _SavedRecordsPageState();
}

class _SavedRecordsPageState extends State<SavedRecordsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CinemalistSliverAppBar(
      body: SavedRecordsWidget(),
      topText: 'SAVED',
      bottomText: 'Check it out for later',
    );
  }

  @override
  bool get wantKeepAlive => true;
}
