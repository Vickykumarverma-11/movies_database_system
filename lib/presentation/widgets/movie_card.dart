import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';
import '../../core/utils/constants.dart';
import '../pages/movie_detail_page.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    final poster = movie.posterPath != null
        ? '${Constants.imageBaseUrl}${movie.posterPath}'
        : null;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MovieDetailPage(movieId: movie.id)),
        );
      },
      child: Container(
        width: 140,
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            poster != null
                ? Image.network(poster, height: 190, fit: BoxFit.cover)
                : Container(
                    height: 190,
                    color: Colors.grey,
                    child: Center(child: Text('No image')),
                  ),
            SizedBox(height: 6),
            Text(movie.title, maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
