import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinemalist/models/collections/collection_models.dart';
import 'package:cinemalist/repository/localstorage_repository/localstorage_repository.dart';

class CollectionsState {
  final List<Collection> collections;
  final bool isLoading;

  const CollectionsState({this.collections = const [], this.isLoading = false});

  CollectionsState copyWith({List<Collection>? collections, bool? isLoading}) {
    return CollectionsState(
      collections: collections ?? this.collections,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// All movies across all collections (deduplicated)
  List<CollectionItem> get allMovies {
    final seen = <int>{};
    final result = <CollectionItem>[];
    for (final c in collections) {
      for (final m in c.movies) {
        if (seen.add(m.id)) result.add(m);
      }
    }
    return result;
  }

  List<CollectionItem> get allTvShows {
    final seen = <int>{};
    final result = <CollectionItem>[];
    for (final c in collections) {
      for (final t in c.tvShows) {
        if (seen.add(t.id)) result.add(t);
      }
    }
    return result;
  }

  List<CollectionItem> get allActors {
    final seen = <int>{};
    final result = <CollectionItem>[];
    for (final c in collections) {
      for (final a in c.actors) {
        if (seen.add(a.id)) result.add(a);
      }
    }
    return result;
  }

  bool isItemSaved(int id, CollectionItemType type) {
    return collections.any((c) => c.containsItem(id, type));
  }

  List<Collection> collectionsContaining(int id, CollectionItemType type) {
    return collections.where((c) => c.containsItem(id, type)).toList();
  }
}

class CollectionsCubit extends Cubit<CollectionsState> {
  final LocalStorageRepository _storage;

  CollectionsCubit()
      : _storage = FileLocalStorageRepository('collections.json'),
        super(const CollectionsState()) {
    _load();
  }

  Future<void> _load() async {
    emit(state.copyWith(isLoading: true));
    final data = await _storage.retrieve();
    List<Collection> collections;
    if (data == null) {
      collections = [Collection.create('Bookmarks', icon: 'bookmark', isDefault: true)];
      await _save(collections);
    } else {
      try {
        collections = (jsonDecode(data) as List).map((e) => Collection.fromJson(e)).toList();
      } catch (_) {
        collections = [Collection.create('Bookmarks', icon: 'bookmark', isDefault: true)];
      }
    }
    emit(CollectionsState(collections: collections));
  }

  Future<void> _save(List<Collection> collections) async {
    await _storage.save(jsonEncode(collections.map((c) => c.toJson()).toList()));
  }

  Future<void> createCollection(String name, {String? icon}) async {
    final collection = Collection.create(name, icon: icon);
    final updated = [...state.collections, collection];
    emit(state.copyWith(collections: updated));
    await _save(updated);
  }

  Future<void> renameCollection(String id, String name) async {
    final updated = state.collections.map((c) => c.id == id ? c.copyWith(name: name) : c).toList();
    emit(state.copyWith(collections: updated));
    await _save(updated);
  }

  Future<void> deleteCollection(String id) async {
    final updated = state.collections.where((c) => c.id != id).toList();
    emit(state.copyWith(collections: updated));
    await _save(updated);
  }

  Future<void> addItemToCollection(String collectionId, CollectionItem item) async {
    final updated = state.collections.map((c) {
      if (c.id == collectionId) return c.addItem(item);
      return c;
    }).toList();
    emit(state.copyWith(collections: updated));
    await _save(updated);
  }

  Future<void> removeItemFromCollection(String collectionId, int itemId, CollectionItemType type) async {
    final updated = state.collections.map((c) {
      if (c.id == collectionId) return c.removeItem(itemId, type);
      return c;
    }).toList();
    emit(state.copyWith(collections: updated));
    await _save(updated);
  }

  Future<void> addItemToMultipleCollections(List<String> collectionIds, CollectionItem item) async {
    final updated = state.collections.map((c) {
      if (collectionIds.contains(c.id)) return c.addItem(item);
      return c;
    }).toList();
    emit(state.copyWith(collections: updated));
    await _save(updated);
  }

  Future<void> removeItemFromAllCollections(int itemId, CollectionItemType type) async {
    final updated = state.collections.map((c) => c.removeItem(itemId, type)).toList();
    emit(state.copyWith(collections: updated));
    await _save(updated);
  }
}
