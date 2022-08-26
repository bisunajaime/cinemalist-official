import 'package:equatable/equatable.dart';

class CrewModel extends Equatable {
  final String? creditId, department, name, job, profilePath;
  final int? id, gender;

  CrewModel({
    required this.creditId,
    required this.department,
    required this.name,
    required this.job,
    required this.profilePath,
    required this.id,
    required this.gender,
  });

  factory CrewModel.fromJson(Map<String, dynamic> json) {
    return CrewModel(
      creditId: json['credit_id'],
      department: json['department'],
      name: json['name'],
      job: json['job'],
      profilePath: json['profile_path'],
      id: json['id'],
      gender: json['gender'],
    );
  }

  @override
  List<Object> get props => [
        creditId!,
        department!,
        name!,
        job!,
        profilePath!,
        id!,
        gender!,
      ];
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
