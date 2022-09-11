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
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: searchHistCubit.state.length,
              itemBuilder: (context, index) {
                final model = searchHistCubit.state[index];
                return SearchHistoryItemWidget(model: model, index: index);
              },
            ),
          ),
          SizedBox(width: 10),
          TextButton(
            onPressed: () {
              context.read<SearchCubit>().clearResults();
              searchHistCubit.clear();
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: Color(0xffEC4A6C),
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(4),
              // ),
            ),
            child: Text(
              'Clear\nResults',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
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
    final selected =
        searchCubit.query.toLowerCase() == model.text.toLowerCase();
    return GestureDetector(
      onTap: () {
        _runner.run(() {
          if (selected) {
            searchCubit.clearResults();
            return;
          }
          searchCubit.search(model.text);
          searchCubit.updateSearchController(model.text);
        });
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
