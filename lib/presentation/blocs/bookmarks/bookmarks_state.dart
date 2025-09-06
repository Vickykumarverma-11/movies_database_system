import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

abstract class BookmarksState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookmarksInitial extends BookmarksState {}

class BookmarksLoading extends BookmarksState {}

class BookmarksLoaded extends BookmarksState {
  final List<Movie> movies;

  BookmarksLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

class BookmarksError extends BookmarksState {
  final String message;

  BookmarksError(this.message);

  @override
  List<Object?> get props => [message];
}
