import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../di/injection.dart';
import '../../core/utils/constants.dart';
import '../../domain/entities/movie.dart';
import '../blocs/bookmarks/bookmarks_bloc.dart';
import '../blocs/bookmarks/bookmarks_event.dart';
import '../blocs/bookmarks/bookmarks_state.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  Widget _buildMovieImage(String? posterPath) {
    if (posterPath == null) {
      return Container(width: 80, height: 120, color: Colors.grey);
    }
    if (posterPath.startsWith('/')) {
      return Image.network(
        '${Constants.imageBaseUrl}$posterPath',
        width: 80,
        height: 120,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        File(posterPath),
        width: 80,
        height: 120,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          BookmarksBloc(getBookmarks: sl(), toggleBookmark: sl())
            ..add(LoadBookmarksEvent()),
      child: Scaffold(
        appBar: AppBar(title: Text("Bookmarks")),
        body: BlocBuilder<BookmarksBloc, BookmarksState>(
          builder: (context, state) {
            if (state is BookmarksLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is BookmarksLoaded) {
              if (state.movies.isEmpty) {
                return Center(child: Text("No bookmarks yet."));
              }
              return ListView.builder(
                itemCount: state.movies.length,
                itemBuilder: (_, index) {
                  final movie = state.movies[index];
                  return ListTile(
                    leading: _buildMovieImage(movie.posterPath),
                    title: Text(movie.title),
                    subtitle: Text(movie.overview),
                    trailing: IconButton(
                      icon: Icon(Icons.bookmark_remove),
                      onPressed: () {
                        context.read<BookmarksBloc>().add(
                          ToggleBookmarkEvent(movie.id),
                        );
                      },
                    ),
                  );
                },
              );
            } else if (state is BookmarksError) {
              return Center(child: Text(state.message));
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
