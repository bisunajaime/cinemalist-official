import 'package:bloc/bloc.dart' as c;

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
    emit(await loadFromServer());
    setIsLoading(false);
  }
}
