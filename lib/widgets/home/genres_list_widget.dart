import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/barrels/genres_barrel.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/views/genres_page.dart';

const genreColorPair = <String, List<Color>>{
  'action': [Colors.pinkAccent, Colors.redAccent],
  'adventure': [Color(0xff4FA380), Color(0xff7BD097)],
  'animation': [Colors.blueAccent, Colors.blue],
  'comedy': [Colors.red, Colors.orange],
  'crime': [Color(0xff736665), Color(0xffA48B85)],
  'documentary': [Color(0xff4D4D5F), Color(0xff848BA0)],
  'drama': [Color(0xff9B4137), Color(0xffB66845)],
  'family': [Color(0xff6E98D7), Color(0xffA6BBD4)],
  'fantasy': [Color(0xffA7529D), Color(0xff85279F)],
  'history': [Color(0xff3A2414), Color(0xff5C4C3B)],
  'horror': [Color(0xffAE3126), Color(0xff882218)],
  'music': [Color(0xff474DFA), Color(0xff4100F9)],
  'mystery': [Color(0xffDDB85A), Color(0xff755E26)],
  'romance': [Color(0xff976599), Color(0xff7B4475)],
  'science fiction': [Color(0xff437B9B), Color(0xff2E419A)],
  'tv movie': [Color(0xff9D9FB0), Color(0xff5861A5)],
  'thriller': [Color(0xff962118), Color(0xff7B1B14)],
  'war': [Color(0xff462209), Color(0xffA86533)],
  'western': [Color(0xff996A44), Color(0xff7E4632)],
};

List<Color> grabColorForGenre(String genre) {
  final lower = genre.toLowerCase();
  if (genreColorPair[lower]!.isEmpty) {
    return [Colors.pinkAccent, Colors.redAccent];
  }
  return genreColorPair[lower]!;
}

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
