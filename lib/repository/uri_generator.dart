abstract class UriLoader {
  Uri generateUri(String path);
}

class HttpUriLoader implements UriLoader {
  final String baseUrl;

  HttpUriLoader(this.baseUrl);

  @override
  Uri generateUri(String path) {
    return Uri.https(baseUrl, path);
  }
}
