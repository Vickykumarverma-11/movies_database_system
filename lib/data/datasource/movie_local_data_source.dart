import 'package:hive/hive.dart';
import '../../domain/entities/movie.dart';
import 'dart:convert';

abstract class MovieLocalDataSource {
  Future<void> saveBookmark(int movieId);
  Future<void> removeBookmark(int movieId);
  Future<List<int>> getBookmarks();
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final Box _box;
  final String _key = 'bookmarks';

  MovieLocalDataSourceImpl(this._box);

  @override
  Future<void> saveBookmark(int movieId) async {
    final current = List<int>.from(_box.get(_key, defaultValue: <int>[]));
    if (!current.contains(movieId)) {
      current.add(movieId);
      await _box.put(_key, current);
    }
  }

  @override
  Future<void> removeBookmark(int movieId) async {
    final current = List<int>.from(_box.get(_key, defaultValue: <int>[]));
    if (current.contains(movieId)) {
      current.remove(movieId);
      await _box.put(_key, current);
    }
  }

  @override
  Future<List<int>> getBookmarks() async {
    return List<int>.from(_box.get(_key, defaultValue: <int>[]));
  }
}
