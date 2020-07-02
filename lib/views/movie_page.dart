import 'package:flutter/material.dart';
import 'package:tmdbflutter/styles/styles.dart';

import '../barrels/models.dart';

class MoviePage extends StatelessWidget {
  final GenericMoviesModel model;
  final String tag;

  MoviePage({
    this.model,
    this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0E0E0E),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * .7,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                color: Color(0xff0E0E0E),
                height: double.infinity,
                width: double.infinity,
                child: Hero(
                  tag: tag,
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black,
                          Colors.transparent,
                        ],
                      ).createShader(
                        Rect.fromLTRB(
                          0,
                          0,
                          rect.width,
                          rect.height,
                        ),
                      );
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500${model.posterPath}',
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    model.title,
                    style: Styles.mBold.copyWith(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        model.releaseDate,
                        style: Styles.mMed.copyWith(
                          fontSize: 12,
                          color: Colors.amber,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 12,
                          ),
                          Text(
                            model.voteAverage.toString(),
                            style: Styles.mBold.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Overview',
                    style: Styles.mBold.copyWith(
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    model.overview,
                    style: Styles.mReg.copyWith(
                      fontSize: 10,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(
                    height: 1000,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
