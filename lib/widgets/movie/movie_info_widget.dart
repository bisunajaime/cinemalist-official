import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdbflutter/bloc/movies/info/movie_info_cubit.dart';
import 'package:tmdbflutter/views/youtube_page.dart';

class MovieInfoWidget extends StatelessWidget {
  const MovieInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<MovieInfoCubit>();
    final info = cubit.state;
    if (cubit.isLoading) {
      // TODO: Use shimmer or something
      return CircularProgressIndicator();
    }
    if (cubit.error) {
      return Text('there was a problem');
    }
    info!;
    if (info.videos?.results == null ||
        info.videos?.results?.isEmpty != false) {
      return Text('no videos');
    }
    return Container(
      height: 120,
      width: double.infinity,
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 8,
          );
        },
        itemCount: info.videos!.results!.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final videoResult = info.videos?.results?[index];
          return Padding(
            padding: index == 0 ? EdgeInsets.only(left: 8) : EdgeInsets.zero,
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => YoutubePage(
                            ytKey: videoResult?.key,
                            title: videoResult?.name,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.pinkAccent[400]!,
                            Colors.redAccent,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 160,
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                          Expanded(child: SizedBox()),
                          Text(
                            'Trailer #${index + 1}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
