import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class CastModel extends Equatable {
  final int? castId, gender, id, order;
  final String? character, creditId, name, profilePath;

  CastModel({
    required this.castId,
    required this.gender,
    required this.id,
    required this.order,
    required this.character,
    required this.creditId,
    required this.name,
    required this.profilePath,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      castId: json['cast_id'] ?? 35,
      gender: json['gender'],
      id: json['id'],
      order: json['order'],
      character: json['character'],
      creditId: json['credit_id'] ?? "0",
      name: json['name'],
      profilePath: json['profile_path'],
    );
  }

  @override
  List<Object> get props =>
      [castId!, gender!, id!, order!, character!, creditId!, name!, profilePath!];
}

/*
  {
      "cast_id": 17,
      "character": "Penny Fleck",
      "credit_id": "5b5636fcc3a3685c8e026bac",
      "gender": 1,
      "id": 4432,
      "name": "Frances Conroy",
      "order": 3,
      "profile_path": "/aJRQAkO24L6bH8qkkE5Iv1nA3gf.jpg"
    },

 */
