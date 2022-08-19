abstract class UriLoader {
  Uri generateUri(String path, [Map<String, dynamic>? queryParams]);
}

class TMDBUriLoader implements UriLoader {
  final String baseUrl;
  final String version;
  final String apiKey;

  TMDBUriLoader(this.baseUrl, this.version, this.apiKey);

  @override
  Uri generateUri(String path, [Map<String, dynamic>? queryParams]) {
    final pathWithVersion = '$version$path';
    if (queryParams != null) {
      queryParams['api_key'] = apiKey;
      queryParams['language'] = 'en-US';
    }
    return Uri.https(baseUrl, pathWithVersion, queryParams);
  }
}
