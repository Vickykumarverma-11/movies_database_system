import '../repositories/movie_repository.dart';
import '../entities/movie.dart';

class SearchMovies {
  final MovieRepository repository;
  SearchMovies(this.repository);

  Future<List<Movie>> call(String query, {int page = 1}) {
    return repository.searchMovies(query, page);
  }
}
