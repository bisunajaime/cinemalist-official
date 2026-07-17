import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinemalist/bloc/search/search_cubit.dart';
import 'package:cinemalist/models/generic_actor_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/views/actor_info_page.dart';
import 'package:cinemalist/widgets/generic/actor_preview_sheet.dart';

class ActorSearchResultsWidget extends StatelessWidget {
  const ActorSearchResultsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SearchCubit>();
    final actors = cubit.actorResults;

    if (cubit.loading || actors == null || actors.isEmpty) {
      return SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Shimmer.fromColors(
              baseColor: AppColors.shimmerBase,
              highlightColor: AppColors.shimmerHighlight,
              child: const CircleAvatar(radius: 35),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, i) {
          final actor = actors[i];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                AppRoutes.slideUp(ActorInfoPage(
                  id: actor.id,
                  name: actor.name,
                  model: GenericActorModel.fromActorModel(actor),
                )),
              ),
              onLongPress: () => showActorPreview(context, actor),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.card,
                    backgroundImage: actor.profilePath != null
                        ? NetworkImage('https://image.tmdb.org/t/p/w200${actor.profilePath}')
                        : null,
                    radius: 35,
                    child: actor.profilePath == null
                        ? const Icon(Icons.person, color: AppColors.textMuted)
                        : null,
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 70,
                    child: Text(
                      actor.name ?? '',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.mMed.copyWith(fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
