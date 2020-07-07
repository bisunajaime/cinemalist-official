import 'package:tmdbflutter/models/movieinfo/BelongsToCollection.dart';
import 'package:tmdbflutter/models/movieinfo/Genre.dart';
import 'package:tmdbflutter/models/movieinfo/ProductionCompany.dart';
import 'package:tmdbflutter/models/movieinfo/ProductionCountry.dart';
import 'package:tmdbflutter/models/movieinfo/SpokenLanguage.dart';
import 'package:tmdbflutter/models/movieinfo/Videos.dart';

class MovieInfo {
  bool adult;
  String backdrop_path;
  BelongsToCollection belongs_to_collection;
  int budget;
  List<Genre> genres;
  String homepage;
  int id;
  String imdb_id;
  String original_language;
  String original_title;
  String overview;
  double popularity;
  String poster_path;
  List<ProductionCompany> production_companies;
  List<ProductionCountry> production_countries;
  String release_date;
  int revenue;
  int runtime;
  List<SpokenLanguage> spoken_languages;
  String status;
  String tagline;
  String title;
  bool video;
  Videos videos;
  double vote_average;
  int vote_count;

  MovieInfo(
      {this.adult,
      this.backdrop_path,
      this.belongs_to_collection,
      this.budget,
      this.genres,
      this.homepage,
      this.id,
      this.imdb_id,
      this.original_language,
      this.original_title,
      this.overview,
      this.popularity,
      this.poster_path,
      this.production_companies,
      this.production_countries,
      this.release_date,
      this.revenue,
      this.runtime,
      this.spoken_languages,
      this.status,
      this.tagline,
      this.title,
      this.video,
      this.videos,
      this.vote_average,
      this.vote_count});

  factory MovieInfo.fromJson(Map<String, dynamic> json) {
    return MovieInfo(
      adult: json['adult'],
      backdrop_path: json['backdrop_path'],
      belongs_to_collection: json['belongs_to_collection'] != null
          ? BelongsToCollection.fromJson(json['belongs_to_collection'])
          : null,
      budget: json['budget'],
      genres: json['genres'] != null
          ? (json['genres'] as List).map((i) => Genre.fromJson(i)).toList()
          : null,
      homepage: json['homepage'],
      id: json['id'],
      imdb_id: json['imdb_id'],
      original_language: json['original_language'],
      original_title: json['original_title'],
      overview: json['overview'],
      popularity: json['popularity'],
      poster_path: json['poster_path'],
      production_companies: json['production_companies'] != null
          ? (json['production_companies'] as List)
              .map((i) => ProductionCompany.fromJson(i))
              .toList()
          : null,
      production_countries: json['production_countries'] != null
          ? (json['production_countries'] as List)
              .map((i) => ProductionCountry.fromJson(i))
              .toList()
          : null,
      release_date: json['release_date'],
      revenue: json['revenue'],
      runtime: json['runtime'],
      spoken_languages: json['spoken_languages'] != null
          ? (json['spoken_languages'] as List)
              .map((i) => SpokenLanguage.fromJson(i))
              .toList()
          : null,
      status: json['status'],
      tagline: json['tagline'],
      title: json['title'],
      video: json['video'],
      videos: json['videos'] != null ? Videos.fromJson(json['videos']) : null,
      vote_average: json['vote_average'],
      vote_count: json['vote_count'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adult'] = this.adult;
    data['backdrop_path'] = this.backdrop_path;
    data['budget'] = this.budget;
    data['homepage'] = this.homepage;
    data['id'] = this.id;
    data['imdb_id'] = this.imdb_id;
    data['original_language'] = this.original_language;
    data['original_title'] = this.original_title;
    data['overview'] = this.overview;
    data['popularity'] = this.popularity;
    data['poster_path'] = this.poster_path;
    data['release_date'] = this.release_date;
    data['revenue'] = this.revenue;
    data['runtime'] = this.runtime;
    data['status'] = this.status;
    data['tagline'] = this.tagline;
    data['title'] = this.title;
    data['video'] = this.video;
    data['vote_average'] = this.vote_average;
    data['vote_count'] = this.vote_count;
    if (this.belongs_to_collection != null) {
      data['belongs_to_collection'] = this.belongs_to_collection.toJson();
    }
    if (this.genres != null) {
      data['genres'] = this.genres.map((v) => v.toJson()).toList();
    }
    if (this.production_companies != null) {
      data['production_companies'] =
          this.production_companies.map((v) => v.toJson()).toList();
    }
    if (this.production_countries != null) {
      data['production_countries'] =
          this.production_countries.map((v) => v.toJson()).toList();
    }
    if (this.spoken_languages != null) {
      data['spoken_languages'] =
          this.spoken_languages.map((v) => v.toJson()).toList();
    }
    if (this.videos != null) {
      data['videos'] = this.videos.toJson();
    }
    return data;
  }
}
