import 'dart:async';

class DelayedRunner {
  final int milliseconds;
  Timer? _timer;

  DelayedRunner({required this.milliseconds});

  void run(Function action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), () => action());
  }
}
