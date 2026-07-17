import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cinemalist/bloc/ranking/actor_ranking_cubit.dart';
import 'package:cinemalist/bloc/ranking/movie_ranking_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/bloc/ranking/ranking_cubit.dart';
import 'package:cinemalist/bloc/ranking/ranking_filter_cubit.dart';
import 'package:cinemalist/bloc/ranking/tvshow_ranking_cubit.dart';
import 'package:cinemalist/models/ranking_model.dart';
import 'package:cinemalist/widgets/ranking/ranking_filter_bar.dart';
import 'package:cinemalist/widgets/ranking/ranking_image_widget.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';

const _tiers = [
  _TierDef('s', Color(0xffF08683), Color(0xffE05550)),
  _TierDef('a', Color(0xffF5C188), Color(0xffE8A055)),
  _TierDef('b', Color(0xffFAE08C), Color(0xffE8C84A)),
  _TierDef('c', Color(0xffFFFF91), Color(0xffD4D44A)),
  _TierDef('d', Color(0xffCCFD8F), Color(0xff8CC84A)),
  _TierDef('f', Color(0xffA0FD8E), Color(0xff5CB840)),
];

class _TierDef {
  final String letter;
  final Color color;
  final Color darkColor;
  const _TierDef(this.letter, this.color, this.darkColor);
}

class VerticalRankingWidget extends StatelessWidget {
  const VerticalRankingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: _tiers.asMap().entries.map((entry) {
          final tier = entry.value;
          return _TierRow(
            letter: tier.letter,
            color: tier.color,
            darkColor: tier.darkColor,
          ).animate(delay: (60 * entry.key).ms)
              .fadeIn(duration: 300.ms)
              .slideX(begin: -0.05, end: 0);
        }).toList(),
      ),
    );
  }
}

class _TierRow extends StatefulWidget {
  final String letter;
  final Color color;
  final Color darkColor;
  const _TierRow({required this.letter, required this.color, required this.darkColor});

  @override
  State<_TierRow> createState() => _TierRowState();
}

class _TierRowState extends State<_TierRow> {
  bool _isDragHovering = false;

  RankingCubit _getCubit(BuildContext context, RankingFilterCubit filterCubit) {
    final filter = filterCubit.state;
    if (filter == RankingFilter.actors) return context.watch<ActorRankingCubit>();
    if (filter == RankingFilter.tvShows) return context.watch<TvShowRankingCubit>();
    return context.watch<MovieRankingCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final filterCubit = context.watch<RankingFilterCubit>();
    final rankingCubit = _getCubit(context, filterCubit);
    final items = rankingCubit.state[widget.letter] ?? [];

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 88,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [widget.color, widget.darkColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.letter.toUpperCase(),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DragTarget<RankingModel>(
              onWillAcceptWithDetails: (details) {
                final exists = rankingCubit.state[widget.letter]?.contains(details.data);
                if (exists != true && !_isDragHovering) {
                  setState(() => _isDragHovering = true);
                }
                return exists != true;
              },
              onAcceptWithDetails: (details) async {
                setState(() => _isDragHovering = false);
                await rankingCubit.saveRanking(widget.letter, details.data);
              },
              onLeave: (_) => setState(() => _isDragHovering = false),
              builder: (context, candidateData, __) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 88,
                  decoration: BoxDecoration(
                    color: _isDragHovering
                        ? widget.color.withValues(alpha: 0.1)
                        : AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isDragHovering
                          ? widget.color.withValues(alpha: 0.5)
                          : AppColors.card,
                      width: 2,
                    ),
                  ),
                  child: items.isEmpty
                      ? Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_rounded,
                                size: 16,
                                color: AppColors.textMuted.withValues(alpha: 0.4),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Drop here',
                                style: Styles.mReg.copyWith(
                                  fontSize: 12,
                                  color: AppColors.textMuted.withValues(alpha: 0.4),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ReorderableListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            onReorder: (oldIndex, newIndex) async {
                              await rankingCubit.updateRankingIndex(
                                  widget.letter, oldIndex, newIndex);
                            },
                            itemCount: items.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return GestureDetector(
                                key: Key('${widget.letter}|$index|${item.id}'),
                                onDoubleTap: () async {
                                  await rankingCubit.removeRanking(widget.letter, item);
                                },
                                child: Draggable<RankingModel>(
                                  data: item,
                                  feedback: Material(
                                    color: Colors.transparent,
                                    child: Opacity(
                                      opacity: 0.85,
                                      child: RankingImageWidget(model: item),
                                    ),
                                  ),
                                  childWhenDragging: Opacity(
                                    opacity: 0.3,
                                    child: RankingImageWidget(model: item),
                                  ),
                                  child: RankingImageWidget(model: item),
                                ),
                              );
                            },
                          ),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
