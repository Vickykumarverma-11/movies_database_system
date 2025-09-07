import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../di/injection.dart';
import '../../core/utils/constants.dart';
import '../blocs/bookmarks/bookmarks_bloc.dart';
import '../blocs/bookmarks/bookmarks_event.dart';
import '../blocs/bookmarks/bookmarks_state.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  Widget _buildMovieImage(String? posterPath) {
    if (posterPath == null) {
      return Container(
        width: 80,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
      );
    }

    if (posterPath.startsWith('/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: '${Constants.imageBaseUrl}$posterPath',
          width: 80,
          height: 120,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              Container(width: 80, height: 120, color: Colors.grey[900]),
          errorWidget: (context, url, error) =>
              Container(width: 80, height: 120, color: Colors.red[900]),
        ),
      );
    }

    // Local file
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.file(
        File(posterPath),
        width: 80,
        height: 120,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          BookmarksBloc(getBookmarks: sl(), toggleBookmark: sl())
            ..add(LoadBookmarksEvent()),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Bookmarks",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<BookmarksBloc, BookmarksState>(
          builder: (context, state) {
            if (state is BookmarksLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.deepPurpleAccent,
                ),
              );
            } else if (state is BookmarksLoaded) {
              if (state.movies.isEmpty) {
                return const Center(
                  child: Text(
                    "No bookmarks yet.",
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.movies.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (_, index) {
                  final movie = state.movies[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: _buildMovieImage(movie.posterPath),
                      title: Text(
                        movie.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        movie.overview,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white60),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.bookmark_remove,
                          color: Colors.deepPurpleAccent,
                        ),
                        onPressed: () {
                          context.read<BookmarksBloc>().add(
                            ToggleBookmarkEvent(movie.id),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            } else if (state is BookmarksError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
