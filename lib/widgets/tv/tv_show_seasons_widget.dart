import 'package:cinemalist/utils/poster_path_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinemalist/bloc/tvshows/seasons/tvseasons_bloc.dart';
import 'package:cinemalist/models/tvshow_model.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/views/seasoninfo_page.dart';

class TvShowSeasonsWidget extends StatelessWidget {
  final TVShowModel tvShowModel;
  const TvShowSeasonsWidget({Key? key, required this.tvShowModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TvSeasonsCubit>();
    final tvSeasons = cubit.state;

    if (cubit.isLoading) {
      return Container(
        height: 100,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: CircleAvatar(
                radius: 35,
                backgroundColor: Colors.grey,
                child: Shimmer.fromColors(
                  child: Container(),
                  baseColor: Color(0xff313131),
                  highlightColor: Color(0xff4A4A4A),
                ),
              ),
            );
          },
        ),
      );
    }
    if (cubit.error) {
      return Text('todo reload');
    }
    tvSeasons!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            '${tvSeasons.length} Seasons',
            style: Styles.mBold.copyWith(
              fontSize: 20,
              color: Colors.pinkAccent[100],
            ),
          ),
        ),
        Container(
          height: 200,
          width: double.infinity,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: tvSeasons.length,
            itemBuilder: (context, i) {
              final model = tvSeasons[i];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SeasonInfoPage(
                      index: i,
                      tvSeasons: tvSeasons,
                      tvShow: model,
                      name: tvShowModel.name,
                    ),
                  ),
                ),
                child: Container(
                  height: double.infinity,
                  width: 130,
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color(0xff2e2e2e),
                    image: DecorationImage(
                        image: (model.posterPath == null
                            ? AssetImage('assets/images/placeholder.png')
                            : NetworkImage(PosterPathHelper.generatePosterPath(
                                model.posterPath))) as ImageProvider<Object>,
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black26,
                          BlendMode.darken,
                        )),
                  ),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    model.name!,
                    style: Styles.mBold,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
