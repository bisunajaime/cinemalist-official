import 'package:cinemalist/bloc/ranking/ranking_cubit.dart';
import 'package:cinemalist/models/ranking_model.dart';

class MovieRankingCubit extends RankingCubit {
  @override
  String get fileName => 'movie_rankings.json';
}
