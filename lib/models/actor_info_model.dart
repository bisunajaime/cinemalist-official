import 'package:intl/intl.dart';
import 'package:tmdbflutter/barrels/models.dart';

class ActorInfoModel extends SerializableClass {
  final String? birthday,
      knownForDepartment,
      name,
      biography,
      placeOfBirth,
      imdbId,
      homePage,
      profilePath,
      deathday,
      character,
      creditId;
  late final List<GenericMoviesModel> knownFor;
  final int id;
  final int? gender;
  final double popularity;

  bool get hasBirthday => birthday != null;
  bool get hasProfilePic => profilePath != null;

  String get dateOfBirth => hasBirthday
      ? DateFormat.yMMMd().format(DateTime.tryParse(birthday!)!)
      : 'Not Specified';
  String get age => hasBirthday ? computeAge(birthday!) : 'Not Specified';
  String get status => deathday == null ? 'Alive' : deathday!;

  bool get isPopular => popularity > 5;

  ActorInfoModel({
    required this.birthday,
    required this.knownForDepartment,
    required this.name,
    required this.biography,
    required this.placeOfBirth,
    required this.imdbId,
    required this.homePage,
    required this.profilePath,
    required this.deathday,
    required this.id,
    required this.popularity,
    required this.character,
    required this.creditId,
    required this.gender,
  });

  factory ActorInfoModel.fromJson(Map<String, dynamic> json) {
    return ActorInfoModel(
      birthday: json['birthday'],
      knownForDepartment: json['known_for_department'],
      name: json['name'],
      biography: json['biography'],
      placeOfBirth: json['place_of_birth'],
      imdbId: json['imdb_id'],
      homePage: json['homepage'],
      profilePath: json['profile_path'],
      deathday: json['deathday'],
//      knownFor: knownFor ?? [],
      id: json['id'] ?? 0,
      popularity: json['popularity'] ?? 0,
      character: json['character'],
      creditId: json['credit_id'],
      gender: json['gender'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'birthday': birthday,
        'known_for_department': knownForDepartment,
        'name': name,
        'biography': biography,
        'place_of_birth': placeOfBirth,
        'imdb_id': imdbId,
        'homepage': homePage,
        'profile_path': profilePath,
        'deathday': deathday,
        'id': id,
        'popularity': popularity,
        'character': character,
        'credit_id': creditId,
        'gender': gender,
      };
}

String computeAge(String dateOfBirth) {
  final now = DateTime.now();
  final dob = DateTime.parse(dateOfBirth);
  final age = now.year - dob.year;
  return age.toString();
}
