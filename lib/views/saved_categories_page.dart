import 'package:cinemalist/bloc/saved/saved_category_cubit.dart';
import 'package:cinemalist/widgets/sliver/cinemalist_sliver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../styles/styles.dart';

class SavedCategoriesPage extends StatelessWidget {
  const SavedCategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CinemalistSliverAppBar(
      body: SavedCategoriesBody(),
      topText: 'CATEGORIES',
      bottomText: 'Your saved categories',
    );
  }
}

class SavedCategoriesBody extends StatelessWidget {
  const SavedCategoriesBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final savedCategoriesCubit = context.watch<SavedCategoryCubit>();
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: savedCategoriesCubit.state.length,
      itemBuilder: (context, index) {
        final category = savedCategoriesCubit.state[index];
        return Container(
          decoration: BoxDecoration(
            color: Color(category.emojiOption!.primaryColorValue),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.emojiOption!.emoji,
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 50),
              Text(
                category.label!,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
