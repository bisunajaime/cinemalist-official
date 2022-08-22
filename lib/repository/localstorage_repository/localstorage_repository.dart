abstract class LocalStorageRepository {
  Future<bool> save(String fileName, String json);
  Future<bool> remove(String fileName);
  Future<String> retrieve(String fileName);
}

class FileLocalStorageRepository implements LocalStorageRepository {
  @override
  Future<bool> remove(String fileName) async {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  Future<String> retrieve(String fileName) async {
    // TODO: implement retrieve
    throw UnimplementedError();
  }

  @override
  Future<bool> save(String fileName, String json) async {
    // TODO: implement save
    throw UnimplementedError();
  }
}
