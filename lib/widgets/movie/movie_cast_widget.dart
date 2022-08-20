import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/bloc/movies/cast/movie_cast_cubit.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/views/actor_info_page.dart';

class MovieCastWidget extends StatelessWidget {
  const MovieCastWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<MovieCastCubit>();
    final cast = cubit.state;
    if (cubit.isLoading) {
      return Container(
        height: 150,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Shimmer.fromColors(
                child: Container(
                  height: double.infinity,
                  width: 100,
                ),
                baseColor: Color(0xff313131),
                highlightColor: Color(0xff4A4A4A),
              ),
            );
          },
        ),
      );
    }
    if (cubit.error) {
      return Text('there was a problem');
    }
    cast!;

    return Container(
      height: 150,
      width: double.infinity,
      child: cast.length == 0
          ? Container(
              width: double.infinity,
              height: double.infinity,
              color: Color(0xff252525),
              child: Center(
                child: Text(
                  'Casts Not Updated',
                  style: Styles.mBold,
                ),
              ),
            )
          : ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: cast.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                if (cast.length == 0) {}
                final model = cast[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActorInfoPage(
                                id: model.id,
                              )),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: double.infinity,
                            width: 100,
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://image.tmdb.org/t/p/w500${model.profilePath}',
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Image(
                                  image: AssetImage(
                                'assets/images/placeholder_actor.png',
                              )),
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
