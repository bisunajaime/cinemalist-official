import 'package:cinemalist/utils/cinemalist_constants.dart';

class PosterPathHelper {
  static String generatePosterPath(String? posterPath) {
    if (posterPath == null) {
      return CinemalistConstants.placeholderImage;
    }
    return '${CinemalistConstants.tmdbImagePath}$posterPath';
  }
}
