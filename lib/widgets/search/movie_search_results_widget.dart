import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MovieSearchResultsWidget extends StatelessWidget {
  const MovieSearchResultsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Movies',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 150,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 9,
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  color: Colors.grey,
                  height: double.infinity,
                  child: AspectRatio(
                    aspectRatio: 2 / 3,
                    child: Shimmer.fromColors(
                      child: Container(),
                      baseColor: Colors.red,
                      highlightColor: Colors.blue,
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
