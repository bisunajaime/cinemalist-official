import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/bloc/theme/theme_cubit.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/views/about_page.dart';
import 'package:cinemalist/views/ranking_page.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      physics: const BouncingScrollPhysics(),
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            centerTitle: false,
            expandedHeight: MediaQuery.of(context).size.height * 0.18,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              collapseMode: CollapseMode.parallax,
              centerTitle: false,
              title: Align(
                alignment: Alignment.bottomLeft,
                child: _buildTitle(context),
              ),
            ),
          ),
        ];
      },
      body: _MoreBody(),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'EXPLORE',
            style: Styles.mBold.copyWith(
              color: context.primaryLightColor,
              fontSize: 10,
              letterSpacing: 2,
            ),
          ),
          Text(
            'More',
            style: Styles.heading.copyWith(fontSize: 28, color: context.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _MoreBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _FeatureCard(
            title: 'Rank your favorites',
            subtitle: 'Movies, TV Shows & Actors',
            icon: Icons.bar_chart_rounded,
            gradient: [const Color(0xFFAD1457), const Color(0xFF880E4F)],
            onTap: () => Navigator.push(context, AppRoutes.slideUp(const RankingPage())),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
          const SizedBox(height: 16),
          _FeatureCard(
            title: 'About Cinemalist',
            subtitle: 'Credits & Attribution',
            icon: Icons.info_outline_rounded,
            gradient: [const Color(0xFF0277BD), const Color(0xFF01579B)],
            onTap: () => Navigator.push(context, AppRoutes.slideUp(const AboutPage())),
          ).animate(delay: 100.ms).fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
          const SizedBox(height: 16),
          _ThemeToggleCard(
            isDark: themeCubit.isDark,
            onToggle: () => themeCubit.toggle(),
          ).animate(delay: 200.ms).fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
        ],
      ),
    );
  }
}

class _ThemeToggleCard extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggle;

  const _ThemeToggleCard({required this.isDark, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.primaryColor.withValues(alpha: 0.2),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    key: ValueKey(isDark),
                    color: context.primaryLightColor,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isDark ? 'Dark Mode' : 'Light Mode',
                      style: Styles.mBold.copyWith(fontSize: 16, color: context.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isDark ? 'Tap to switch to light' : 'Tap to switch to dark',
                      style: Styles.mReg.copyWith(fontSize: 12, color: context.textSecondary),
                    ),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  isDark ? Icons.toggle_off_rounded : Icons.toggle_on_rounded,
                  key: ValueKey(isDark),
                  color: context.primaryLightColor,
                  size: 36,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: gradient.first.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Styles.mBold.copyWith(fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: Styles.mReg.copyWith(fontSize: 12, color: Colors.white70)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
