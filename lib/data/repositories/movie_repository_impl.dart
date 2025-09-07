// lib/data/repositories/movie_repository_impl.dart
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasource/movie_local_data_source.dart';
import '../datasource/movie_remote_data_source.dart';
import '../models/movie_model.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remote;
  final MovieLocalDataSource local;

  MovieRepositoryImpl({required this.remote, required this.local});

  // TRENDING
  @override
  Future<List<Movie>> getTrending(int page) async {
    final cacheKey = 'trending_$page';
    try {
      final models = await remote.getTrending(page);
      // cache raw JSON for offline fallback
      await local.cacheMovies(cacheKey, models.map((m) => m.toJson()).toList());
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      // fallback to cache (may be empty)
      final cached = await local.getCachedMovies(cacheKey);
      return cached;
    }
  }

  // NOW PLAYING
  @override
  Future<List<Movie>> getNowPlaying(int page) async {
    final cacheKey = 'now_playing_$page';
    try {
      final models = await remote.getNowPlaying(page);
      await local.cacheMovies(cacheKey, models.map((m) => m.toJson()).toList());
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      final cached = await local.getCachedMovies(cacheKey);
      return cached;
    }
  }

  // SEARCH - keep online (no cache)
  @override
  Future<List<Movie>> searchMovies(String query, int page) async {
    final models = await remote.searchMovies(query, page);
    return models.map((m) => m.toEntity()).toList();
  }

  // MOVIE DETAIL - cache single movie under movie_{id}
  @override
  Future<Movie> getMovieDetail(int id) async {
    final cacheKey = 'movie_$id';
    try {
      final model = await remote.getMovieDetail(id);
      await local.cacheMovies(cacheKey, [model.toJson()]);
      return model.toEntity();
    } catch (e) {
      final cached = await local.getCachedMovies(cacheKey);
      if (cached.isNotEmpty) return cached.first;
      rethrow; // let caller handle if nothing in cache
    }
  }

  // BOOKMARKS: local storage keeps IDs; we return full Movie objects by resolving details (from cache or remote)
  @override
  Future<List<Movie>> getBookmarks() async {
    final ids = await local.getBookmarks(); // List<int>
    final movies = <Movie>[];
    for (final id in ids) {
      try {
        // getMovieDetail will try remote then cache — good for offline
        final m = await getMovieDetail(id);
        movies.add(m);
      } catch (_) {
        // ignore individual failures, continue
      }
    }
    return movies;
  }

  @override
  Future<void> toggleBookmark(int movieId) async {
    final ids = await local.getBookmarks();
    if (ids.contains(movieId)) {
      await local.removeBookmark(movieId);
    } else {
      await local.saveBookmark(movieId);
    }
  }
}
