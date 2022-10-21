import 'package:cinemalist/utils/url_opener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

final tmdbSvg = SvgPicture.asset('assets/tmdb/tmdb_attribution_img.svg');
final tmdbNoticeMessage =
    'This product uses the TMDB API but is not endorsed or certified by TMDB.';

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
