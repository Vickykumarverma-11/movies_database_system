import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_db_storage/di/injection.dart';
import 'package:movie_db_storage/presentation/blocs/home/home_bloc.dart';
import 'package:movie_db_storage/presentation/blocs/home/home_event.dart';
import 'package:movie_db_storage/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetIt (DI)
  await init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>(
            create: (_) => HomeBloc(
              getTrending: sl(),
              getNowPlaying: sl(),
              getTrendingMovies: sl(),
              getNowPlayingMovies: sl(), // sl<GetNowPlayingMovies>()
            )..add(LoadHome()), // Optional: trigger initial load
          ),
          // Add other Blocs if needed
        ],
        child: HomePage(),
      ),
    );
  }
}
