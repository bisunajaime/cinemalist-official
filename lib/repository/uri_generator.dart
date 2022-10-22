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
    if (queryParams == null) {
      queryParams = {};
    }
    // queryParams['language'] = 'en-US';
    queryParams['api_key'] = apiKey;
    return Uri.https(baseUrl, pathWithVersion, queryParams);
  }
}
