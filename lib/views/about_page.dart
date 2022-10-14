import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tmdbflutter/utils/url_opener.dart';

final tmdbSvg = SvgPicture.asset('assets/tmdb/tmdb_attribution_img.svg');
final tmdbNoticeMessage =
    'This product uses the TMDB API but is not endorsed or certified by TMDB.';

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
          )
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

class TMDbAttributionWidget extends StatelessWidget {
  const TMDbAttributionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 24),
        Text(
          'TMDb Attribution',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        Image.asset(
          'assets/tmdb/tmdb_attribution_logo.png',
          height: 230,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: Text(
            tmdbNoticeMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 24),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Color(0xff01b4e4),
            padding: EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 32,
            ),
          ),
          onPressed: () async {
            final tmdbUrl = 'https://www.themoviedb.org/';
            await openUrl(tmdbUrl);
          },
          child: Text(
            'Check it out here',
            style: TextStyle(
              color: Color(0xff0d253f),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
