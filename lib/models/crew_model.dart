import 'package:equatable/equatable.dart';
import 'package:tmdbflutter/models/moviecast_model.dart';

class TvShowCastModel extends Equatable {
  List<CastModel> tvShowCast;

  @override
  List<Object> get props => [];
}

/*
cast
{
      "character": "Chandler Bing",
      "credit_id": "525710be19c295731c03256f",
      "id": 14408,
      "name": "Matthew Perry",
      "gender": 2,
      "profile_path": "/ggpN8b9GJNGqzJnWWRtYuexg3Fw.jpg",
      "order": 0
    },
crew 
{
      "credit_id": "525710c119c295731c0328e3",
      "department": "Production",
      "id": 1226543,
      "name": "Wendy Knoller",
      "gender": 0,
      "job": "Producer",
      "profile_path": null
    },
 */
