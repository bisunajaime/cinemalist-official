import 'package:tmdbflutter/library/cubit.dart';
import 'package:tmdbflutter/models/actor_info_model.dart';

import '../../repository/tmdb_repository.dart';

class ActorInfoCubit extends Cubit<ActorInfoModel?> {
  final TMDBRepository tmdbRepository;
  ActorInfoCubit(this.tmdbRepository) : super(null);

  Future<void> loadActorInfo() async {
    setIsLoading(true);
    final actorInfo = await tmdbRepository.fetchActorInfo();
    setIsLoading(false);
    emit(actorInfo);
  }

  @override
  Future<ActorInfoModel?> loadFromServer() async {
    return await tmdbRepository.fetchActorInfo();
  }
}
