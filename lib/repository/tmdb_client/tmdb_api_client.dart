import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/models/actor_info_model.dart';
import 'package:tmdbflutter/models/builder/filter_builder.dart';
import 'package:tmdbflutter/models/movieinfo/MovieInfo.dart';
import 'package:tmdbflutter/models/season_model.dart';
import 'package:tmdbflutter/models/tvshow_model.dart';
import 'package:tmdbflutter/models/tvshowcredits_model.dart';
import 'package:tmdbflutter/repository/search_results_repository.dart';
import 'package:tmdbflutter/repository/tmdb_client/tmdb_client.dart';
import 'package:tmdbflutter/repository/uri_generator.dart';

import '../../barrels/models.dart';

class TMDBApiClient implements TMDBClient {
  final String apiKey = "efd2f9bdbe60bbb9414be9a5a20296b0";
  final baseUrl = "api.themoviedb.org";
  final version = '/3';
  final http.Client httpClient;
  late final UriLoader uriLoader;

  TMDBApiClient({required this.httpClient}) {
    uriLoader = TMDBUriLoader(baseUrl, version, apiKey);
  }

  @override
  Future<List<GenresModel>> fetchCategories() async {
    List<GenresModel> genres = [];
    final url = '/genre/movie/list';
    final response = await httpClient.get(uriLoader.generateUri(url));
    if (response.statusCode != 200) {
      throw new Exception('There was a problem.');
    }
    final decodeJson = jsonDecode(response.body);
    decodeJson['genres']
        .forEach((data) => genres.add(GenresModel.fromJson(data)));
    return genres;
  }

  @override
  Future<List<GenericMoviesModel>> fetchPopular() async {
    List<GenericMoviesModel> popularMovies = [];
    final path = '/discover/movie';
    final filter = FilterBuilder().sortBy().page(1);
    final uri = uriLoader.generateUri(path, filter.toJson());
    final response = await httpClient.get(uri);
    if (response.statusCode != 200) {
      throw new Exception('There was a problem.');
    }
    final decodeJson = jsonDecode(response.body);
    decodeJson['results'].forEach(
        (data) => popularMovies.add(GenericMoviesModel.fromJson(data)));
    return popularMovies;
  }

  @override
  Future<List<GenericMoviesModel>> fetchUpcoming() async {
    List<GenericMoviesModel> upcomingMovies = [];
    final url = '/movie/upcoming';
    final response = await httpClient.get(uriLoader.generateUri(url));
    if (response.statusCode != 200) {
      throw new Exception('There was a problem.');
    }
    final decodeJson = jsonDecode(response.body);
    decodeJson['results'].forEach(
        (data) => upcomingMovies.add(GenericMoviesModel.fromJson(data)));
    return upcomingMovies;
  }

  @override
  Future<List<GenericMoviesModel>> fetchTrending() async {
    List<GenericMoviesModel> trendingMovies = [];
    final url = '/trending/movie/week';
    final response = await httpClient.get(uriLoader.generateUri(url));
    if (response.statusCode != 200) {
      throw new Exception('There was a problem.');
    }
    final decodeJson = jsonDecode(response.body);
    decodeJson['results'].forEach(
        (data) => trendingMovies.add(GenericMoviesModel.fromJson(data)));
    return trendingMovies;
  }

  @override
  Future<List<ActorsModel>> fetchActors() async {
    List<ActorsModel> actors = [];
    final url = '/person/popular';
    final response = await httpClient.get(uriLoader.generateUri(url));
    if (response.statusCode != 200) {
      throw new Exception('There was a problem.');
    }
    final decodeJson = jsonDecode(response.body);
    decodeJson['results']
        .forEach((data) => actors.add(ActorsModel.fromJson(data)));
    return actors;
  }

  @override
  Future<List<GenericMoviesModel>> fetchNowPlaying({int? page}) async {
    List<GenericMoviesModel> nowPlaying = [];
    final url = '/movie/now_playing';
    final filters = FilterBuilder().page(page);
    final response = await httpClient.get(uriLoader.generateUri(
      url,
      filters.toJson(),
    ));
    if (response.statusCode != 200) {
      throw new Exception('There was a problem.');
    }
    final decodeJson = jsonDecode(response.body);
    decodeJson['results']
        .forEach((data) => nowPlaying.add(GenericMoviesModel.fromJson(data)));
    return nowPlaying;
  }

  @override
  Future<List<TVShowModel>> fetchPopularTvShows({int? page}) async {
    List<TVShowModel> tvShows = [];

    final filters = FilterBuilder().sortBy().includeAdult().page(page);
    final url = '/discover/tv';
    final response =
        await httpClient.get(uriLoader.generateUri(url, filters.toJson()));
    if (response.statusCode != 200) {
      throw new Exception('There was a problem.');
    }
    final decodeJson = jsonDecode(response.body);
    decodeJson['results']
        .forEach((data) => tvShows.add(TVShowModel.fromJson(data)));
    return tvShows;
  }

  @override
  Future<MovieInfo> fetchMovieInfo({int? id}) async {
    final filters = FilterBuilder().appendToResponse();
    final url = '/movie/$id';
    final response = await httpClient.get(uriLoader.generateUri(
      url,
      filters.toJson(),
    ));
    if (response.statusCode != 200) {
      throw new Exception('There was a problem.');
    }
    final decodeJson = jsonDecode(response.body);
    MovieInfo movieInfo = MovieInfo.fromJson(decodeJson);
    return movieInfo;
  }

  @override
  Future<List<ActorInfoModel>> fetchMovieCasts({int? id}) async {
    List<ActorInfoModel> casts = [];
    final url = '/movie/$id/credits';
    final response = await httpClient.get(uriLoader.generateUri(url));
    if (response.statusCode != 200) {
      throw new Exception('There was a problem.');
    }
    final decodeJson = jsonDecode(response.body);
    decodeJson['cast']
        .forEach((data) => casts.add(ActorInfoModel.fromJson(data)));
    return casts;
  }

  @override
  Future<TvShowCreditsModel> fetchTvShowCredits({int? id}) async {
    final url = '/tv/$id/credits';
    final response = await httpClient.get(uriLoader.generateUri(url));
    if (response.statusCode != 200) {
      throw new Exception('There was a problem.');
    }
    final decodedJson = jsonDecode(response.body);
    TvShowCreditsModel tvShowCreditsModel =
        TvShowCreditsModel.fromJson(decodedJson);
    return tvShowCreditsModel;
  }

  @override
  Future<ActorInfoModel> fetchActorInfo({int? id}) async {
    final url = '/person/$id';
    final response = await httpClient.get(uriLoader.generateUri(url));
    final decodedJson = jsonDecode(response.body);
    ActorInfoModel actorInfoModel = ActorInfoModel.fromJson(decodedJson);
    return actorInfoModel;
  }

  @override
  Future<List<GenericMoviesModel>> fetchSimilarMovies(
      {int? id, int? page}) async {
    List<GenericMoviesModel> similarMovies = [];
    final filters = FilterBuilder().page(page);
    final url = '/movie/$id/similar';
    final response = await httpClient.get(uriLoader.generateUri(
      url,
      filters.toJson(),
    ));
    final decodeJson = jsonDecode(response.body);
    decodeJson['results'].forEach(
        (data) => similarMovies.add(GenericMoviesModel.fromJson(data)));
    return similarMovies;
  }

  @override
  Future<List<TVShowModel>> fetchSimilarTvShows({int? id, int? page}) async {
    List<TVShowModel> similarTvShows = [];
    final filters = FilterBuilder().page(page);
    final url = '/tv/$id/similar';
    final response =
        await httpClient.get(uriLoader.generateUri(url, filters.toJson()));
    final decodeJson = jsonDecode(response.body);
    decodeJson['results']
        .forEach((data) => similarTvShows.add(TVShowModel.fromJson(data)));
    return similarTvShows;
  }

  @override
  Future<List<GenericMoviesModel>> fetchMoviesByGenre(
      {int? id, int? page}) async {
    List<GenericMoviesModel> moviesByGenre = [];
    final url = '/discover/movie';
    final filters = FilterBuilder()
        .sortBy()
        .includeAdult(include: false)
        .page(page)
        .withGenres(id);
    final response =
        await httpClient.get(uriLoader.generateUri(url, filters.toJson()));
    final decodeJson = jsonDecode(response.body);
    decodeJson['results'].forEach(
        (movie) => moviesByGenre.add(GenericMoviesModel.fromJson(movie)));
    return moviesByGenre;
  }

  @override
  Future<List<GenericMoviesModel>> fetchActorMovies(
      {int? id, int? page}) async {
    List<GenericMoviesModel> actorMovies = [];
    final url = '/discover/movie';
    final filters = FilterBuilder();
    final filterMap =
        filters.sortBy().includeAdult().page(page).withCast(id).toJson();
    final response =
        await httpClient.get(uriLoader.generateUri(url, filterMap));
    final decodeJson = jsonDecode(response.body);
    decodeJson['results'].forEach(
        (movie) => actorMovies.add(GenericMoviesModel.fromJson(movie)));
    return actorMovies;
  }

  @override
  Future<List<SeasonModel>> fetchTvSeasons({int? id}) async {
    List<SeasonModel> seasons = [];
    final url = '/tv/$id';
    final response = await httpClient.get(uriLoader.generateUri(url));
    final decodeJson = jsonDecode(response.body);
    decodeJson['seasons']
        .forEach((season) => seasons.add(SeasonModel.fromJson(season)));
    return seasons;
  }

  Future fetchSearchResults({String? type, String? query, int? page}) async {
    SearchResultsRepository searchResults =
        DefaultSearchResults(uriLoader, httpClient);
    switch (type) {
      case 'movie':
        searchResults = MovieSearchResults(uriLoader, httpClient);
        break;
      case 'person':
        searchResults = PersonSearchResults(uriLoader, httpClient);
        break;
      case 'tv':
        searchResults = TvSearchResults(uriLoader, httpClient);
        break;
      case 'clear':
        return [];
    }
    return await searchResults.searchMovies(query, page);
  }
}
