import '../repositories/movie_repository.dart';
import '../entities/movie.dart';

class GetMovieDetail {
  final MovieRepository repository;
  GetMovieDetail(this.repository);

  Future<Movie> call(int movieId) {
    return repository.getMovieDetail(movieId);
  }
}
