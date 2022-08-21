import 'dart:async';

class DelayedRunner {
  final int milliseconds;
  late Function action;
  Timer? _timer;

  DelayedRunner({required this.milliseconds});

  void run(Function action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), () => action());
  }
}
