import 'dart:convert';

import 'package:cinemalist/library/cubit.dart';

import '../../barrels/models.dart';
import '../../repository/tmdb_repository/tmdb_repository.dart';

class ActorsCubit extends TMDBCubit<List<ActorsModel>?> {
  ActorsCubit(TMDBRepository tmdbRepository) : super(tmdbRepository);

  @override
  Future<List<ActorsModel>?> loadFromServer() async {
    return await tmdbRepository.fetchActors();
  }

  @override
  String get name => 'ActorsCubit';

  @override
  String? get fileName => 'actors.json';

  @override
  String? get toJson => jsonEncode(state?.map((e) => e.toJson()).toList());
}
