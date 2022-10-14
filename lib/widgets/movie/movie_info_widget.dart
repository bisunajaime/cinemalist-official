import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/bloc/movies/info/movie_info_cubit.dart';
import 'package:cinemalist/models/movieinfo/MovieInfo.dart';
import 'package:cinemalist/models/movieinfo/Result.dart';
import 'package:cinemalist/utils/link_sharing.dart';
import 'package:cinemalist/utils/url_opener.dart';
import 'package:cinemalist/views/youtube_page.dart';
import 'package:cinemalist/widgets/dialogs/dialogs.dart';

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
                      width: 200,
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await openLink(
                                          context, info, videoResult);
                                    },
                                    onLongPress: () {
                                      Clipboard.setData(ClipboardData(
                                              text: videoResult!
                                                  .youtubeTrailerUrl))
                                          .then((value) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Successfully copied link')));
                                      });
                                    },
                                    child: Icon(
                                      Icons.link,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                  SizedBox(width: 14),
                                  GestureDetector(
                                    onTap: () {
                                      shareTrailerLink(
                                        info.title!,
                                        videoResult!.name!,
                                        videoResult.youtubeTrailerUrl,
                                      );
                                    },
                                    child: Icon(
                                      Icons.share,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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

  Future<void> openLink(
      BuildContext context, MovieInfo info, Result? videoResult) async {
    if (videoResult?.key == null) return;
    await openUrl(videoResult!.youtubeTrailerUrl);
  }
}
