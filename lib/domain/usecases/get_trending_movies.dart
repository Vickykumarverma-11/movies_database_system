import '../repositories/movie_repository.dart';
import '../entities/movie.dart';

class GetTrendingMovies {
  final MovieRepository repository;
  GetTrendingMovies(this.repository);

  Future<List<Movie>> call({int page = 1}) {
    return repository.getTrending(page);
  }
}
