import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdbflutter/bloc/search/search_bloc.dart';
import 'package:tmdbflutter/styles/styles.dart';
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
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        ActorSearchResultsWidget(),
        SizedBox(height: 10),
        MovieSearchResultsWidget(),
        SizedBox(height: 10),
        TvSearchResultsWidget(),
      ],
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();
    cubit.search('a');
    return Container(
      color: Color(0xff0E0E0E),
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 10,
      ),
      child: TextField(
        onChanged: (value) async {
          await cubit.search(value);
        },
        style: Styles.mReg.copyWith(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          filled: true,
          fillColor: Color(0xff2e2e2e),
          hintText: 'Search here',
          hintStyle: Styles.mReg.copyWith(
            color: Colors.white,
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
