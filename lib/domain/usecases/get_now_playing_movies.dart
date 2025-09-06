import '../repositories/movie_repository.dart';
import '../entities/movie.dart';

class GetNowPlayingMovies {
  final MovieRepository repository;
  GetNowPlayingMovies(this.repository);

  Future<List<Movie>> call({int page = 1}) {
    return repository.getNowPlaying(page);
  }
}
