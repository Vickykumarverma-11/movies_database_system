import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetBookmarks {
  final MovieRepository repository;

  GetBookmarks(this.repository);

  Future<List<Movie>> call() async {
    return repository.getBookmarks();
  }
}
