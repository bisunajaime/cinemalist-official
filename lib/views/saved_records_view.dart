import 'package:flutter/material.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/widgets/saved/saved_records_widget.dart';

class SavedRecordsPage extends StatelessWidget {
  const SavedRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Items', style: Styles.heading.copyWith(fontSize: 26)),
        centerTitle: false,
      ),
      body: const SavedRecordsWidget(),
    );
  }
}
