import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/barrels/genres_barrel.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/views/genres_page.dart';

class GenresListWidget extends StatelessWidget {
  const GenresListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<GenresCubit>();
    final genres = cubit.state;
    if (cubit.isLoading) {
      return Container(
        height: MediaQuery.of(context).size.height * .05,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: 6,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, i) {
            return Container(
              height: double.infinity,
              width: 50,
              color: Colors.grey,
              margin: EdgeInsets.symmetric(horizontal: 2),
              child: Shimmer.fromColors(
                child: Container(
                  color: Colors.white,
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
      return Center(
        child: Text('Failed to load genres'),
      );
    }
    genres!;

    return Container(
      height: MediaQuery.of(context).size.height * .1,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: genres.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          final genre = genres[i];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GenresPage(
                  id: genre.id,
                  genre: genre.name,
                ),
              ),
            ),
            child: Container(
              width: 200,
              padding: EdgeInsets.only(
                left: 8,
                right: 30,
                bottom: 8,
              ),
              margin: EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                // image: genre.genreImage == null
                //     ? null
                //     : DecorationImage(
                //         image: NetworkImage(
                //             'https://image.tmdb.org/t/p/w500${genre.genreImage}'),
                //         fit: BoxFit.cover,
                //       ),
                gradient: LinearGradient(
                  colors: [
                    Colors.pinkAccent[400]!,
                    Colors.redAccent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pinkAccent,
                  ),
                ],
              ),
              alignment: Alignment.bottomLeft,
              child: Text(
                genre.name!,
                style: Styles.mBold.copyWith(
                  fontSize: 20,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
