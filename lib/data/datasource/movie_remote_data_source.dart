import '../api/tmdb_api_client.dart';
import '../models/movie_model.dart';
import '../../core/utils/constants.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getTrending(int page);
  Future<List<MovieModel>> getNowPlaying(int page);
  Future<List<MovieModel>> searchMovies(String query, int page);
  Future<MovieModel> getMovieDetail(int id);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final TmdbApiClient client;

  MovieRemoteDataSourceImpl(this.client);

  List<MovieModel> _parseList(Map<String, dynamic> json) {
    final results = json['results'] as List;
    return results
        .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<MovieModel>> getTrending(int page) async {
    final resp = await client.getTrending(Constants.tmdbApiKey, page);
    return _parseList(resp.data);
  }

  @override
  Future<List<MovieModel>> getNowPlaying(int page) async {
    final resp = await client.getNowPlaying(Constants.tmdbApiKey, page);
    return _parseList(resp.data);
  }

  @override
  Future<List<MovieModel>> searchMovies(String query, int page) async {
    final resp = await client.searchMovies(Constants.tmdbApiKey, query, page);
    return _parseList(resp.data);
  }

  @override
  Future<MovieModel> getMovieDetail(int id) async {
    final resp = await client.getMovieDetail(id, Constants.tmdbApiKey);
    return MovieModel.fromJson(resp.data);
  }
}
