import 'package:logger/logger.dart';

import 'log.dart';

class LoggerLog implements Log {
  final String name;

  final _logger = Logger(
    filter: null,
    printer: SimplePrinter(colors: false),
    output: null,
  );

  LoggerLog(this.name);

  @override
  void error(String? message) => _logger.e('ERROR - [$name] - $message');

  @override
  void looping(String? message) => _logger.d('LOOPING - [$name] - $message');

  @override
  void success(String? message) => _logger.i('SUCCESS - [$name] - $message');

  @override
  void waiting(String? message) => _logger.d('WAITING - [$name] - $message');

  @override
  void wtf(String? message) => _logger.wtf('WTF - [$name] - $message');

  @override
  void close() => _logger.close();

  @override
  void info(String? message) => _logger.i('INFO - [$name] - $message');
}
