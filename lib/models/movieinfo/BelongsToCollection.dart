class BelongsToCollection {
  String backdrop_path;
  int id;
  String name;
  String poster_path;

  BelongsToCollection(
      {this.backdrop_path, this.id, this.name, this.poster_path});

  factory BelongsToCollection.fromJson(Map<String, dynamic> json) {
    return BelongsToCollection(
      backdrop_path: json['backdrop_path'],
      id: json['id'],
      name: json['name'],
      poster_path: json['poster_path'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['backdrop_path'] = this.backdrop_path;
    data['id'] = this.id;
    data['name'] = this.name;
    data['poster_path'] = this.poster_path;
    return data;
  }
}
