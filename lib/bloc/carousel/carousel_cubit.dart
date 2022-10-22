import 'package:bloc/bloc.dart';

class CarouselCubit extends Cubit<int> {
  CarouselCubit() : super(0);
  int get maxPages => 2;

  void nextPage() {
    if (state == maxPages) {
      setPage(0);
    } else {
      setPage(state + 1);
    }
  }

  void setPage(int page) {
    emit(page);
  }
}
