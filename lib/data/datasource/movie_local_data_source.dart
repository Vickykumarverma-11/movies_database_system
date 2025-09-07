// lib/data/datasource/movie_local_data_source.dart
import 'package:hive/hive.dart';
import 'dart:convert';
import '../../domain/entities/movie.dart';

abstract class MovieLocalDataSource {
  Future<void> cacheMovies(String key, List<Map<String, dynamic>> moviesJson);
  Future<List<Movie>> getCachedMovies(String key);
  Future<void> saveBookmark(int movieId);
  Future<void> removeBookmark(int movieId);
  Future<List<int>> getBookmarks();
  Future<Map<String, dynamic>?> getCachedMeta(String key);
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final Box _box;

  MovieLocalDataSourceImpl(this._box);

  @override
  Future<void> cacheMovies(
    String key,
    List<Map<String, dynamic>> moviesJson,
  ) async {
    final payload = {
      'timestamp': DateTime.now().toIso8601String(),
      'data': moviesJson,
    };
    await _box.put(key, jsonEncode(payload));
  }

  @override
  Future<List<Movie>> getCachedMovies(String key) async {
    final raw = _box.get(key) as String?;
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final list = (decoded['data'] as List).cast<Map<String, dynamic>>();
    // convert each JSON map to MovieModel? We don't want to re-declare MovieModel here,
    // so construct Movie from map fields (safe minimal mapping)
    return list.map((e) {
      return Movie(
        id: (e['id'] as num).toInt(),
        title: e['title'] ?? '',
        overview: e['overview'] ?? '',
        posterPath: e['poster_path'] ?? e['posterPath'] ?? null,
        releaseDate: e['release_date'] ?? e['releaseDate'] ?? null,
      );
    }).toList();
  }

  @override
  Future<Map<String, dynamic>?> getCachedMeta(String key) async {
    final raw = _box.get(key) as String?;
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  @override
  Future<void> saveBookmark(int movieId) async {
    final setKey = 'bookmarks';
    List<int> current = List<int>.from(_box.get(setKey, defaultValue: <int>[]));
    if (!current.contains(movieId)) {
      current.add(movieId);
      await _box.put(setKey, current);
    }
  }

  @override
  Future<void> removeBookmark(int movieId) async {
    final setKey = 'bookmarks';
    List<int> current = List<int>.from(_box.get(setKey, defaultValue: <int>[]));
    if (current.contains(movieId)) {
      current.remove(movieId);
      await _box.put(setKey, current);
    }
  }

  @override
  Future<List<int>> getBookmarks() async {
    return List<int>.from(_box.get('bookmarks', defaultValue: <int>[]));
  }
}
