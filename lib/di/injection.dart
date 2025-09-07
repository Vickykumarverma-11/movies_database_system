import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/api/tmdb_api_client.dart';
import '../data/datasource/movie_local_data_source.dart';
import '../data/datasource/movie_remote_data_source.dart';
import '../data/repositories/movie_repository_impl.dart';
import '../domain/repositories/movie_repository.dart';
import '../domain/usecases/get_trending_movies.dart';
import '../domain/usecases/get_now_playing_movies.dart';
import '../domain/usecases/search_movies.dart';
import '../domain/usecases/get_movie_detail.dart';
import '../domain/usecases/toggle_bookmark.dart';
import '../domain/usecases/get_bookmarks.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Initialize Hive
  await Hive.initFlutter();
  final box = await Hive.openBox('app_box');

  // Dio + Retrofit
  final dio = Dio();
  dio.options.baseUrl = 'https://api.themoviedb.org/3';
  sl.registerLazySingleton(() => dio);
  sl.registerLazySingleton(() => TmdbApiClient(dio));

  // Data sources (only once ❌ no duplicates)
  sl.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(box),
  );
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(sl<TmdbApiClient>()),
  );

  // Repository
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(remote: sl(), local: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTrendingMovies(sl()));
  sl.registerLazySingleton(() => GetNowPlayingMovies(sl()));
  sl.registerLazySingleton(() => SearchMovies(sl()));
  sl.registerLazySingleton(() => GetMovieDetail(sl()));
  sl.registerLazySingleton(() => ToggleBookmark(sl()));
  sl.registerLazySingleton(() => GetBookmarks(sl()));
}
