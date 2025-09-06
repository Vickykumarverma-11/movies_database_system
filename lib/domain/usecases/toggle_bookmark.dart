import '../repositories/movie_repository.dart';

class ToggleBookmark {
  final MovieRepository repository;
  ToggleBookmark(this.repository);

  Future<void> call(int movieId) {
    return repository.toggleBookmark(movieId);
  }
}
