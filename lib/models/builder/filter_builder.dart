enum SortFilterOrderOptions {
  ascending,
  descending,
}

enum SortFilterOptions {
  popularity,
}

enum AppendToResponseOptions {
  videos,
}

class FilterBuilder {
  String? _sortBy;
  String? _includeAdult;
  String? _withCast;
  String? _query;
  int? _withGenres;
  String? _includeVideo;
  int? _page;
  String? _appendToResponse;

  static final _filterOptions = <SortFilterOptions, String>{
    SortFilterOptions.popularity: 'popularity',
  };
  static final _filterOrderOptions = <SortFilterOrderOptions, String>{
    SortFilterOrderOptions.ascending: 'asc',
    SortFilterOrderOptions.descending: 'desc',
  };

  static final _appendToResponseOptions = <AppendToResponseOptions, String>{
    AppendToResponseOptions.videos: 'videos',
  };

  /// [sortBy] - defaults to sort by popularity and descending order
  FilterBuilder sortBy({
    SortFilterOptions filter = SortFilterOptions.popularity,
    SortFilterOrderOptions order = SortFilterOrderOptions.descending,
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

  FilterBuilder appendToResponse(
      {AppendToResponseOptions appendToResponse =
          AppendToResponseOptions.videos}) {
    _appendToResponse = _appendToResponseOptions[appendToResponse];
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
      'append_to_response': '$_appendToResponse',
    };
    json.removeWhere((key, value) => value == 'null');
    return json;
  }
}
