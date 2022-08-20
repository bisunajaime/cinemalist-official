enum SortFilterOrder {
  ascending,
  descending,
}

enum SortFilter {
  popularity,
}

class FilterBuilder {
  String? _sortBy;
  String? _includeAdult;
  String? _withCast;
  String? _query;
  int? _withGenres;
  String? _includeVideo;
  int? _page;

  static final _filterOptions = <SortFilter, String>{
    SortFilter.popularity: 'popularity',
  };
  static final _filterOrderOptions = <SortFilterOrder, String>{
    SortFilterOrder.ascending: 'asc',
    SortFilterOrder.descending: 'desc',
  };

  /// [sortBy] - defaults to sort by popularity and descending order
  FilterBuilder sortBy({
    SortFilter filter = SortFilter.popularity,
    SortFilterOrder order = SortFilterOrder.descending,
  }) {
    _sortBy = '${_filterOptions[filter]}.${_filterOrderOptions[order]}';
    return this;
  }

  FilterBuilder includeAdult({bool? include = true}) {
    _includeAdult = '$include';
    return this;
  }

  FilterBuilder page(int? p) {
    _page = p;
    return this;
  }

  FilterBuilder withCast(int? id) {
    _withCast = '$id';
    return this;
  }

  FilterBuilder withGenres(int? genreId) {
    _withGenres = genreId;
    return this;
  }

  FilterBuilder includeVideo({bool? includeVideo = true}) {
    _includeVideo = '$includeVideo';
    return this;
  }

  FilterBuilder query(String? searchString) {
    _query = searchString;
    return this;
  }

  /// [defaultState]
  /// * page = 1
  /// * includes video
  /// * sorts by popularity desc
  /// * includes adult
  static FilterBuilder defaultState() {
    final builder = FilterBuilder();
    return builder.page(1).includeVideo().sortBy().includeAdult();
  }

  Map<String, dynamic> toJson() {
    final json = {
      'sort_by': '$_sortBy',
      'include_adult': '$_includeAdult',
      'include_video': '$_includeVideo',
      'page': '$_page',
      'with_cast': '$_withCast',
      'with_genres': '$_withGenres',
      'query': '$_query',
    };
    json.removeWhere((key, value) => value == 'null');
    return json;
  }
}
