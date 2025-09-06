import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../core/utils/constants.dart';

part 'tmdb_api_client.g.dart';

@RestApi(baseUrl: Constants.tmdbBaseUrl)
abstract class TmdbApiClient {
  factory TmdbApiClient(Dio dio, {String baseUrl}) = _TmdbApiClient;

  @GET("/trending/movie/day")
  Future<HttpResponse<dynamic>> getTrending(
    @Query("api_key") String apiKey,
    @Query("page") int page,
  );

  @GET("/movie/now_playing")
  Future<HttpResponse<dynamic>> getNowPlaying(
    @Query("api_key") String apiKey,
    @Query("page") int page,
  );

  @GET("/search/movie")
  Future<HttpResponse<dynamic>> searchMovies(
    @Query("api_key") String apiKey,
    @Query("query") String query,
    @Query("page") int page,
  );

  @GET("/movie/{movie_id}")
  Future<HttpResponse<dynamic>> getMovieDetail(
    @Path("movie_id") int id,
    @Query("api_key") String apiKey,
  );
}
