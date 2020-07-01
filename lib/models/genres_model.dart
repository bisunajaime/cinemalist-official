import 'package:equatable/equatable.dart';

class GenresModel extends Equatable {
  final int id;
  final String name;
  GenresModel({this.id, this.name});

  factory GenresModel.fromJson(Map<String, dynamic> json) {
    return GenresModel(id: json['id'], name: json['name']);
  }

  @override
  List<Object> get props => [id, name];
  @override
  String toString() => 'Genre { id: $id }';
}
