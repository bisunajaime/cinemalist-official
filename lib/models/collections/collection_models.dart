import 'dart:convert';

enum CollectionItemType { movie, tvShow, actor }

class CollectionItem {
  final int id;
  final CollectionItemType type;
  final String title;
  final String? posterPath;
  final double? rating;
  final DateTime addedAt;

  CollectionItem({
    required this.id,
    required this.type,
    required this.title,
    this.posterPath,
    this.rating,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'title': title,
        'posterPath': posterPath,
        'rating': rating,
        'addedAt': addedAt.toIso8601String(),
      };

  factory CollectionItem.fromJson(Map<String, dynamic> json) => CollectionItem(
        id: json['id'],
        type: CollectionItemType.values.firstWhere((e) => e.name == json['type']),
        title: json['title'],
        posterPath: json['posterPath'],
        rating: json['rating']?.toDouble(),
        addedAt: DateTime.parse(json['addedAt']),
      );

  String get uniqueKey => '${type.name}_$id';

  @override
  bool operator ==(Object other) =>
      other is CollectionItem && other.id == id && other.type == type;

  @override
  int get hashCode => id.hashCode ^ type.hashCode;
}

class Collection {
  final String id;
  final String name;
  final String? icon;
  final bool isDefault;
  final List<CollectionItem> movies;
  final List<CollectionItem> tvShows;
  final List<CollectionItem> actors;
  final DateTime createdAt;

  Collection({
    required this.id,
    required this.name,
    this.icon,
    this.isDefault = false,
    required this.movies,
    required this.tvShows,
    required this.actors,
    required this.createdAt,
  });

  int get totalCount => movies.length + tvShows.length + actors.length;
  bool get isEmpty => totalCount == 0;

  List<CollectionItem> get allItems => [...movies, ...tvShows, ...actors]
    ..sort((a, b) => b.addedAt.compareTo(a.addedAt));

  bool containsItem(int itemId, CollectionItemType type) {
    switch (type) {
      case CollectionItemType.movie:
        return movies.any((m) => m.id == itemId);
      case CollectionItemType.tvShow:
        return tvShows.any((t) => t.id == itemId);
      case CollectionItemType.actor:
        return actors.any((a) => a.id == itemId);
    }
  }

  Collection copyWith({
    String? name,
    String? icon,
    List<CollectionItem>? movies,
    List<CollectionItem>? tvShows,
    List<CollectionItem>? actors,
  }) {
    return Collection(
      id: id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      isDefault: isDefault,
      movies: movies ?? this.movies,
      tvShows: tvShows ?? this.tvShows,
      actors: actors ?? this.actors,
      createdAt: createdAt,
    );
  }

  Collection addItem(CollectionItem item) {
    switch (item.type) {
      case CollectionItemType.movie:
        if (movies.any((m) => m.id == item.id)) return this;
        return copyWith(movies: [...movies, item]);
      case CollectionItemType.tvShow:
        if (tvShows.any((t) => t.id == item.id)) return this;
        return copyWith(tvShows: [...tvShows, item]);
      case CollectionItemType.actor:
        if (actors.any((a) => a.id == item.id)) return this;
        return copyWith(actors: [...actors, item]);
    }
  }

  Collection removeItem(int itemId, CollectionItemType type) {
    switch (type) {
      case CollectionItemType.movie:
        return copyWith(movies: movies.where((m) => m.id != itemId).toList());
      case CollectionItemType.tvShow:
        return copyWith(tvShows: tvShows.where((t) => t.id != itemId).toList());
      case CollectionItemType.actor:
        return copyWith(actors: actors.where((a) => a.id != itemId).toList());
    }
  }

  factory Collection.create(String name, {String? icon, bool isDefault = false}) {
    return Collection(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      icon: icon,
      isDefault: isDefault,
      movies: [],
      tvShows: [],
      actors: [],
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'isDefault': isDefault,
        'movies': movies.map((m) => m.toJson()).toList(),
        'tvShows': tvShows.map((t) => t.toJson()).toList(),
        'actors': actors.map((a) => a.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        id: json['id'],
        name: json['name'],
        icon: json['icon'],
        isDefault: json['isDefault'] ?? false,
        movies: (json['movies'] as List).map((m) => CollectionItem.fromJson(m)).toList(),
        tvShows: (json['tvShows'] as List).map((t) => CollectionItem.fromJson(t)).toList(),
        actors: (json['actors'] as List).map((a) => CollectionItem.fromJson(a)).toList(),
        createdAt: DateTime.parse(json['createdAt']),
      );
}
