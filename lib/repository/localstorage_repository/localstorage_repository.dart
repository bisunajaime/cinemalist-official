import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:cinemalist/repository/log.dart';
import 'package:cinemalist/repository/logger_log.dart';

abstract class LocalStorageRepository {
  Future<bool> save(String json);
  Future<bool> remove();
  Future<String?> retrieve();
  Future<File> getFile();
}

class FileLocalStorageRepository implements LocalStorageRepository {
  late final Log logger;
  final String fileName;

  FileLocalStorageRepository(this.fileName) {
    logger = LoggerLog('FileLocalStorageRepository - $fileName');
  }

  @override
  Future<bool> remove() async {
    logger.waiting('removing $fileName');
    try {
      final fileToDelete = await getFile();
      if (await fileToDelete.exists() == true) {
        await fileToDelete.delete();
        logger.success('successfully removed $fileName');
        return true;
      }
      return false;
    } catch (e) {
      logger.error('failed to remove $fileName');
      return false;
    }
  }

  @override
  Future<String?> retrieve() async {
    logger.waiting('retrieving file');
    try {
      final file = await getFile();
      if (await file.exists()) {
        logger.success('successfully retrieved file');
        final result = await file.readAsString();
        return result;
      }
      return null;
    } catch (e) {
      logger.error('failed to retrieve file');
      return null;
    }
  }

  @override
  Future<bool> save(String json) async {
    logger.waiting('saving file');
    try {
      if (json == 'null') {
        throw Exception('$json is null');
      }
      final file = await getFile();
      if (!await file.exists()) {
        logger.waiting('file does not exists, so creating one');
        await file.create();
        logger.success('file created');
      }
      await file.writeAsString(json);
      logger.success('file saved');
      return true;
    } catch (e) {
      logger.error('failed to save data');
      return false;
    }
  }

  @override
  Future<File> getFile() async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    return file;
  }
}
