import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdbflutter/bloc/search/search_bloc.dart';
import 'package:tmdbflutter/repository/tmdb_api_client.dart';
import 'package:tmdbflutter/repository/tmdb_repository.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/views/search_results_page.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        buildTitle(),
        SizedBox(height: 10),
        Expanded(
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
              childAspectRatio: 2,
            ),
            children: <Widget>[
              _buildTypeWidget(
                  'movie', context, 'assets/images/movie_search.jpg'),
              _buildTypeWidget('tv', context, 'assets/images/tv_search.jpg'),
              _buildTypeWidget(
                  'person', context, 'assets/images/actor_search.jpg'),
            ],
          ),
        )
      ],
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Select Type',
            style: Styles.mBold.copyWith(
              fontSize: 30,
            ),
          ),
          Text(
            'SEARCH',
            style: Styles.mBold.copyWith(
              color: Colors.pinkAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeWidget(String type, BuildContext context, String imageUrl) {
    TMDBRepository tmdbRepo = TMDBRepository(
      tmdbApiClient: TMDBApiClient(
        httpClient: http.Client(),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => SearchResultBloc(
                tmdbRepository: tmdbRepo,
              ),
              child: SearchResultsPage(
                type: type,
              ),
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
            ),
          ),
          child: Center(
            child: Text(
              type.toUpperCase(),
              style: Styles.mBold.copyWith(
                fontSize: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
