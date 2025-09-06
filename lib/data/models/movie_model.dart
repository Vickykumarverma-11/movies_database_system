import '../../domain/entities/movie.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel extends Movie {
  @JsonKey(name: 'id')
  final int movieId;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'overview')
  final String overview;

  @JsonKey(name: 'poster_path')
  final String? posterPath;

  @JsonKey(name: 'release_date')
  final String? releaseDate;

  MovieModel({
    required this.movieId,
    required this.title,
    required this.overview,
    this.posterPath,
    this.releaseDate,
  }) : super(
         id: movieId,
         title: title,
         overview: overview,
         posterPath: posterPath,
         releaseDate: releaseDate,
       );

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);

  Movie toEntity() {
    return Movie(
      id: movieId,
      title: title,
      overview: overview,
      posterPath: posterPath,
      releaseDate: releaseDate,
    );
  }
}
