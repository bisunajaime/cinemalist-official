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
        Padding(
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
        ),
        SizedBox(height: 10),
        Expanded(
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
              childAspectRatio: .9,
            ),
            children: <Widget>[
              _buildTypeWidget('movie', context),
              _buildTypeWidget('tv', context),
              _buildTypeWidget('person', context),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildTypeWidget(String type, BuildContext context) {
    TMDBRepository tmdbRepo = TMDBRepository(
      tmdbApiClient: TMDBApiClient(
        httpClient: http.Client(),
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: FlatButton(
        onPressed: () => Navigator.push(
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
        color: Color(0xff2e2e2e),
        child: Center(
          child: Text(
            type.toUpperCase(),
            style: Styles.mBold.copyWith(
              color: Colors.pinkAccent[100],
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
