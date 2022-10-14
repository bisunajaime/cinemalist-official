import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinemalist/barrels/genres_barrel.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/utils/genre_utils.dart';
import 'package:cinemalist/views/genres_page.dart';

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
      height: 180,
      width: MediaQuery.of(context).size.width,
      child: GridView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: genres.length,
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 130,
          childAspectRatio: 0.5,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: grabColorForGenre(genre.name!),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pinkAccent,
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.bottomLeft,
              child: Text(
                genre.name!,
                style: Styles.mBold.copyWith(
                  fontSize: 16,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
