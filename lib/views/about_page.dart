import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/utils/url_opener.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0277BD),
        title: Text('About', style: Styles.mBold),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Image.asset(
            'assets/tmdb/tmdb_attribution_logo.png',
            height: 180,
          ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.9, 0.9)),
          const SizedBox(height: 24),
          Text(
            'TMDb Attribution',
            textAlign: TextAlign.center,
            style: Styles.heading.copyWith(fontSize: 26),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          const SizedBox(height: 16),
          Text(
            'This product uses the TMDB API but is not endorsed or certified by TMDB.',
            textAlign: TextAlign.center,
            style: Styles.mReg.copyWith(
              fontSize: 15,
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
          const SizedBox(height: 24),
          Center(
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF0277BD),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                await openUrl('https://www.themoviedb.org/');
              },
              icon: const Icon(Icons.open_in_new_rounded, size: 18),
              label: Text('Visit TMDB', style: Styles.mBold.copyWith(fontSize: 14)),
            ),
          ).animate(delay: 400.ms).fadeIn(duration: 400.ms),
          const SizedBox(height: 32),
          const Divider(color: AppColors.cardLight),
          const SizedBox(height: 16),
          Text(
            'Cinemalist v2.0.0',
            textAlign: TextAlign.center,
            style: Styles.mMed.copyWith(color: AppColors.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
