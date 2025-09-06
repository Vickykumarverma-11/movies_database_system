import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasource/movie_local_data_source.dart';
import '../datasource/movie_remote_data_source.dart';
import '../models/movie_model.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieLocalDataSource localDataSource;
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  // Bookmarks
  @override
  Future<List<Movie>> getBookmarks() async {
    final ids = await localDataSource.getBookmarks();
    final movies = <Movie>[];
    for (var id in ids) {
      final movie = await remoteDataSource.getMovieDetail(id);
      movies.add(movie.toEntity());
    }
    return movies;
  }

  @override
  Future<void> toggleBookmark(int movieId) async {
    final ids = await localDataSource.getBookmarks();
    if (ids.contains(movieId)) {
      await localDataSource.removeBookmark(movieId);
    } else {
      await localDataSource.saveBookmark(movieId);
    }
  }

  @override
  Future<Movie> getMovieDetail(int id) async {
    final movieModel = await remoteDataSource.getMovieDetail(id);
    return movieModel.toEntity();
  }

  // Trending / Now Playing / Search
  @override
  Future<List<Movie>> getTrending(int page) async {
    final models = await remoteDataSource.getTrending(page);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Movie>> getNowPlaying(int page) async {
    final models = await remoteDataSource.getNowPlaying(page);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Movie>> searchMovies(String query, int page) async {
    final models = await remoteDataSource.searchMovies(query, page);
    return models.map((m) => m.toEntity()).toList();
  }
}
