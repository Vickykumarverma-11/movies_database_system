import '../entities/movie.dart';

abstract class MovieRepository {
  // Existing
  Future<List<Movie>> getBookmarks();
  Future<void> toggleBookmark(int movieId);
  Future<Movie> getMovieDetail(int id);

  // Add these methods
  Future<List<Movie>> getTrending(int page);
  Future<List<Movie>> getNowPlaying(int page);
  Future<List<Movie>> searchMovies(String query, int page);
}
