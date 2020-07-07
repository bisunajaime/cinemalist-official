class Videos {
    List<Result> results;

    Videos({this.results});

    factory Videos.fromJson(Map<String, dynamic> json) {
        return Videos(
            results: json['results'] != null ? (json['results'] as List).map((i) => Result.fromJson(i)).toList() : null, 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if (this.results != null) {
            data['results'] = this.results.map((v) => v.toJson()).toList();
        }
        return data;
    }
}