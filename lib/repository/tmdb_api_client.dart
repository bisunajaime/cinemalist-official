import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:tmdbflutter/barrels/models.dart';

import '../barrels/models.dart';
import '../barrels/models.dart';

class TMDBApiClient {
  final String apiKey = "efd2f9bdbe60bbb9414be9a5a20296b0";
  final baseUrl = "https://api.themoviedb.org/3";
  final http.Client httpClient;

  TMDBApiClient({@required this.httpClient}) : assert(httpClient != null);

  Future<List<GenresModel>> fetchCategories() async {
    List<GenresModel> genres = [];
    final url = '$baseUrl/genre/movie/list?api_key=$apiKey&language=en-US';
    final response = await httpClient.get(url);
    if (response.statusCode != 200) {
      throw new Exception('There was a problem.');
    }
    final decodeJson = jsonDecode(response.body);
    decodeJson['genres']
        .forEach((data) => genres.add(GenresModel.fromJson(data)));
    return genres;
  }

  Future<List<PopularModel>> fetchPopular() async {
    List<PopularModel> popularMovies = [];
    final url = '$baseUrl/movie/popular?api_key=$apiKey&language=en-US&page=1';
    final response = await httpClient.get(url);
    if (response.statusCode != 200) {
      throw new Exception('There was a problem.');
    }
    final decodeJson = jsonDecode(response.body);
    decodeJson['results']
        .forEach((data) => popularMovies.add(PopularModel.fromJson(data)));
    return popularMovies;
  }

  Future<List<UpcomingModel>> fetchUpcoming() async {
    List<UpcomingModel> upcomingMovies = [];
    final url = '$baseUrl/movie/upcoming?api_key=$apiKey&language=en-US&page=1';
    final response = await httpClient.get(url);
    if (response.statusCode != 200) {
      throw new Exception('There was a problem.');
    }
    final decodeJson = jsonDecode(response.body);
    decodeJson['results']
        .forEach((data) => upcomingMovies.add(UpcomingModel.fromJson(data)));
    return upcomingMovies;
  }

  Future<List<TrendingModel>> fetchTrending() async {
    List<TrendingModel> upcomingMovies = [];
    final url = '$baseUrl/trending/movie/week?api_key=$apiKey';
    final response = await httpClient.get(url);
    if (response.statusCode != 200) {
      throw new Exception('There was a problem.');
    }
    final decodeJson = jsonDecode(response.body);
    decodeJson['results']
        .forEach((data) => upcomingMovies.add(TrendingModel.fromJson(data)));
    return upcomingMovies;
  }

  Future<List<ActorsModel>> fetchActors() async {
    List<ActorsModel> actors = [];
    final url = '$baseUrl/person/popular?api_key=$apiKey&language=en-US&page=1';
    final response = await httpClient.get(url);
    if (response.statusCode != 200) {
      throw new Exception('There was a problem.');
    }
    final decodeJson = jsonDecode(response.body);
    decodeJson['results']
        .forEach((data) => actors.add(ActorsModel.fromJson(data)));
    return actors;
  }
}
