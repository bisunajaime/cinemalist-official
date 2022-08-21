import 'package:tmdbflutter/library/cubit.dart';
import 'package:tmdbflutter/models/actor_info_model.dart';
import '../../repository/tmdb_repository.dart';

class ActorInfoCubit extends Cubit<ActorInfoModel?> {
  final TMDBRepository tmdbRepository;
  final int? id;
  ActorInfoCubit(this.tmdbRepository, this.id) : super(null);

  @override
  Future<ActorInfoModel?> loadFromServer() async {
    return await tmdbRepository.fetchActorInfo(id: id);
  }

  @override
  String get name => 'ActorInfoCubit';
}
