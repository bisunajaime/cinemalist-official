import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdbflutter/bloc/search/search_cubit.dart';
import 'package:tmdbflutter/bloc/search/search_history_cubit.dart';
import 'package:tmdbflutter/models/search_history_model.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/utils/delayed_runner.dart';
import 'package:tmdbflutter/widgets/search/actor_search_results_widget.dart';
import 'package:tmdbflutter/widgets/search/movie_search_results_widget.dart';
import 'package:tmdbflutter/widgets/search/tv_search_results_widget.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SearchCubit>();

    if (cubit.hasResults == false && cubit.didSearch == false) {
      // initial page
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              color: Colors.white.withOpacity(.5),
              size: 100,
            ),
            Text(
              'Enter a query above to look for \n'
              'a movie, tv show, or actor',
              textAlign: TextAlign.center,
              style: Styles.mReg.copyWith(
                fontSize: 18,
                color: Colors.white.withOpacity(.5),
              ),
            ),
          ],
        ),
      );
    }

    if (cubit.hasResults == false && cubit.didSearch) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              color: Colors.white.withOpacity(.5),
              size: 100,
            ),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                    text: 'No records found for\n',
                    style: Styles.mReg.copyWith(
                      fontSize: 18,
                      color: Colors.white.withOpacity(.5),
                    ),
                  ),
                  TextSpan(
                    text: '"${cubit.query}"',
                    style: Styles.mBold.copyWith(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ]))
          ],
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actors - (${cubit.actorResults?.length ?? 0})',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            ActorSearchResultsWidget(),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Movies - (${cubit.movieResults?.length ?? 0})',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            MovieSearchResultsWidget(),
          ],
        ),
        SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TV Shows - (${cubit.tvResults?.length ?? 0})',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TvSearchResultsWidget(),
          ],
        ),
      ],
    );
  }
}

class SearchField extends StatefulWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final _runner = DelayedRunner(milliseconds: 700);
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();
    final searchHistCubit = context.read<SearchHistoryCubit>();
    return Container(
      color: Color(0xff0E0E0E),
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 10,
      ),
      child: TextField(
        controller: controller,
        onChanged: (value) async {
          _runner.run(() async {
            await cubit.search(controller.text);
            await searchHistCubit.save(SearchHistoryModel(
              controller.text,
              DateTime.now(),
            ));
          });
        },
        style: Styles.mReg.copyWith(
          color: Colors.white,
          fontSize: 18,
        ),
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap: () {
              controller.clear();
              _runner.run(() async {
                await cubit.search('');
              });
            },
            child: Icon(
              Icons.clear,
              color: Colors.white,
            ),
          ),
          contentPadding: EdgeInsets.all(12),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          filled: true,
          fillColor: Color(0xff2e2e2e),
          hintText: 'Search here',
          hintStyle: Styles.mReg.copyWith(
            color: Colors.white,
            fontSize: 18,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.pinkAccent,
              width: 2,
            ),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
