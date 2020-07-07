import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/models/actor_info_model.dart';
import 'package:tmdbflutter/models/movie_info_model.dart';
import 'package:tmdbflutter/models/cast_model.dart';
import 'package:tmdbflutter/models/movieinfo/MovieInfo.dart';
import 'package:tmdbflutter/models/season_model.dart';
import 'package:tmdbflutter/models/tvshow_model.dart';
import 'package:tmdbflutter/models/tvshowcredits_model.dart';

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

  Future<List<GenericMoviesModel>> fetchPopular() async {
    List<GenericMoviesModel> popularMovies = [];
    final url =
        '$baseUrl/discover/movie?api_key=$apiKey&language=en-US&sort_by=popularity.desc&page=1';
    final response = await httpClient.get(url);
    if (response.statusCode != 200) {
      throw new Exception('There was a problem.');
    }
    final decodeJson = jsonDecode(response.body);
    decodeJson['results'].forEach(
        (data) => popularMovies.add(GenericMoviesModel.fromJson(data)));
    return popularMovies;
  }

  Future<List<GenericMoviesModel>> fetchUpcoming() async {
    List<GenericMoviesModel> upcomingMovies = [];
    final url = '$baseUrl/movie/upcoming?api_key=$apiKey&language=en-US&page=1';
    final response = await httpClient.get(url);
    if (response.statusCode != 200) {
      throw new Exception('There was a problem.');
    }
    final decodeJson = jsonDecode(response.body);
    decodeJson['results'].forEach(
        (data) => upcomingMovies.add(GenericMoviesModel.fromJson(data)));
    return upcomingMovies;
  }

  Future<List<GenericMoviesModel>> fetchTrending() async {
    List<GenericMoviesModel> trendingMovies = [];
    final url = '$baseUrl/trending/movie/week?api_key=$apiKey';
    final response = await httpClient.get(url);
    if (response.statusCode != 200) {
      throw new Exception('There was a problem.');
    }
    final decodeJson = jsonDecode(response.body);
    decodeJson['results'].forEach(
        (data) => trendingMovies.add(GenericMoviesModel.fromJson(data)));
    return trendingMovies;
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

  Future<List<GenericMoviesModel>> fetchNowPlaying({int page}) async {
    List<GenericMoviesModel> nowPlaying = [];
    final url =
        '$baseUrl/movie/now_playing?api_key=$apiKey&language=en-US&page=$page';
    final response = await httpClient.get(url);
    if (response.statusCode != 200) {
      throw new Exception('There was a problem.');
    }
    final decodeJson = jsonDecode(response.body);
    decodeJson['results']
        .forEach((data) => nowPlaying.add(GenericMoviesModel.fromJson(data)));
    return nowPlaying;
  }

  Future<List<TVShowModel>> fetchPopularTvShows({int page}) async {
    List<TVShowModel> tvShows = [];
    // https://api.themoviedb.org/3/discover/tv?api_key=efd2f9bdbe60bbb9414be9a5a20296b0&language=en-US&sort_by=popularity.desc&page=1&timezone=America%2FNew_York&include_null_first_air_dates=false
    final url =
        '$baseUrl/discover/tv?api_key=$apiKey&language=en-US&sort_by=popularity.desc&page=$page';
    final response = await httpClient.get(url);
    if (response.statusCode != 200) {
      throw new Exception('There was a problem.');
    }
    final decodeJson = jsonDecode(response.body);
    decodeJson['results']
        .forEach((data) => tvShows.add(TVShowModel.fromJson(data)));
    return tvShows;
  }

  Future<MovieInfo> fetchMovieInfo({int id}) async {
    //https://api.themoviedb.org/3/movie/419704?api_key=efd2f9bdbe60bbb9414be9a5a20296b0&language=en-US&append_to_response=videos
    final url =
        '$baseUrl/movie/$id?api_key=$apiKey&language=en-US&append_to_response=videos';
    final response = await httpClient.get(url);
    if (response.statusCode != 200) {
      throw new Exception('There was a problem.');
    }
    final decodeJson = jsonDecode(response.body);
    MovieInfo movieInfo = MovieInfo.fromJson(decodeJson);
    return movieInfo;
  }

  Future<List<CastModel>> fetchMovieCasts({int id}) async {
    List<CastModel> casts = [];
    final url = '$baseUrl/movie/$id/credits?api_key=$apiKey';
    final response = await httpClient.get(url);
    if (response.statusCode != 200) {
      throw new Exception('There was a problem.');
    }
    final decodeJson = jsonDecode(response.body);
    decodeJson['cast'].forEach((data) => casts.add(CastModel.fromJson(data)));
    return casts;
  }

  Future<TvShowCreditsModel> fetchTvShowCredits({int id}) async {
    final url = '$baseUrl/tv/$id/credits?api_key=$apiKey';
    final response = await httpClient.get(url);
    if (response.statusCode != 200) {
      throw new Exception('There was a problem.');
    }
    final decodedJson = jsonDecode(response.body);
    TvShowCreditsModel tvShowCreditsModel =
        TvShowCreditsModel.fromJson(decodedJson);
    return tvShowCreditsModel;
  }

  Future<ActorInfoModel> fetchActorInfo({int id}) async {
    final url = '$baseUrl/person/$id?api_key=$apiKey&language=en-US';
    final response = await httpClient.get(url);
    final decodedJson = jsonDecode(response.body);
    ActorInfoModel actorInfoModel = ActorInfoModel.fromJson(decodedJson);
    return actorInfoModel;
  }

  Future<List<GenericMoviesModel>> fetchSimilarMovies({int id}) async {
    List<GenericMoviesModel> similarMovies = [];
    final url =
        '$baseUrl/movie/$id/similar?api_key=$apiKey&language=en-US&page=1';
    final response = await httpClient.get(url);
    final decodeJson = jsonDecode(response.body);
    decodeJson['results'].forEach(
        (data) => similarMovies.add(GenericMoviesModel.fromJson(data)));
    return similarMovies;
  }

  Future<List<TVShowModel>> fetchSimilarTvShows({int id}) async {
    List<TVShowModel> similarTvShows = [];
    final url = '$baseUrl/tv/$id/similar?api_key=$apiKey&language=en-US&page=1';
    final response = await httpClient.get(url);
    final decodeJson = jsonDecode(response.body);
    decodeJson['results']
        .forEach((data) => similarTvShows.add(TVShowModel.fromJson(data)));
    return similarTvShows;
  }

  Future<List<GenericMoviesModel>> fetchMoviesByGenre(
      {int id, int page}) async {
    // https://api.themoviedb.org/3/discover/movie?api_key=efd2f9bdbe60bbb9414be9a5a20296b0&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=true&page=1&with_genres=28
    List<GenericMoviesModel> moviesByGenre = [];
    final url =
        '$baseUrl/discover/movie?api_key=$apiKey&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page&with_genres=$id';
    final response = await httpClient.get(url);
    final decodeJson = jsonDecode(response.body);
    decodeJson['results'].forEach(
        (movie) => moviesByGenre.add(GenericMoviesModel.fromJson(movie)));
    return moviesByGenre;
  }

  Future<List<GenericMoviesModel>> fetchActorMovies({int id}) async {
//    https://api.themoviedb.org/3/discover/movie?api_key=efd2f9bdbe60bbb9414be9a5a20296b0&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=true&page=1&with_cast=16483
    List<GenericMoviesModel> actorMovies = [];
    final url =
        '$baseUrl/discover/movie?api_key=$apiKey&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_cast=$id';
    final response = await httpClient.get(url);
    final decodeJson = jsonDecode(response.body);
    decodeJson['results'].forEach(
        (movie) => actorMovies.add(GenericMoviesModel.fromJson(movie)));
    return actorMovies;
  }

  Future<List<SeasonModel>> fetchTvSeasons({int id}) async {
    //  https://api.themoviedb.org/3/tv/456?api_key=efd2f9bdbe60bbb9414be9a5a20296b0&language=en-US
    List<SeasonModel> seasons = [];
    final url = '$baseUrl/tv/$id?api_key=$apiKey&language=en-US';
    final response = await httpClient.get(url);
    final decodeJson = jsonDecode(response.body);
    decodeJson['seasons']
        .forEach((season) => seasons.add(SeasonModel.fromJson(season)));
    return seasons;
  }

  Future fetchSearchResults({String type, String query, int page}) async {
    switch (type) {
      case 'movie':
        final url =
            '$baseUrl/search/$type?api_key=$apiKey&query=$query&page=$page';
        final response = await httpClient.get(Uri.encodeFull(url));
        final decodeJson = jsonDecode(response.body);
        List<GenericMoviesModel> searchedMovies = [];
        if (decodeJson['results'] == null) {
          return [];
        }
        decodeJson['results'].forEach(
            (movie) => searchedMovies.add(GenericMoviesModel.fromJson(movie)));
        return searchedMovies;
        break;
      case 'person':
        final url =
            '$baseUrl/search/$type?api_key=$apiKey&query=$query&page=$page';
        final response = await httpClient.get(Uri.encodeFull(url));
        final decodeJson = jsonDecode(response.body);
        List<ActorInfoModel> actorsInfo = [];
        if (decodeJson['results'] == null) {
          return [];
        }
        decodeJson['results']
            .forEach((actor) => actorsInfo.add(ActorInfoModel.fromJson(actor)));
        return actorsInfo;
        break;
      case 'tv':
        final url =
            '$baseUrl/search/$type?api_key=$apiKey&query=$query&page=$page';
        final response = await httpClient.get(Uri.encodeFull(url));
        final decodeJson = jsonDecode(response.body);
        List<TVShowModel> searchedTvShows = [];
        if (decodeJson['results'] == null) {
          return [];
        }
        decodeJson['results'].forEach(
            (tvShow) => searchedTvShows.add(TVShowModel.fromJson(tvShow)));
        return searchedTvShows;
        break;
      case 'clear':
        print('clear');
        return [];
        break;
      default:
        break;
    }
  }
}
