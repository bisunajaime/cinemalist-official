import 'package:cinemalist/widgets/sliver/cinemalist_sliver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/views/about_page.dart';
import 'package:cinemalist/views/ranking_page.dart';

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CinemalistSliverAppBar(
      body: MoreBody(),
      topText: 'Get to know',
      bottomText: 'More about the app',
    );
  }
}

class MoreBody extends StatelessWidget {
  const MoreBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MoreFeaturesButton(
          text: 'Rank your saved\nmovies, tv shows, and actors',
          icon: Icons.bar_chart,
          color: Color(0xffa2009a),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return RankingPage();
            }));
          },
        ),
        SizedBox(height: 16),
        MoreFeaturesButton(
          text: 'About the app',
          icon: Icons.info,
          color: Color(0xff01b4e4),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return AboutPage();
              },
            ));
          },
        ),
      ],
    );
  }
}

class MoreFeaturesButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const MoreFeaturesButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 18),
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
