import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/widgets/ranking/ranking_filter_bar.dart';

class RankingFilterCubit extends Cubit<RankingFilter> {
  RankingFilterCubit() : super(RankingFilter.movies);

  void updateFilter(RankingFilter filter) {
    if (filter == state) return;
    emit(filter);
  }

  bool isSelected(RankingFilter filter) => filter == state;
}
