import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/models/actor_info_model.dart';
import 'package:tmdbflutter/models/cast_model.dart';

class GenericActorModel extends SerializableClass {
  final int? id;
  final String? name, profilePath;

  GenericActorModel(this.id, this.name, this.profilePath);

  factory GenericActorModel.fromCastModel(CastModel model) {
    return GenericActorModel(model.id, model.name, model.profilePath);
  }

  factory GenericActorModel.fromActorInfoModel(ActorInfoModel model) {
    return GenericActorModel(model.id, model.name, model.profilePath);
  }

  factory GenericActorModel.fromActorModel(ActorsModel model) {
    return GenericActorModel(model.id, model.name, model.profilePath);
  }

  factory GenericActorModel.fromJson(Map<String, dynamic> json) {
    return GenericActorModel(
      json['id'],
      json['name'],
      json['profile_path'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'profile_path': profilePath,
      };
}