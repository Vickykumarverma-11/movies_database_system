import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_db_storage/presentation/blocs/home/home_bloc.dart';
import 'package:movie_db_storage/presentation/blocs/home/home_event.dart';
import 'package:movie_db_storage/presentation/blocs/home/home_state.dart';
import 'package:movie_db_storage/presentation/widgets/movie_card.dart';

import '../../di/injection.dart' as di;
import '../../domain/usecases/get_trending_movies.dart';
import '../../domain/usecases/get_now_playing_movies.dart';
import 'search_page.dart';
import 'bookmarks_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(
        getTrending: di.sl<GetTrendingMovies>(),
        getNowPlaying: di.sl<GetNowPlayingMovies>(),
      )..add(LoadHome()),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Colors.black,
          title: Text(
            'Movies',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchPage()),
              ),
            ),
            IconButton(
              icon: Icon(Icons.bookmarks, color: Colors.white),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BookmarksPage()),
              ),
            ),
          ],
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.loading) {
              return Center(
                child: CircularProgressIndicator(color: Colors.deepPurple),
              );
            }
            if (state.error != null) {
              return Center(
                child: Text(
                  'Error: ${state.error}',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              );
            }
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Section(title: '🔥 Trending', movies: state.trending),
                  SizedBox(height: 20),
                  Section(title: '🎬 Now Playing', movies: state.nowPlaying),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final List movies;
  Section({required this.title, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent,
            ),
          ),
        ),
        SizedBox(
          height: 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: movies.length,
            separatorBuilder: (_, __) => SizedBox(width: 16),
            itemBuilder: (_, idx) {
              final movie = movies[idx];
              return MovieCard(movie: movie, radius: 12, elevation: 6);
            },
          ),
        ),
      ],
    );
  }
}
