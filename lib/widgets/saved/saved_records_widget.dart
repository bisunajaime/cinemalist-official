import 'package:cinemalist/views/saved_categories_page.dart';
import 'package:cinemalist/widgets/saved/category/saved_categories_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/bloc/watch_later/watch_later_cubit.dart';
import 'package:cinemalist/library/cubit.dart';
import 'package:cinemalist/styles/styles.dart';
import 'package:cinemalist/widgets/saved/saved_actors_page.dart';
import 'package:cinemalist/widgets/saved/saved_movies_widget.dart';
import 'package:cinemalist/widgets/saved/saved_tv_shows_widget.dart';
import 'package:cinemalist/widgets/saved/title.dart';

class SavedRecordsWidget extends StatelessWidget {
  const SavedRecordsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var hasRecords = false;
    final moviesBloc = context.watch<MoviesWatchLaterCubit>();
    final actorsBloc = context.watch<SavedActorsCubit>();
    final tvBloc = context.watch<TvWatchLaterCubit>();
    final blocs = <LocalStorageCubit>[
      moviesBloc,
      actorsBloc,
      tvBloc,
    ];
    for (var bloc in blocs) {
      if (bloc.state.length > 0) {
        hasRecords = true;
        break;
      }
    }

    if (hasRecords == false) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark,
              color: Colors.white.withOpacity(.5),
              size: 100,
            ),
            Text(
              'Browse through the records and tap\nthe icon to save it for later.',
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

    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: 5,
      ),
      children: [
        // SizedBox(height: 8),
        // Row(
        //   children: [
        //     Text(
        //       'Saved Categories',
        //       style: Styles.mBold.copyWith(
        //         fontSize: 18,
        //       ),
        //     ),
        //     Expanded(child: SizedBox()),
        //     GestureDetector(
        //       onTap: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => SavedCategoriesPage(),
        //           ),
        //         );
        //       },
        //       child: Text(
        //         'See all',
        //         style: TextStyle(
        //           fontWeight: FontWeight.bold,
        //           color: Colors.pinkAccent,
        //           fontSize: 16,
        //         ),
        //       ),
        //     )
        //   ],
        // ),
        // SizedBox(height: 12),
        // SavedCategoriesListWidget(),
        SizedBox(height: 4),
        SavedRecordsTitle(
          title: 'Movies',
          localCubit: context.watch<MoviesWatchLaterCubit>(),
          type: SavedRecordType.movie,
        ),
        SizedBox(height: 4),
        SavedMoviesWidget(),
        SizedBox(height: 4),
        SavedRecordsTitle(
          title: 'Actors',
          localCubit: context.watch<SavedActorsCubit>(),
          type: SavedRecordType.actor,
        ),
        SizedBox(height: 4),
        SavedActorsWidget(),
        SizedBox(height: 4),
        SavedRecordsTitle(
          title: 'TV Shows',
          localCubit: context.watch<TvWatchLaterCubit>(),
          type: SavedRecordType.tvShow,
        ),
        SizedBox(height: 4),
        SavedTvShowsWidget(),
      ],
    );
  }
}
