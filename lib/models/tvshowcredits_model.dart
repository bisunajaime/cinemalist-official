import 'package:equatable/equatable.dart';
import 'package:tmdbflutter/models/actor_info_model.dart';
import 'package:tmdbflutter/models/crew_model.dart';

class TvShowCreditsModel extends Equatable {
  final List<ActorInfoModel>? casts;
  final List<CrewModel>? crew;
  TvShowCreditsModel({this.casts, this.crew});

  factory TvShowCreditsModel.fromJson(Map<String, dynamic> json) {
    List castList = json['cast'] as List;
    List crewList = json['crew'] as List;
    List<ActorInfoModel> castsToObj =
        castList.map((e) => ActorInfoModel.fromJson(e)).toList();
    List<CrewModel> crewToObj =
        crewList.map((e) => CrewModel.fromJson(e)).toList();

    return TvShowCreditsModel(
      casts: castsToObj,
      crew: crewToObj,
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [casts!, crew!];
}
