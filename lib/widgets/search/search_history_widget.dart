import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdbflutter/bloc/search/search_cubit.dart';
import 'package:tmdbflutter/bloc/search/search_history_cubit.dart';
import 'package:tmdbflutter/models/search_history_model.dart';
import 'package:tmdbflutter/utils/delayed_runner.dart';

class SearchHistoryWidget extends StatelessWidget {
  const SearchHistoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchHistCubit = context.watch<SearchHistoryCubit>();
    if (searchHistCubit.state.isEmpty) return Container();
    return Container(
      height: 50,
      padding: EdgeInsets.only(bottom: 10),
      width: double.infinity,
      color: Color(0xff0E0E0E),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final model = searchHistCubit.state[index];
          return SearchHistoryItemWidget(model: model, index: index);
        },
        itemCount: searchHistCubit.state.length,
      ),
    );
  }
}

class SearchHistoryItemWidget extends StatelessWidget {
  final SearchHistoryModel model;
  final int index;
  const SearchHistoryItemWidget(
      {Key? key, required this.model, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchCubit = context.watch<SearchCubit>();
    final _runner = DelayedRunner(milliseconds: 700);
    final selected = searchCubit.query.toLowerCase() == model.text;
    return GestureDetector(
      onTap: () {
        searchCubit.search(model.text);
      },
      child: Container(
        margin: EdgeInsets.only(left: 10),
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: selected ? Color(0xffEC4A6C) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Color(0xffEC4A6C),
          ),
        ),
        constraints: BoxConstraints(
          // maxWidth: 110,
          minWidth: 80,
        ),
        alignment: Alignment.center,
        child: IntrinsicWidth(
          child: Text(
            model.text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            softWrap: false,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
