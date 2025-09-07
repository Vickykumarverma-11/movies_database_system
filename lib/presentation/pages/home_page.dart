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
        appBar: AppBar(
          title: Text('Movies'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchPage()),
              ),
            ),
            IconButton(
              icon: Icon(Icons.bookmarks),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BookmarksPage()),
              ),
            ),
          ],
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.loading)
              return Center(child: CircularProgressIndicator());
            if (state.error != null)
              return Center(child: Text('Error: ${state.error}'));
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Section(title: 'Trending', movies: state.trending),
                  Section(title: 'Now Playing', movies: state.nowPlaying),
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
          padding: EdgeInsets.all(12),
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (_, idx) => MovieCard(movie: movies[idx]),
          ),
        ),
      ],
    );
  }
}
