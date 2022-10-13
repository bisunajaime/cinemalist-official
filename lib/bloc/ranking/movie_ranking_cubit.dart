import 'package:tmdbflutter/bloc/ranking/ranking_cubit.dart';
import 'package:tmdbflutter/models/ranking_model.dart';

class MovieRankingCubit extends RankingCubit {
  @override
  String get fileName => 'movie_rankings.json';
}
