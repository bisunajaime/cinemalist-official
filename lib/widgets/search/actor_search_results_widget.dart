import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdbflutter/bloc/search/search_bloc.dart';

class ActorSearchResultsWidget extends StatelessWidget {
  const ActorSearchResultsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SearchCubit>();
    if (cubit.loading) {}
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actors',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          height: 100,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 9,
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
        )
      ],
    );
  }
}
