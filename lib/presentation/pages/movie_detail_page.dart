import 'package:flutter/material.dart';
import 'package:movie_db_storage/di/injection.dart' as di;
import 'package:share_plus/share_plus.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_movie_detail.dart';
import '../../domain/usecases/toggle_bookmark.dart';
import '../../domain/usecases/get_bookmarks.dart';
import '../../core/utils/constants.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;
  const MovieDetailPage({required this.movieId});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  Movie? movie;
  bool loading = true;
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final usecase = di.sl<GetMovieDetail>();
      final m = await usecase(widget.movieId);

      // Check if bookmarked
      final bookmarksUsecase = di.sl<GetBookmarks>();
      final bookmarks = await bookmarksUsecase.call();
      final bookmarked = bookmarks.any((b) => b.id == widget.movieId);

      setState(() {
        movie = m;
        isBookmarked = bookmarked;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  void _share() {
    final url = '${Constants.deepLinkScheme}${widget.movieId}';
    Share.share('Check this movie: ${movie?.title}\n$url');
  }

  Future<void> _toggleBookmark() async {
    if (movie == null) return;
    final toggleUsecase = di.sl<ToggleBookmark>();
    await toggleUsecase.call(movie!.id);

    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading)
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: CircularProgressIndicator()),
      );
    if (movie == null)
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Not found')),
      );

    final poster = movie!.posterPath != null
        ? '${Constants.imageBaseUrl}${movie!.posterPath}'
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(movie!.title),
        actions: [
          IconButton(icon: Icon(Icons.share), onPressed: _share),
          IconButton(
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: _toggleBookmark,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (poster != null) Image.network(poster),
            SizedBox(height: 12),
            Text(movie!.overview, style: TextStyle(fontSize: 16)),
            SizedBox(height: 12),
            Text('Release Date: ${movie!.releaseDate ?? "Unknown"}'),
          ],
        ),
      ),
    );
  }
}
