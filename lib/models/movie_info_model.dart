import 'package:equatable/equatable.dart';
import 'package:tmdbflutter/barrels/models.dart';
import 'package:meta/meta.dart';

class MovieInfoModel extends Equatable {
  final String homepage, imdbId, status;
  final int budget, revenue;
  final List<GenresModel> genres;

  MovieInfoModel({
    @required this.homepage,
    @required this.imdbId,
    @required this.status,
    @required this.budget,
    @required this.revenue,
    @required this.genres,
  });

  factory MovieInfoModel.fromJson(Map<String, dynamic> json) {
    List genresFromJson = json['genres'];
    List genres = genresFromJson.map((e) => GenresModel.fromJson(e)).toList();
    return MovieInfoModel(
      homepage: json['homepage'],
      imdbId: json['imdb_id'],
      status: json['status'],
      budget: json['budget'],
      revenue: json['revenue'],
      genres: genres,
    );
  }

  @override
  List<Object> get props => [
        homepage,
        imdbId,
        status,
        budget,
        revenue,
        genres,
      ];
}

/*

{
  "adult": false,
  "backdrop_path": "/t4z8OlOEzH7J1JRFUN3rcm6XHNL.jpg",
  "belongs_to_collection": null,
  "budget": 87500000,
  "genres": [
    {
      "id": 878,
      "name": "Science Fiction"
    },
    {
      "id": 18,
      "name": "Drama"
    }
  ],
  "homepage": "https://www.foxmovies.com/movies/ad-astra",
  "id": 419704,
  "imdb_id": "tt2935510",
  "original_language": "en",
  "original_title": "Ad Astra",
  "overview": "The near future, a time when both hope and hardships drive humanity to look to the stars and beyond. While a mysterious phenomenon menaces to destroy life on planet Earth, astronaut Roy McBride undertakes a mission across the immensity of space and its many perils to uncover the truth about a lost expedition that decades before boldly faced emptiness and silence in search of the unknown.",
  "popularity": 153.446,
  "poster_path": "/xBHvZcjRiWyobQ9kxBhO6B2dtRI.jpg",
  "production_companies": [
    {
      "id": 490,
      "logo_path": null,
      "name": "New Regency Productions",
      "origin_country": "US"
    },
    {
      "id": 79963,
      "logo_path": null,
      "name": "Keep Your Head",
      "origin_country": ""
    },
    {
      "id": 73492,
      "logo_path": null,
      "name": "MadRiver Pictures",
      "origin_country": ""
    },
    {
      "id": 81,
      "logo_path": "/8wOfUhA7vwU2gbPjQy7Vv3EiF0o.png",
      "name": "Plan B Entertainment",
      "origin_country": "US"
    },
    {
      "id": 30666,
      "logo_path": "/g8LmDZVFWDRJW72sj0nAj1gh8ac.png",
      "name": "RT Features",
      "origin_country": "BR"
    },
    {
      "id": 30148,
      "logo_path": "/zerhOenUD6CkH8SMgZUhrDkOs4w.png",
      "name": "Bona Film Group",
      "origin_country": "CN"
    },
    {
      "id": 22213,
      "logo_path": "/qx9K6bFWJupwde0xQDwOvXkOaL8.png",
      "name": "TSG Entertainment",
      "origin_country": "US"
    }
  ],
  "production_countries": [
    {
      "iso_3166_1": "BR",
      "name": "Brazil"
    },
    {
      "iso_3166_1": "CN",
      "name": "China"
    },
    {
      "iso_3166_1": "US",
      "name": "United States of America"
    }
  ],
  "release_date": "2019-09-17",
  "revenue": 132807427,
  "runtime": 123,
  "spoken_languages": [
    {
      "iso_639_1": "en",
      "name": "English"
    },
    {
      "iso_639_1": "no",
      "name": "Norsk"
    }
  ],
  "status": "Released",
  "tagline": "The answers we seek are just outside our reach",
  "title": "Ad Astra",
  "video": false,
  "vote_average": 6.1,
  "vote_count": 3838
}

 */
