import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cinemalist/models/actors_model.dart';
import 'package:cinemalist/models/generic_actor_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/views/actor_info_page.dart';

Future<void> showActorPreview(
  BuildContext context,
  ActorsModel actor, {
  List<ActorsModel>? list,
  int? initialIndex,
}) async {
  HapticFeedback.mediumImpact();
  final actors = list ?? [actor];
  final index = initialIndex ?? 0;
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _ActorPreviewPager(actors: actors, initialIndex: index, parentContext: context),
  );
}

Future<void> showGenericActorPreview(
  BuildContext context,
  GenericActorModel actor, {
  List<GenericActorModel>? list,
  int? initialIndex,
}) async {
  HapticFeedback.mediumImpact();
  final actors = list ?? [actor];
  final index = initialIndex ?? 0;
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _GenericActorPreviewPager(actors: actors, initialIndex: index, parentContext: context),
  );
}

// Pager for ActorsModel
class _ActorPreviewPager extends StatefulWidget {
  final List<ActorsModel> actors;
  final int initialIndex;
  final BuildContext parentContext;
  const _ActorPreviewPager({required this.actors, required this.initialIndex, required this.parentContext});
  @override
  State<_ActorPreviewPager> createState() => _ActorPreviewPagerState();
}

class _ActorPreviewPagerState extends State<_ActorPreviewPager> {
  late final PageController _controller;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final hasMultiple = widget.actors.length > 1;
    return Container(
      decoration: const BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textMuted.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
          if (hasMultiple) ...[
            const SizedBox(height: 6),
            Text('${_currentIndex + 1} / ${widget.actors.length}', style: Styles.mReg.copyWith(fontSize: 11, color: AppColors.textMuted)),
          ],
          const SizedBox(height: 8),
          SizedBox(
            height: 320,
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.actors.length,
              onPageChanged: (i) { HapticFeedback.selectionClick(); setState(() => _currentIndex = i); },
              itemBuilder: (_, i) {
                final a = widget.actors[i];
                return _ActorContent(
                  name: a.name ?? '', profilePath: a.profilePath, department: a.department, popularity: a.popularity,
                  onViewDetails: () {
                    Navigator.pop(context);
                    Navigator.push(widget.parentContext, AppRoutes.slideUp(ActorInfoPage(id: a.id, name: a.name, model: GenericActorModel.fromActorModel(a))));
                  },
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}

// Pager for GenericActorModel
class _GenericActorPreviewPager extends StatefulWidget {
  final List<GenericActorModel> actors;
  final int initialIndex;
  final BuildContext parentContext;
  const _GenericActorPreviewPager({required this.actors, required this.initialIndex, required this.parentContext});
  @override
  State<_GenericActorPreviewPager> createState() => _GenericActorPreviewPagerState();
}

class _GenericActorPreviewPagerState extends State<_GenericActorPreviewPager> {
  late final PageController _controller;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final hasMultiple = widget.actors.length > 1;
    return Container(
      decoration: const BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.textMuted.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
          if (hasMultiple) ...[
            const SizedBox(height: 6),
            Text('${_currentIndex + 1} / ${widget.actors.length}', style: Styles.mReg.copyWith(fontSize: 11, color: AppColors.textMuted)),
          ],
          const SizedBox(height: 8),
          SizedBox(
            height: 320,
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.actors.length,
              onPageChanged: (i) { HapticFeedback.selectionClick(); setState(() => _currentIndex = i); },
              itemBuilder: (_, i) {
                final a = widget.actors[i];
                return _ActorContent(
                  name: a.name ?? '', profilePath: a.profilePath,
                  onViewDetails: () {
                    Navigator.pop(context);
                    Navigator.push(widget.parentContext, AppRoutes.slideUp(ActorInfoPage(id: a.id, name: a.name, model: a)));
                  },
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}

class _ActorContent extends StatelessWidget {
  final String name;
  final String? profilePath;
  final String? department;
  final double? popularity;
  final VoidCallback onViewDetails;

  const _ActorContent({required this.name, this.profilePath, this.department, this.popularity, required this.onViewDetails});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.3), width: 3),
              boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 20)],
            ),
            child: CircleAvatar(
              radius: 56,
              backgroundColor: AppColors.card,
              child: profilePath != null
                  ? ClipOval(child: CachedNetworkImage(imageUrl: 'https://image.tmdb.org/t/p/w300$profilePath', fit: BoxFit.cover, width: 112, height: 112))
                  : const Icon(Icons.person_rounded, color: AppColors.textMuted, size: 48),
            ),
          ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.85, 0.85)),
          const SizedBox(height: 16),
          Text(name, style: Styles.heading.copyWith(fontSize: 28, color: AppColors.primaryLight), textAlign: TextAlign.center)
              .animate(delay: 100.ms).fadeIn(duration: 300.ms),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8, alignment: WrapAlignment.center,
            children: [
              if (department != null) _Chip(icon: Icons.work_rounded, label: department!),
              if (popularity != null && popularity! > 0) _Chip(
                icon: Icons.trending_up_rounded, label: popularity!.toStringAsFixed(1),
                iconColor: popularity! > 10 ? AppColors.success : AppColors.amber,
              ),
            ],
          ).animate(delay: 150.ms).fadeIn(duration: 300.ms),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onViewDetails,
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: Text('View Full Profile', style: Styles.mBold.copyWith(fontSize: 14)),
            ),
          ).animate(delay: 200.ms).fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;
  const _Chip({required this.icon, required this.label, this.iconColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: iconColor ?? AppColors.primaryLight),
        const SizedBox(width: 5),
        Text(label, style: Styles.mMed.copyWith(fontSize: 12)),
      ]),
    );
  }
}
