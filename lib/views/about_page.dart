import 'package:cinemalist/widgets/about/app_plugin_licenses_widget.dart';
import 'package:cinemalist/widgets/about/tmdb_attribution_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cinemalist/utils/url_opener.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff01b4e4),
        title: Text('About'),
        centerTitle: false,
      ),
      backgroundColor: Color(0xff0E0E0E),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // AboutTheApp(),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 28),
          //   child: Divider(
          //     color: Colors.white,
          //   ),
          // ),
          TMDbAttributionWidget(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28),
            child: Divider(
              color: Colors.white,
            ),
          ),
          AppPluginLicensesWidget(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28),
            child: Divider(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// todo:
class AboutTheApp extends StatelessWidget {
  const AboutTheApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 18),
        Text(
          'About The App',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Personal project',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 18),
      ],
    );
  }
}
