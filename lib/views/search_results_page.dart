import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdbflutter/barrels/models.dart';
import 'package:tmdbflutter/bloc/search/search_bloc.dart';
import 'package:tmdbflutter/models/actor_info_model.dart';
import 'package:tmdbflutter/models/tvshow_model.dart';
import 'package:tmdbflutter/styles/styles.dart';
import 'package:tmdbflutter/views/actor_info_page.dart';
import 'package:tmdbflutter/views/movie_page.dart';
import 'package:tmdbflutter/views/tvshow_page.dart';

class SearchResultsPage extends StatefulWidget {
  final String? type;
  SearchResultsPage({this.type});

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  ScrollController controller = new ScrollController();
  final scrollThreshold = 200;
  TextEditingController searchController = TextEditingController();
  late SearchResultBloc _searchResultBloc;
  @override
  void initState() {
    super.initState();
//    controller.addListener(_onScroll);
    _searchResultBloc = BlocProvider.of<SearchResultBloc>(context);
  }

  @override
  void dispose() {
    controller.dispose();
    searchController.dispose();
    super.dispose();
  }

  // void _onScroll() {
  //   final maxScroll = controller.position.maxScrollExtent;
  //   final currentScroll = controller.position.pixels;
  //   if (maxScroll - currentScroll <= scrollThreshold) {
  //     _searchResultBloc.add(FetchSearchResults(
  //       query: searchController.text.trim(),
  //       type: widget.type,
  //     ));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          widget.type!.toUpperCase(),
          style: Styles.mMed,
        ),
      ),
      backgroundColor: Color(0xff0E0E0E),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            buildSearchbar(),
            SizedBox(
              height: 10,
            ),
            buildSearchResults(),
          ],
        ),
      ),
    );
  }

  BlocBuilder<SearchResultBloc, SearchState> buildSearchResults() {
    return BlocBuilder<SearchResultBloc, SearchState>(
      builder: (context, state) {
        if (state is HasNotSearched || searchController.text.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10),
              CircularProgressIndicator(
                backgroundColor: Colors.pinkAccent[100],
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff2e2e2e)),
              ),
              SizedBox(height: 10),
              Text(
                'To search or not to search',
                style: Styles.mReg,
              ),
            ],
          );
        }
        if (state is SearchError) {
          return Text(
            'There was a problem...',
            style: Styles.mMed,
          );
        }
        if (state is SearchIsLoading) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10),
              CircularProgressIndicator(
                backgroundColor: Colors.pinkAccent[100],
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff2e2e2e)),
              ),
              SizedBox(height: 10),
              Text(
                'To search or not to search',
                style: Styles.mReg,
              ),
            ],
          );
        }
        if (state is SearchResultsLoaded) {
          if (state.searchModel is List<GenericMoviesModel>) {
            List<GenericMoviesModel> result =
                state.searchModel as List<GenericMoviesModel>;
            result.removeWhere((element) => element.posterPath == null);
            return Expanded(
              child: GridView.builder(
                  controller: controller,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: result.length,
                  itemBuilder: (context, i) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MoviePage(
                            model: result[i],
                            tag: 'search ${result[i].posterPath}',
                          ),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xff2e2e2e),
                          image: DecorationImage(
                            image: (result[i].posterPath == null
                                ? AssetImage('assets/images/placeholder.png')
                                : NetworkImage(
                                    'https://image.tmdb.org/t/p/w500${result[i].posterPath}',
                                  )) as ImageProvider<Object>,
                            colorFilter: ColorFilter.mode(
                              Colors.black26,
                              BlendMode.darken,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          result[i].title!,
                          style: Styles.mReg.copyWith(
                            fontSize: 10,
                          ),
                        ),
                      ),
                    );
                  }),
            );
          }

          if (state.searchModel is List<ActorInfoModel>) {
            List<ActorInfoModel> result =
                state.searchModel as List<ActorInfoModel>;

            result.removeWhere((element) => element.profilePath == null);
            return Expanded(
              child: GridView.builder(
                  controller: controller,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: result.length,
                  itemBuilder: (context, i) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ActorInfoPage(
                            id: result[i].id,
                          ),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xff2e2e2e),
                          image: DecorationImage(
                            image: (result[i].profilePath == null
                                ? AssetImage('assets/images/placeholder.png')
                                : NetworkImage(
                                    'https://image.tmdb.org/t/p/w500${result[i].profilePath}',
                                  )) as ImageProvider<Object>,
                            colorFilter: ColorFilter.mode(
                              Colors.black26,
                              BlendMode.darken,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          result[i].name!,
                          style: Styles.mReg.copyWith(
                            fontSize: 10,
                          ),
                        ),
                      ),
                    );
                  }),
            );
          }
          if (state.searchModel is List<TVShowModel>) {
            List<TVShowModel> result = state.searchModel as List<TVShowModel>;
            result.removeWhere((element) => element.posterPath == null);
            return Expanded(
              child: GridView.builder(
                  controller: controller,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: result.length,
                  itemBuilder: (context, i) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TvShowPage(
                            model: result[i],
                          ),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xff2e2e2e),
                          image: DecorationImage(
                            image: (result[i].posterPath == null
                                ? AssetImage('assets/images/placeholder.png')
                                : NetworkImage(
                                    'https://image.tmdb.org/t/p/w500${result[i].posterPath}',
                                  )) as ImageProvider<Object>,
                            colorFilter: ColorFilter.mode(
                              Colors.black26,
                              BlendMode.darken,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          result[i].name!,
                          style: Styles.mReg.copyWith(
                            fontSize: 10,
                          ),
                        ),
                      ),
                    );
                  }),
            );
          }
        }

        return Text(
          'Type something...',
          style: Styles.mMed,
        );
      },
    );
  }

  Padding buildSearchbar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: TextField(
        controller: searchController,
        style: Styles.mReg.copyWith(
          color: Colors.pinkAccent[100],
        ),
        onChanged: (q) {
          _searchResultBloc.add(
            FetchSearchResults(type: widget.type, query: q),
          );
        },
        onSubmitted: (q) {},
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Colors.pinkAccent[100],
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              _searchResultBloc.drain();
              _searchResultBloc.add(FetchSearchResults(
                type: widget.type,
                query: searchController.text,
              ));
              searchController.clear();
            },
            child: Icon(
              Icons.backspace,
              color: Colors.pinkAccent[100],
            ),
          ),
          filled: true,
          fillColor: Color(0xff2e2e2e),
          hintText: 'Search here',
          hintStyle: Styles.mReg.copyWith(
            color: Colors.pinkAccent[100],
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
