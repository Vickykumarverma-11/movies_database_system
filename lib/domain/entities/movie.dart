class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? releaseDate;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.releaseDate,
  });
}
