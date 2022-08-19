import 'package:bloc/bloc.dart' as c;
import 'package:tmdbflutter/repository/tmdb_repository.dart';

abstract class Cubit<T> extends c.Cubit<T?> {
  Cubit(initialState) : super(null);

  bool isLoading = true;

  void setIsLoading(bool loading) {
    isLoading = loading;
  }

  bool get loading => state == null && isLoading;
  bool get loadingAndNotNull => state != null && isLoading;
  bool get error => state == null && isLoading == false;

  Future<T?> loadFromServer();

  Future<void> loadData() async {
    setIsLoading(true);
    final result = await loadFromServer();
    // TODO: save locally and if there is no internet, use the local file
    emit(result);
    setIsLoading(false);
  }
}

abstract class TMDBCubit<T> extends Cubit<T?> {
  final TMDBRepository tmdbRepository;
  TMDBCubit(this.tmdbRepository) : super(null);
}
