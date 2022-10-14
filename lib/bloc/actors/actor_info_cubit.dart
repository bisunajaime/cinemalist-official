import 'package:cinemalist/library/cubit.dart';
import 'package:cinemalist/models/actor_info_model.dart';

import '../../repository/tmdb_repository/tmdb_repository.dart';

class ActorInfoCubit extends TMDBCubit<ActorInfoModel?> {
  final int? id;
  ActorInfoCubit(TMDBRepository tmdbRepository, this.id)
      : super(tmdbRepository);

  @override
  Future<ActorInfoModel?> loadFromServer() async {
    return await tmdbRepository.fetchActorInfo(id: id);
  }

  @override
  String get name => 'ActorInfoCubit';
}
