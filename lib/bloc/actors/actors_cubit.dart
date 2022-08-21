import 'package:tmdbflutter/library/cubit.dart';
import '../../barrels/models.dart';
import '../../repository/tmdb_repository.dart';

class ActorsCubit extends TMDBCubit<List<ActorsModel>?> {
  ActorsCubit(TMDBRepository tmdbRepository) : super(tmdbRepository);

  @override
  Future<List<ActorsModel>?> loadFromServer() async {
    return await tmdbRepository.fetchActors();
  }

  @override
  String get name => 'ActorsCubit';
}
