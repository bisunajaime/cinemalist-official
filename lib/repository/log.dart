abstract class Log {
  void error(String? message);
  void success(String? message);
  void waiting(String? message);
  void looping(String? message);
  void wtf(String? message);
  void close();
  void info(String? message);
}
