import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdbflutter/bloc/watch_later/watch_later_cubit.dart';
import 'package:tmdbflutter/library/cubit.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/widgets/saved/saved_actors_page.dart';
import 'package:tmdbflutter/widgets/saved/saved_movies_widget.dart';
import 'package:tmdbflutter/widgets/saved/saved_tv_shows_widget.dart';
import 'package:tmdbflutter/widgets/saved/title.dart';

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
        SizedBox(height: 4),
        SavedRecordsTitle(
          title: 'Movies',
          localCubit: context.watch<MoviesWatchLaterCubit>(),
        ),
        SizedBox(height: 4),
        SavedMoviesWidget(),
        SizedBox(height: 4),
        SavedRecordsTitle(
          title: 'Actors',
          localCubit: context.watch<SavedActorsCubit>(),
        ),
        SizedBox(height: 4),
        SavedActorsWidget(),
        SizedBox(height: 4),
        SavedRecordsTitle(
          title: 'TV Shows',
          localCubit: context.watch<TvWatchLaterCubit>(),
        ),
        SizedBox(height: 4),
        SavedTvShowsWidget(),
      ],
    );
  }
}
