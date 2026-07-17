import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinemalist/bloc/tvshows/credits/tvshow_credits_bloc.dart';
import 'package:cinemalist/models/generic_actor_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/styles/theme.dart';
import 'package:cinemalist/views/actor_info_page.dart';

class TvShowCreditsWidget extends StatelessWidget {
  const TvShowCreditsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TvShowCreditsCubit>();
    final tvShowCredits = cubit.state;
    if (cubit.loading) {
      return Container(
        height: 150,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 9,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: AspectRatio(
                aspectRatio: 2 / 3,
                child: Shimmer.fromColors(
                  child: Container(),
                  baseColor: AppColors.shimmerBase,
                  highlightColor: AppColors.shimmerHighlight,
                ),
              ),
            );
          },
        ),
      );
    }
    tvShowCredits!;
    int castsSize = tvShowCredits.casts!.length;

    return Container(
      height: 150,
      width: double.infinity,
      child: castsSize == 0
          ? Container(
              width: double.infinity,
              height: double.infinity,
              color: AppColors.card,
              child: Center(
                child: Text(
                  'Casts Not Updated',
                  style: Styles.mBold,
                ),
              ),
            )
          : ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: tvShowCredits.casts!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                if (tvShowCredits.casts!.length == 0) {}
                final model = tvShowCredits.casts![i];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      AppRoutes.slideUp(ActorInfoPage(
                          id: model.id,
                          name: model.name,
                          model: GenericActorModel.fromCastModel(model),
                        )),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: double.infinity,
                            width: 100,
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              image: DecorationImage(
                                image: (model.profilePath == null
                                        ? AssetImage(
                                            'assets/images/placeholder_actor.png')
                                        : NetworkImage(
                                            'https://image.tmdb.org/t/p/w500${model.profilePath}'))
                                    as ImageProvider<Object>,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          model.name!,
                          style: Styles.mReg.copyWith(
                            fontSize: 10,
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
