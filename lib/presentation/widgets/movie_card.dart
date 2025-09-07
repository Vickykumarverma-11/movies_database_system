import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/movie.dart';
import '../../core/utils/constants.dart';
import '../pages/movie_detail_page.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final double width;
  final double radius;
  final double elevation;

  const MovieCard({
    Key? key,
    required this.movie,
    this.width = 150,
    this.radius = 12,
    this.elevation = 6,
  }) : super(key: key);

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
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black87,
              blurRadius: elevation,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Stack(
            children: [
              // Poster Image
              poster != null
                  ? CachedNetworkImage(
                      imageUrl: poster,
                      height: 220,
                      width: width,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.broken_image,
                        size: 40,
                        color: Colors.grey,
                      ),
                    )
                  : Container(
                      height: 220,
                      color: Colors.grey[900],
                      child: const Center(
                        child: Text(
                          'No image',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

              // Gradient overlay for title
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          offset: Offset(1, 1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
