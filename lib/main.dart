import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_db_storage/di/injection.dart';
import 'package:movie_db_storage/di/injection.dart' as di;
import 'package:movie_db_storage/domain/usecases/get_now_playing_movies.dart';
import 'package:movie_db_storage/domain/usecases/get_trending_movies.dart';
import 'package:movie_db_storage/presentation/blocs/home/home_bloc.dart';
import 'package:movie_db_storage/presentation/blocs/home/home_event.dart';
import 'package:movie_db_storage/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // open boxes for caching
  await Hive.openBox('moviesCache');

  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>(
            create: (_) => HomeBloc(
              getTrending: di.sl<GetTrendingMovies>(),
              getNowPlaying: di.sl<GetNowPlayingMovies>(),
            )..add(LoadHome()),
            // Optional: trigger initial load
          ),
          // Add other Blocs if needed
        ],
        child: HomePage(),
      ),
    );
  }
}
